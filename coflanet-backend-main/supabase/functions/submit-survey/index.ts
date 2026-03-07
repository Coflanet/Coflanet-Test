/**
 * submit-survey Edge Function
 *
 * 설문 완료 후 분석:
 * - 맛 프로필 계산
 * - 커피 타입 분류
 * - 플레이버/추천 생성
 */
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  rankBeans,
  type CoffeeType,
  type FlavorPref,
  type TasteProfile,
} from "./_shared/recommendation-engine.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
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

const TYPE_INFO: Record<CoffeeType, { label: string; description: string }> = {
  acidity: {
    label: "산미형",
    description: "밝고 산뜻한 과일 향 중심의 취향입니다.",
  },
  strong: {
    label: "강렬형",
    description: "묵직한 바디감과 진한 풍미를 선호하는 취향입니다.",
  },
  sweet: {
    label: "달콤형",
    description: "부드럽고 달콤한 풍미를 선호하는 취향입니다.",
  },
  balance: {
    label: "균형형",
    description: "산미, 단맛, 바디감이 고르게 어우러진 취향입니다.",
  },
};

type AnswerRow = {
  score_value: number | null;
  selected_options?: string[] | null;
  survey_questions: { question_key: string };
};

const ALLOWED_COFFEE_LEVEL = new Set([
  "beginner",
  "enthusiast",
  "home_barista",
  "professional",
]);

function normalizeCoffeeLevel(input: string | null | undefined): string | null {
  if (!input) return null;
  const normalized = input === "expert" ? "professional" : input;
  return ALLOWED_COFFEE_LEVEL.has(normalized) ? normalized : null;
}

function clampScore(value: number): number {
  return Math.max(0, Math.min(100, Math.round(value)));
}

function deriveCoffeeType(taste: TasteProfile): CoffeeType {
  const strong = (taste.body + taste.bitterness) / 2;
  const candidates: Array<[CoffeeType, number]> = [
    ["acidity", taste.acidity],
    ["sweet", taste.sweetness],
    ["strong", strong],
  ];
  candidates.sort((a, b) => b[1] - a[1]);
  const [topType, topScore] = candidates[0];
  const secondScore = candidates[1][1];
  if (topScore - secondScore < 12 || topScore < 50) return "balance";
  return topType;
}

function buildReason(type: CoffeeType, beanName: string, categories: string[], score: number): string {
  const tags: string[] = [];
  if (categories.includes("Fruity")) tags.push("과일향");
  if (categories.includes("Floral")) tags.push("꽃향");
  if (categories.includes("Nutty/Cocoa")) tags.push("견과/초콜릿향");
  if (categories.includes("Roasted")) tags.push("로스팅향");
  const tagText = tags.length > 0 ? `${tags.slice(0, 2).join(", ")} 중심, ` : "";
  return `${TYPE_INFO[type].label} 취향에 맞는 추천: ${tagText}${beanName} (${Math.round(score * 100)}% 매칭)`;
}

function computePreference(answerRows: Array<{ question_key: string; score_value: number | null }>) {
  const s3: Record<number, number> = { 1: 20, 2: 60, 3: 100 };
  let acidity = 50;
  let body = 50;
  let sweetness = 50;
  let bitterness = 50;
  const flavor: FlavorPref = {
    fruity: false,
    floral: false,
    nutty_cocoa: false,
    roasted: false,
  };

  for (const row of answerRows) {
    const score = row.score_value;
    if (score == null) continue;
    if (row.question_key === "pref_acidity") acidity = s3[score] ?? acidity;
    if (row.question_key === "pref_body") body = s3[score] ?? body;
    if (row.question_key === "pref_sweetness") sweetness = s3[score] ?? sweetness;
    if (row.question_key === "pref_bitterness") bitterness = s3[score] ?? bitterness;

    if (row.question_key === "pref_aroma_fruity" && score === 1) flavor.fruity = true;
    if (row.question_key === "pref_aroma_floral" && score === 1) flavor.floral = true;
    if (row.question_key === "pref_aroma_nutty_cocoa" && score === 1) flavor.nutty_cocoa = true;
    if (row.question_key === "pref_aroma_roasted" && score === 1) flavor.roasted = true;
  }

  const aroma = clampScore((Object.values(flavor).filter(Boolean).length / 4) * 100);
  return {
    taste: { acidity, body, sweetness, bitterness } satisfies TasteProfile,
    flavor,
    aroma,
  };
}

