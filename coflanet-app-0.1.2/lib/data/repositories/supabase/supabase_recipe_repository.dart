import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/dummy/dummy_timer_data.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

/// Supabase implementation of RecipeRepository
///
/// Tables used:
///   - `recipes` (user_id, brew_method_id, name, coffee_amount_g, ...)
///   - `recipe_steps` (recipe_id, step_number, title, duration_seconds, ...)
///   - `recipe_aroma_tags` (recipe_id, emoji, name, display_order)
///   - `brew_methods` (id, slug, name, category)
///
/// Built-in recipes come from DummyTimerData (static, not in DB).
/// Saved/favorite recipe IDs are stored locally (no server table for this).
class SupabaseRecipeRepository implements RecipeRepository {
  SupabaseClient get _db => Supabase.instance.client;
  final LocalStorage _storage = Get.find<LocalStorage>();

  /// Cached brew_methods slug → UUID mapping
  Map<String, String>? _brewMethodCache;

  // ─── Public API ───

  @override
  Future<TimerRecipeModel?> getRecipeByType(
    String coffeeType, {
    String? beanId,
  }) async {
    // Try server merged recipe first (user customization + base defaults)
    try {
      final methodId = await _getBrewMethodId(coffeeType);
      if (methodId != null) {
        final params = <String, dynamic>{'p_brew_method_id': methodId};
        if (beanId != null) params['p_bean_id'] = beanId;
        final result = await _db.rpc('get_merged_recipe', params: params);
        debugPrint('[RecipeRepo] get_merged_recipe($coffeeType): $result');
        if (result is Map<String, dynamic>) {
          return _recipeFromRpc(result, coffeeType);
        }
      }
    } catch (e) {
      debugPrint('[RecipeRepo] get_merged_recipe error: $e');
    }

    // RPC returned no data
    return null;
  }

  @override
  Future<List<TimerRecipeModel>> getAllRecipes() async {
    final builtIn = <TimerRecipeModel>[
      DummyTimerData.handDripRecipe,
      DummyTimerData.espressoRecipe,
      DummyTimerData.espressoDoubleRecipe,
      DummyTimerData.mokaPotRecipe,
      DummyTimerData.frenchPressRecipe,
      DummyTimerData.aeropressRecipe,
      DummyTimerData.coldBrewRecipe,
      DummyTimerData.chemexRecipe,
      DummyTimerData.siphonRecipe,
      DummyTimerData.turkishRecipe,
      DummyTimerData.vietnameseRecipe,
      DummyTimerData.cleverDripperRecipe,
    ];

    // User's custom recipes
    try {
      final userId = _db.auth.currentUser?.id;
      if (userId == null) return builtIn;

      final rows = await _db
          .from('recipes')
          .select('*, recipe_steps(*), recipe_aroma_tags(*)')
          .eq('user_id', userId)
          .eq('is_default', false);

      final slugMap = await _getSlugMap();
      final custom = rows.map((r) => _recipeFromRow(r, slugMap)).toList();
      return [...builtIn, ...custom];
    } catch (e) {
      debugPrint('[RecipeRepo] getAllRecipes error: $e');
      return builtIn;
    }
  }

  @override
  Future<TimerRecipeModel?> getRecipeById(String id) async {
    // Check if this is a known built-in coffee type key
    // DummyTimerData.getRecipe always returns non-null, so we need to check
    // if the id actually matches a built-in type vs. a server UUID
    final knownTypes = {
      'handDrip',
      'espresso',
      'espressoDouble',
      'mokaPot',
      'frenchPress',
      'aeropress',
      'coldBrew',
      'chemex',
      'siphon',
      'turkish',
      'vietnamese',
      'cleverDripper',
    };
    if (knownTypes.contains(id)) return DummyTimerData.getRecipe(id);

    try {
      final row = await _db
          .from('recipes')
          .select('*, recipe_steps(*), recipe_aroma_tags(*)')
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;

      final slugMap = await _getSlugMap();
      return _recipeFromRow(row, slugMap);
    } catch (e) {
      debugPrint('[RecipeRepo] getRecipeById error: $e');
      return null;
    }
  }

