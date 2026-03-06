/**
 * match-coffee Edge Function
 *
 * POST { result_id?: string }
 * Authorization: Bearer <JWT>
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

const TYPE_INFO: Record<CoffeeType, { label: string }> = {
  acidity: { label: "산미형" },
  strong: { label: "강렬형" },
  sweet: { label: "달콤형" },
  balance: { label: "균형형" },
};

function genReason(
  ct: CoffeeType,
  name: string,
  categories: string[],
  score: number,
): string {
  const pct = Math.round(score * 100);
  const parts: string[] = [];
  if (categories.includes("Fruity")) parts.push("과일향");
  if (categories.includes("Floral")) parts.push("꽃향");
  if (categories.includes("Nutty/Cocoa")) parts.push("견과/초콜릿향");
  if (categories.includes("Roasted")) parts.push("로스팅향");
  const prefix = parts.length > 0 ? `${parts.slice(0, 2).join(", ")} 중심, ` : "";
  return `${TYPE_INFO[ct].label} 취향 추천: ${prefix}${name} (${pct}% 매칭)`;
}

function inferFlavorPref(resultFlavors: Array<{ name: string }>): FlavorPref {
  const pref: FlavorPref = {
    fruity: false,
    floral: false,
    nutty_cocoa: false,
    roasted: false,
  };

  for (const flavor of resultFlavors) {
    const n = flavor.name.toLowerCase();
    if (n.includes("fruit") || n.includes("berry") || n.includes("과일")) pref.fruity = true;
    if (n.includes("floral") || n.includes("flower") || n.includes("꽃")) pref.floral = true;
    if (n.includes("nut") || n.includes("cocoa") || n.includes("chocolate")) {
      pref.nutty_cocoa = true;
    }
    if (n.includes("견과") || n.includes("초콜릿")) pref.nutty_cocoa = true;
    if (n.includes("roast") || n.includes("smok") || n.includes("로스팅")) pref.roasted = true;
  }

  return pref;
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
    const { result_id } = body as { result_id?: string };

    const authHeader = req.headers.get("Authorization")!;
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const {
      data: { user },
      error: authErr,
    } = await supabase.auth.getUser();
    if (authErr || !user) {
      return fail("Authentication required.", "UNAUTHORIZED", 401);
    }

    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    let resultQuery = supabase
      .from("survey_results")
      .select("id, user_id, coffee_type, acidity, sweetness, bitterness, body");

    if (result_id) {
      resultQuery = resultQuery.eq("id", result_id);
    } else {
      resultQuery = resultQuery
        .eq("user_id", user.id)
        .order("created_at", { ascending: false })
        .limit(1);
    }

    const { data: results, error: resultErr } = await resultQuery;
    if (resultErr || !results || results.length === 0) {
      return fail("No survey result found.", "NO_RESULT", 404);
    }

    const surveyResult = results[0] as {
      id: string;
      user_id: string;
      coffee_type: CoffeeType;
      acidity: number | null;
      sweetness: number | null;
      bitterness: number | null;
      body: number | null;
    };

    if (surveyResult.user_id !== user.id) {
      return fail("Forbidden.", "FORBIDDEN", 403);
    }

    const userTaste: TasteProfile = {
      acidity: surveyResult.acidity ?? 50,
      body: surveyResult.body ?? 50,
      sweetness: surveyResult.sweetness ?? 50,
      bitterness: surveyResult.bitterness ?? 50,
    };

    const { data: flavorRows } = await supabase
      .from("survey_result_flavors")
      .select("name")
      .eq("result_id", surveyResult.id);

    const flavorPref = inferFlavorPref(flavorRows ?? []);

    const { data: beans, error: beansErr } = await admin
      .from("coffee_beans")
      .select("id, name, acidity, sweetness, bitterness, body")
      .eq("is_available", true);

    if (beansErr || !beans || beans.length === 0) {
      return ok({ result_id: surveyResult.id, recommendations: [] }, "No beans.");
    }

    const beanIds = beans.map((bean: { id: string }) => bean.id);
    const { data: allTags } = await admin
      .from("bean_flavor_tags")
      .select("bean_id, category, descriptor")
      .in("bean_id", beanIds);

    const ranked = rankBeans(beans, allTags ?? [], userTaste, flavorPref);
    const top5 = ranked.slice(0, 5);

    await admin.from("recommendations").delete().eq("result_id", surveyResult.id);

    const recs = top5.map((bean, index) => ({
      result_id: surveyResult.id,
      bean_id: bean.bean_id,
      match_score: bean.match_score,
      display_order: index + 1,
      recommendation_reason: genReason(
        surveyResult.coffee_type,
        bean.bean_name,
        bean.categories,
        bean.match_score,
      ),
    }));

    if (recs.length > 0) {
      await admin.from("recommendations").insert(recs);
    }

    return ok({
      result_id: surveyResult.id,
      coffee_type: surveyResult.coffee_type,
      recommendations: top5.map((bean, index) => ({
        bean_id: bean.bean_id,
        bean_name: bean.bean_name,
        match_score: bean.match_score,
        display_order: index + 1,
        reason: recs[index]?.recommendation_reason,
      })),
    });
  } catch (error) {
    return fail(
      error instanceof Error ? error.message : "Internal error",
      "INTERNAL_ERROR",
      500,
    );
  }
});