function computeLifestyle(answerRows: Array<{ question_key: string; score_value: number | null }>) {
  const s5: Record<number, number> = { 1: 20, 2: 35, 3: 50, 4: 70, 5: 90 };
  let acidity = 50;
  let body = 50;
  let sweetness = 50;
  let bitterness = 50;
  const flavor: FlavorPref = {
    fruity: false,
    floral: false,
    nutty_cocoa: false,
    roasted: false,
  };

  for (const row of answerRows) {
    const score = row.score_value;
    if (score == null) continue;
    if (!row.question_key.startsWith("life_")) continue;
    const base = s5[score] ?? 50;
    acidity = clampScore(acidity * 0.8 + base * 0.2);
    body = clampScore(body * 0.8 + base * 0.2);
    sweetness = clampScore(sweetness * 0.8 + base * 0.2);
    bitterness = clampScore(bitterness * 0.8 + (100 - base) * 0.2);

    if (row.question_key === "life_scent" || row.question_key === "life_taste") {
      if (score === 1 || score === 2) flavor.fruity = true;
      if (score === 1) flavor.floral = true;
      if (score === 3 || score === 4) flavor.nutty_cocoa = true;
      if (score === 4 || score === 5) flavor.roasted = true;
    }
  }

  const aroma = clampScore((Object.values(flavor).filter(Boolean).length / 4) * 100);
  return {
    taste: { acidity, body, sweetness, bitterness } satisfies TasteProfile,
    flavor,
    aroma,
  };
}