  @override
  Future<void> saveRecipe(TimerRecipeModel recipe) async {
    try {
      final userId = _db.auth.currentUser?.id;
      if (userId == null) return;

      final methodId = await _getBrewMethodId(recipe.coffeeType);
      if (methodId == null) {
        debugPrint(
          '[RecipeRepo] brew_method not found for ${recipe.coffeeType}, cannot save',
        );
        return;
      }

      // Extract beanId from recipe ID pattern 'bean_<uuid>'
      final beanId = recipe.id.startsWith('bean_')
          ? recipe.id.substring(5)
          : null;

      // Build p_values jsonb payload
      final values = <String, dynamic>{
        'coffee_amount_g': recipe.coffeeAmount,
        'total_water_ml': recipe.waterAmount,
        'total_duration_seconds': recipe.totalDurationSeconds,
        if (recipe.aromaDescription != null)
          'aroma_description': recipe.aromaDescription,
        'steps': recipe.steps
            .map(
              (s) => <String, dynamic>{
                'step_number': s.stepNumber,
                'title': s.title,
                'description': s.description,
                'step_type': s.stepType.name,
                'water_amount_ml': s.waterAmount,
                'duration_seconds': s.durationSeconds,
                'action_text': s.actionText,
                'illustration_emoji': s.illustrationEmoji,
              },
            )
            .toList(),
        'aroma_tags': recipe.aromaTags
            .asMap()
            .entries
            .map(
              (e) => <String, dynamic>{
                'emoji': e.value.emoji,
                'name': e.value.name,
                'display_order': e.key,
              },
            )
            .toList(),
      };

      final result = await _db.rpc(
        'save_custom_recipe',
        params: {
          'p_brew_method_id': methodId,
          'p_bean_id': beanId,
          'p_name': recipe.name,
          'p_values': values,
        },
      );
      debugPrint('[RecipeRepo] save_custom_recipe result: $result');
    } catch (e) {
      debugPrint('[RecipeRepo] saveRecipe error: $e');
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await _db.rpc('delete_custom_recipe', params: {'p_recipe_id': id});
      await removeFromSavedRecipes(id);
    } catch (e) {
      debugPrint('[RecipeRepo] deleteRecipe error: $e');
    }
  }

  @override
  Future<List<TimerRecipeModel>> getSavedRecipes() async {
    // Use local storage for saved/favorite recipe IDs
    final savedIds = _getSavedRecipeIds();
    if (savedIds.isEmpty) return [];

    final allRecipes = await getAllRecipes();
    return allRecipes.where((r) => savedIds.contains(r.id)).toList();
  }

  @override
  Future<void> addToSavedRecipes(String recipeId) async {
    final ids = _getSavedRecipeIds();
    if (!ids.contains(recipeId)) {
      ids.add(recipeId);
      await _storage.write('saved_recipe_ids', ids);
    }
  }

  @override
  Future<void> removeFromSavedRecipes(String recipeId) async {
    final ids = _getSavedRecipeIds();
    ids.remove(recipeId);
    await _storage.write('saved_recipe_ids', ids);
  }

  // ─── brew_methods lookup ───

  /// Get brew_method UUID from slug (e.g. 'hand_drip' → UUID)
  Future<String?> _getBrewMethodId(String slug) async {
    final map = await _getSlugMap();
    // Try exact match first, then try common variations
    return map[slug] ?? map[_normalizeSlug(slug)];
  }

  /// Returns { UUID → slug } map for reverse lookup
  Future<Map<String, String>> _getSlugMap() async {
    if (_brewMethodCache != null) return _brewMethodCache!;

    try {
      final rows = await _db.from('brew_methods').select('id, slug');
      final map = <String, String>{};
      for (final r in rows) {
        final id = r['id'] as String;
        final slug = r['slug'] as String;
        // Store both directions: slug→id for lookup, id→slug for reverse
        map[slug] = id;
        map[id] = slug;
      }
      _brewMethodCache = map;
      return map;
    } catch (e) {
      debugPrint('[RecipeRepo] brew_methods query error: $e');
      _brewMethodCache = {};
      return {};
    }
  }

