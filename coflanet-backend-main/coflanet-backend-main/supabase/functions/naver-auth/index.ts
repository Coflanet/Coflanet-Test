/**
 * naver-auth Edge Function
 *
 * 네이버 로그인 워크플로우:
 * 1. Flutter에서 Naver SDK로 access_token 획득
 * 2. 이 함수에 code(=access_token) 전달
 * 3. 네이버 프로필 API로 실제 사용자 정보 조회
 * 4. Supabase Admin API로 사용자 생성/조회 + 세션 발급
 * 5. 세션 반환 → Flutter에서 setSession()
 *
 * mode: 'link' → 게스트 계정을 네이버로 전환
 *
 * ⚠️ verify_jwt: false — 로그인 전 호출되므로 JWT 검증 비활성화
 */
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function ok(data: unknown, message?: string) {
  return json({ success: true, data, ...(message && { message }) });
}

function fail(message: string, code: string, status = 400) {
  return json({ success: false, error: { code, message } }, status);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 네이버 프로필 API 호출 (실제 구현)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
interface NaverUser {
  id: string;
  email: string;
  name: string;
  profile_image: string;
}

async function getNaverUser(accessToken: string): Promise<NaverUser> {
  const res = await fetch("https://openapi.naver.com/v1/nid/me", {
    headers: { Authorization: `Bearer ${accessToken}` },
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`네이버 API 오류 (${res.status}): ${text}`);
  }

  const data = await res.json();

  if (data.resultcode !== "00") {
    throw new Error(`네이버 API 실패: ${data.message}`);
  }

  const profile = data.response;
  return {
    id: profile.id,
    email: profile.email || `naver_${profile.id}@naver.coflanet.dev`,
    name: profile.name || profile.nickname || "네이버 사용자",
    profile_image: profile.profile_image || "",
  };
}

Deno.serve(async (req: Request) => {
  // CORS 프리플라이트
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return fail("Only POST is allowed.", "METHOD_NOT_ALLOWED", 405);
  }

  try {
    const body = await req.json().catch(() => ({}));
    const { code, mode } = body as { code?: string; mode?: string };

    if (!code) {
      return fail("authorization_code is required.", "MISSING_CODE");
    }

    const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
    const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get(
      "SUPABASE_SERVICE_ROLE_KEY",
    )!;

    const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // ─── Step 1: 네이버 프로필 API로 실제 사용자 정보 조회 ───
    const naverUser = await getNaverUser(code);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // mode: 'link' → 게스트 → 네이버 계정 전환
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    if (mode === "link") {
      const authHeader = req.headers.get("Authorization");
      if (!authHeader) {
        return fail(
          "link 모드에서는 Authorization 헤더가 필요합니다.",
          "UNAUTHORIZED",
          401,
        );
      }

      // 현재 게스트 세션에서 사용자 확인
      const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
        global: { headers: { Authorization: authHeader } },
      });
      const {
        data: { user: currentUser },
        error: authErr,
      } = await userClient.auth.getUser();

      if (authErr || !currentUser) {
        return fail("현재 세션이 유효하지 않습니다.", "UNAUTHORIZED", 401);
      }

      // 게스트 계정에 네이버 정보 연결
      const { error: updateErr } =
        await supabaseAdmin.auth.admin.updateUserById(currentUser.id, {
          email: naverUser.email,
          email_confirm: true,
          user_metadata: {
            name: naverUser.name,
            avatar_url: naverUser.profile_image,
            provider: "naver",
            naver_id: naverUser.id,
          },
          app_metadata: {
            provider: "naver",
            providers: ["naver"],
          },
        });

      if (updateErr) {
        // 이메일 충돌 (이미 가입된 계정)
        if (updateErr.message?.includes("already")) {
          return fail(
            "이미 가입된 계정이 있습니다. 해당 계정으로 로그인해 주세요.",
            "EMAIL_CONFLICT",
            409,
          );
        }
        return fail(
          `계정 전환 실패: ${updateErr.message}`,
          "LINK_FAILED",
        );
      }

      return ok({
        message: "게스트 계정이 네이버로 전환되었습니다.",
        user_id: currentUser.id,
      });
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 일반 로그인: 사용자 조회/생성 + 세션 발급
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    // ─── Step 2: 사용자 조회 또는 생성 ───
    const userMeta = {
      name: naverUser.name,
      avatar_url: naverUser.profile_image,
      provider: "naver",
      naver_id: naverUser.id,
    };

    // 먼저 생성 시도
    const { data: createData, error: createErr } =
      await supabaseAdmin.auth.admin.createUser({
        email: naverUser.email,
        email_confirm: true,
        user_metadata: userMeta,
        app_metadata: { provider: "naver", providers: ["naver"] },
      });

    if (createErr) {
      // 이미 존재하는 사용자 → 메타데이터 갱신
      if (!createErr.message?.includes("already")) {
        return fail(
          `사용자 생성 실패: ${createErr.message}`,
          "CREATE_USER_FAILED",
        );
      }
    } else if (createData?.user) {
      // 신규 생성 완료 → handle_new_user 트리거가 profiles 자동 생성
      console.log(`새 사용자 생성: ${createData.user.id}`);
    }

    // ─── Step 3: Magic Link로 세션 생성 ───
    const { data: linkData, error: linkErr } =
      await supabaseAdmin.auth.admin.generateLink({
        type: "magiclink",
        email: naverUser.email,
      });

    if (linkErr || !linkData?.properties?.hashed_token) {
      return fail(
        `세션 생성 실패: ${linkErr?.message ?? "hashed_token 없음"}`,
        "SESSION_FAILED",
        500,
      );
    }

    // hashed_token → OTP 검증 → 세션 획득
    const anonClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    const { data: otpData, error: verifyErr } =
      await anonClient.auth.verifyOtp({
        token_hash: linkData.properties.hashed_token,
        type: "magiclink",
      });

    if (verifyErr || !otpData?.session) {
      return fail(
        `세션 검증 실패: ${verifyErr?.message ?? "session 없음"}`,
        "VERIFY_FAILED",
        500,
      );
    }

    // ─── Step 4: 세션 반환 ───
    return ok({
      session: {
        access_token: otpData.session.access_token,
        refresh_token: otpData.session.refresh_token,
        expires_in: otpData.session.expires_in,
        token_type: otpData.session.token_type,
        user: {
          id: otpData.session.user.id,
          email: otpData.session.user.email,
          user_metadata: otpData.session.user.user_metadata,
        },
      },
    });
  } catch (error) {
    return fail(
      error instanceof Error ? error.message : "알 수 없는 오류",
      "NAVER_AUTH_ERROR",
      500,
    );
  }
});
