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

function fail(message: string, code: string, status = 400) {
  return json({ success: false, error: { code, message } }, status);
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return fail("Only POST is allowed.", "METHOD_NOT_ALLOWED", 405);
  }

  try {
    const body = await req.json().catch(() => ({}));
    const confirmText = (body as { confirm?: string }).confirm;

    if (confirmText !== "DELETE") {
      return fail("Confirmation text must be DELETE.", "INVALID_CONFIRM_TEXT", 400);
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return fail("Authorization header is required.", "UNAUTHORIZED", 401);
    }

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

    if (authErr || !user) {
      return fail("Authentication required.", "UNAUTHORIZED", 401);
    }

    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { data: deleteSummary, error: deleteDataErr } = await admin.rpc(
      "delete_user_data",
      { p_user_id: user.id },
    );

    if (deleteDataErr) {
      return fail(`delete_user_data failed: ${deleteDataErr.message}`, "DELETE_DATA_FAILED", 500);
    }

    // Best effort avatar cleanup. Ignore failures because DB/Auth cleanup is the priority.
    try {
      const { data: files } = await admin.storage.from("avatars").list(user.id, {
        limit: 1000,
      });
      if (files && files.length > 0) {
        const paths = files.map((f) => `${user.id}/${f.name}`);
        await admin.storage.from("avatars").remove(paths);
      }
    } catch {
      // no-op
    }

    const { error: authDeleteErr } = await admin.auth.admin.deleteUser(user.id);
    if (authDeleteErr) {
      return fail(`Auth delete failed: ${authDeleteErr.message}`, "DELETE_AUTH_FAILED", 500);
    }

    return json({
      success: true,
      data: {
        user_id: user.id,
        delete_summary: deleteSummary,
      },
    });
  } catch (error) {
    return fail(
      error instanceof Error ? error.message : "Internal error",
      "INTERNAL_ERROR",
      500,
    );
  }
});