  /// Normalize coffeeType to slug format (handDrip → hand_drip)
  String _normalizeSlug(String coffeeType) {
    return coffeeType.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_${m.group(0)!.toLowerCase()}',
    );
  }

  // ─── Local saved recipe IDs ───

  List<String> _getSavedRecipeIds() {
    final data = _storage.read<List<dynamic>>('saved_recipe_ids');
    return data?.cast<String>().toList() ?? [];
  }

  // ─── Row conversion ───

  /// Parse get_merged_recipe RPC response
  /// Response includes nested steps and aroma_tags arrays
  TimerRecipeModel _recipeFromRpc(Map<String, dynamic> row, String coffeeType) {
    final steps = <TimerStepModel>[];
    final rawSteps = row['steps'];
    if (rawSteps is List) {
      for (final s in rawSteps) {
        if (s is Map<String, dynamic>) {
          steps.add(_stepFromMap(s, _toInt(s['step_number'])));
        }
      }
      steps.sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
    }

    final aromaTags = <AromaTagModel>[];
    final rawTags = row['aroma_tags'];
    if (rawTags is List) {
      for (final t in rawTags) {
        if (t is Map<String, dynamic>) {
          aromaTags.add(
            AromaTagModel(
              emoji: t['emoji'] as String? ?? '',
              name: t['name'] as String? ?? '',
            ),
          );
        }
      }
    }

    return TimerRecipeModel(
      id: (row['recipe_id'] ?? row['id'] ?? '').toString(),
      name: row['name'] as String? ?? '',
      coffeeType: coffeeType,
      coffeeAmount: _toInt(row['coffee_amount_g']),
      waterAmount: _toInt(row['total_water_ml']),
      totalDurationSeconds: _toInt(row['total_duration_seconds']),
      steps: steps,
      aromaDescription: row['aroma_description'] as String?,
      aromaTags: aromaTags,
    );
  }

  /// Parse recipes table row (with nested recipe_steps and recipe_aroma_tags)
  TimerRecipeModel _recipeFromRow(
    Map<String, dynamic> row,
    Map<String, String> slugMap,
  ) {
    // Resolve coffeeType from brew_method_id → slug
    final methodId = row['brew_method_id'] as String? ?? '';
    final coffeeType = slugMap[methodId] ?? methodId;

    // Parse nested steps
    final steps = <TimerStepModel>[];
    final rawSteps = row['recipe_steps'];
    if (rawSteps is List) {
      final sorted =
          List<Map<String, dynamic>>.from(
            rawSteps.map((s) => s as Map<String, dynamic>),
          )..sort(
            (a, b) =>
                _toInt(a['step_number']).compareTo(_toInt(b['step_number'])),
          );

      for (final s in sorted) {
        steps.add(_stepFromMap(s, _toInt(s['step_number'])));
      }
    }

    // Parse nested aroma tags
    final aromaTags = <AromaTagModel>[];
    final rawTags = row['recipe_aroma_tags'];
    if (rawTags is List) {
      final sorted =
          List<Map<String, dynamic>>.from(
            rawTags.map((t) => t as Map<String, dynamic>),
          )..sort(
            (a, b) => _toInt(
              a['display_order'],
            ).compareTo(_toInt(b['display_order'])),
          );

      for (final t in sorted) {
        aromaTags.add(
          AromaTagModel(
            emoji: t['emoji'] as String? ?? '',
            name: t['name'] as String? ?? '',
          ),
        );
      }
    }

    return TimerRecipeModel(
      id: (row['id'] ?? '').toString(),
      name: row['name'] as String? ?? '',
      coffeeType: coffeeType,
      coffeeAmount: _toInt(row['coffee_amount_g']),
      waterAmount: _toInt(row['total_water_ml']),
      totalDurationSeconds: _toInt(row['total_duration_seconds']),
      steps: steps,
      aromaDescription: row['aroma_description'] as String?,
      aromaTags: aromaTags,
    );
  }

  TimerStepModel _stepFromMap(Map<String, dynamic> s, int fallbackNumber) {
    return TimerStepModel(
      stepNumber: _toInt(
        s['step_number'] ?? s['stepNumber'],
        defaultValue: fallbackNumber,
      ),
      title: s['title'] as String? ?? '',
      description: s['description'] as String? ?? '',
      durationSeconds: _toInt(s['duration_seconds'] ?? s['durationSeconds']),
      waterAmount: _toIntNullable(s['water_amount_ml'] ?? s['waterAmount']),
      stepType: TimerStepType.values.firstWhere(
        (e) => e.name == (s['step_type'] ?? s['stepType'] ?? 'brewing'),
        orElse: () => TimerStepType.brewing,
      ),
      illustrationEmoji:
          s['illustration_emoji'] as String? ??
          s['illustrationEmoji'] as String?,
      actionText: s['action_text'] as String? ?? s['actionText'] as String?,
    );
  }

  int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  int? _toIntNullable(dynamic value) {
    if (value == null) return null;
    return _toInt(value);
  }
}