function buildResultFlavors(flavor: FlavorPref) {
  const rows: Array<{ name: string; emoji: string; description: string; display_order: number }> = [];
  let order = 1;
  if (flavor.fruity) {
    rows.push({ name: "과일 향", emoji: "🍓", description: "상큼하고 생동감 있는 과일 향", display_order: order++ });
  }
  if (flavor.floral) {
    rows.push({ name: "꽃 향", emoji: "🌸", description: "은은하고 우아한 꽃 향", display_order: order++ });
  }
  if (flavor.nutty_cocoa) {
    rows.push({ name: "견과류/초콜릿 향", emoji: "🍫", description: "고소하고 달콤한 견과·코코아 향", display_order: order++ });
  }
  if (flavor.roasted) {
    rows.push({ name: "로스팅 향", emoji: "🔥", description: "깊고 진한 로스팅 향", display_order: order++ });
  }
  if (rows.length === 0) {
    rows.push({ name: "균형 향", emoji: "⚖️", description: "특정 향이 치우치지 않은 균형형", display_order: 1 });
  }
  return rows;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });
  if (req.method !== "POST") return fail("Only POST is allowed.", "METHOD_NOT_ALLOWED", 405);

  try {
    const { session_id } = await req.json().catch(() => ({ session_id: null }));
    if (!session_id) return fail("session_id is required.", "MISSING_SESSION_ID", 400);

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return fail("Authorization header is required.", "UNAUTHORIZED", 401);

    const userClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const token = authHeader.replace("Bearer ", "");
    const {
      data: { user },
      error: authErr,
    } = await userClient.auth.getUser(token);
    if (authErr || !user) return fail("Authentication required.", "UNAUTHORIZED", 401);

    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { data: session, error: sessionErr } = await userClient
      .from("survey_sessions")
      .select("id, user_id, survey_type, status")
      .eq("id", session_id)
      .single();

    if (sessionErr || !session) return fail("설문 세션을 찾을 수 없습니다.", "SESSION_NOT_FOUND", 404);
    if (session.user_id !== user.id) return fail("권한이 없습니다.", "FORBIDDEN", 403);
    if (session.status !== "completed") {
      return fail(`완료된 설문만 분석할 수 있습니다. (현재: ${session.status})`, "SESSION_NOT_COMPLETED", 400);
    }

    const { data: existing } = await userClient
      .from("survey_results")
      .select("id")
      .eq("session_id", session_id)
      .maybeSingle();
    if (existing) return fail("Session already analyzed.", "ALREADY_ANALYZED", 400);

    await admin.from("survey_sessions").update({ status: "analyzing" }).eq("id", session_id);

    const { data: answerRows, error: answerErr } = await userClient
      .from("survey_answers")
      .select("score_value, selected_options, survey_questions(question_key)")
      .eq("session_id", session_id);

    if (answerErr || !answerRows || answerRows.length === 0) {
      await admin.from("survey_sessions").update({ status: "completed" }).eq("id", session_id);
      return fail("설문 응답을 찾을 수 없습니다.", "NO_ANSWERS", 400);
    }

    const normalizedRows = (answerRows as AnswerRow[]).map((row) => ({
      question_key: row.survey_questions.question_key,
      score_value: row.score_value,
    }));

    const computed = session.survey_type === "lifestyle"
      ? computeLifestyle(normalizedRows)
      : computePreference(normalizedRows);

    const coffeeType = deriveCoffeeType(computed.taste);
    const typeInfo = TYPE_INFO[coffeeType];
    const flavorRows = buildResultFlavors(computed.flavor);

    const experienceAnswer = (answerRows as AnswerRow[]).find(
      (row) => row.survey_questions.question_key === "experience_level",
    );
    const selectedExperience = experienceAnswer?.selected_options?.[0] ?? null;
    const coffeeLevel = normalizeCoffeeLevel(selectedExperience);
    if (coffeeLevel) {
      await admin
        .from("profiles")
        .update({ coffee_level: coffeeLevel, survey_completed: true })
        .eq("user_id", user.id);
    }

    const { data: result, error: resultErr } = await admin
      .from("survey_results")
      .insert({
        session_id,
        user_id: user.id,
        coffee_type: coffeeType,
        coffee_type_label: typeInfo.label,
        coffee_type_description: typeInfo.description,
        acidity: computed.taste.acidity,
        sweetness: computed.taste.sweetness,
        bitterness: computed.taste.bitterness,
        body: computed.taste.body,
        aroma: computed.aroma,
      })
      .select("id")
      .single();

    if (resultErr || !result) {
      await admin.from("survey_sessions").update({ status: "completed" }).eq("id", session_id);
      return fail(`결과 저장 실패: ${resultErr?.message ?? "unknown"}`, "INSERT_FAILED", 500);
    }

    await admin
      .from("survey_result_flavors")
      .insert(flavorRows.map((item) => ({ result_id: result.id, ...item })));

    const { data: beans, error: beanErr } = await admin
      .from("coffee_beans")
      .select("id, name, acidity, sweetness, bitterness, body")
      .eq("is_available", true);

    if (beanErr || !beans || beans.length === 0) {
      await admin.from("survey_sessions").update({ status: "analyzed" }).eq("id", session_id);
      return ok({
        result_id: result.id,
        coffee_type: coffeeType,
        coffee_type_label: typeInfo.label,
        coffee_type_description: typeInfo.description,
        taste_profile: { ...computed.taste, aroma: computed.aroma },
        flavors: flavorRows,
        recommendations: [],
      });
    }

    const beanIds = beans.map((bean: { id: string }) => bean.id);
    const { data: allTags } = await admin
      .from("bean_flavor_tags")
      .select("bean_id, category, descriptor")
      .in("bean_id", beanIds);

    const top5 = rankBeans(
      beans as Array<{
        id: string;
        name: string;
        acidity: number | null;
        sweetness: number | null;
        bitterness: number | null;
        body: number | null;
      }>,
      (allTags ?? []) as Array<{ bean_id: string; category: string; descriptor: string | null }>,
      computed.taste,
      computed.flavor,
    ).slice(0, 5);

    const recommendations = top5.map((bean, index) => ({
      result_id: result.id,
      bean_id: bean.bean_id,
      match_score: bean.match_score,
      display_order: index + 1,
      recommendation_reason: buildReason(coffeeType, bean.bean_name, bean.categories, bean.match_score),
    }));

    if (recommendations.length > 0) {
      await admin.from("recommendations").insert(recommendations);
    }

    await admin.from("survey_sessions").update({ status: "analyzed" }).eq("id", session_id);

    return ok({
      result_id: result.id,
      coffee_type: coffeeType,
      coffee_type_label: typeInfo.label,
      coffee_type_description: typeInfo.description,
      taste_profile: { ...computed.taste, aroma: computed.aroma },
      flavors: flavorRows,
      recommendations: recommendations.map((row, index) => ({
        bean_id: row.bean_id,
        display_order: index + 1,
        match_score: row.match_score,
        reason: row.recommendation_reason,
      })),
    });
  } catch (error) {
    return fail(error instanceof Error ? error.message : "알 수 없는 오류", "INTERNAL_ERROR", 500);
  }
});
