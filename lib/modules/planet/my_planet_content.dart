import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/widgets/modals/selection_modal.dart';

/// Content widget for My Planet screen (without Scaffold/bottom nav)
/// Used inside MainShellView's IndexedStack
///
/// Figma Layout Structure (테마 스킴 기반):
/// - 페이지 배경: MainShellView 담당 (backgroundNormalAlternative)
/// - Main container (surfaceCardStrong, border-radius 40px) - taste profile + flavors
/// - 테마/Logout/Withdraw container (surfaceCardStrong, border-radius 40px) - separate
/// - Legal links (페이지 배경 위 직접)
class MyPlanetContent extends GetView<MyPlanetController> {
  const MyPlanetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Obx(() {
      if (controller.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: colors.primaryNormal),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== MAIN CONTAINER (옅은 회색 컨테이너) =====
            // Figma: border-radius 40px, padding 12px 24px, width: stretch
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ), // Figma: 12px 24px
              decoration: BoxDecoration(
                color: colors.surfaceCardStrong,
                borderRadius: BorderRadius.circular(
                  40,
                ), // Figma: 40px all corners
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Main content: empty or filled (auto-switches based on survey data)
                  if (controller.hasTasteProfile)
                    _buildFilledContent(colors)
                  else
                    _buildEmptyContent(colors),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ===== 테마/LOGOUT/WITHDRAW CONTAINER (Separate container) =====
            // Figma: border-radius 40px, padding 12px 24px, width: stretch
            const SizedBox(height: 8),
            _buildAccountActionsContainer(colors),

            // ===== LEGAL LINKS (페이지 배경 위 직접) =====
            const SizedBox(height: 16),
            _buildLegalLinks(colors),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  // ==================== EMPTY STATE ====================
  // Figma: White card with sitting mascot and CTA
  // node-id=1341-16217

  Widget _buildEmptyContent(AppColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Figma: 카드 배경 (라이트=흰색)
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Headline - Figma: Bold, centered
          Text(
            '내 커피 취향을\n찾아볼까요?',
            style: AppTextStyles.title3Bold.copyWith(
              color: colors.labelNormal,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Mascot illustration - sitting rabbit
          _buildMascotPlaceholder(),
          const SizedBox(height: 24),
          // CTA Button - Figma: 옅은 fill, violet text, pill shape
          GestureDetector(
            onTap: () => controller.goToSurvey(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              decoration: BoxDecoration(
                color: colors.componentFillNormal,
                borderRadius: BorderRadius.circular(99), // Pill shape
              ),
              child: Center(
                child: Text(
                  '취향 설문 하기',
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: colors.primaryNormal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMascotPlaceholder() {
    return Image.asset(
      AssetPath.charSitting,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if image fails to load
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.colorGlobalViolet80,
                AppColor.colorGlobalViolet50,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.smart_toy_rounded,
              size: 64,
              color: AppColor.staticLabelWhiteStrong,
            ),
          ),
        );
      },
    );
  }

  // ==================== FILLED STATE ====================

  Widget _buildFilledContent(AppColorScheme colors) {
    // Survey Result style: separate sections
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Taste profile grid (4 individual tiles with emoji)
        _buildTasteProfileGrid(colors),
        const SizedBox(height: 20),
        // 2. Flavor notes list (카드)
        _buildFlavorNotesCard(colors),
        const SizedBox(height: 16),
        // 3. Retake survey button
        _buildRetakeSurveyButton(colors),
      ],
    );
  }

  /// Taste Profile Grid - Figma: 4 separate containers with gap
  /// Each tag: card color at top → accent color at bottom (vertical gradient)
  /// Colors: 산미=Orange, 바디감=Yellow, 단맛=Pink, 쓴맛=Purple (고정 토큰)
  Widget _buildTasteProfileGrid(AppColorScheme colors) {
    final profile = controller.surveyResult?.tasteProfile;
    if (profile == null) return const SizedBox.shrink();

    // Get level text for each value
    String getLevelText(int value) {
      if (value >= 70) return '좋음';
      if (value >= 40) return '보통';
      return '싫음';
    }

    // Figma colors — AppColor.tasteTag* 고정 토큰
    final items = [
      {
        'label': '산미',
        'level': getLevelText(profile.acidity),
        'color': AppColor.tasteTagAcidity,
      },
      {
        'label': '바디감',
        'level': getLevelText(profile.body),
        'color': AppColor.tasteTagBody,
      },
      {
        'label': '단맛',
        'level': getLevelText(profile.sweetness),
        'color': AppColor.tasteTagSweetness,
      },
      {
        'label': '쓴맛',
        'level': getLevelText(profile.bitterness),
        'color': AppColor.tasteTagBitterness,
      },
    ];

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(
            child: _buildTasteTag(
              label: items[i]['label'] as String,
              level: items[i]['level'] as String,
              color: items[i]['color'] as Color,
              colors: colors,
            ),
          ),
          if (i < items.length - 1)
            const SizedBox(width: 8), // Gap between tags
        ],
      ],
    );
  }

  /// Individual taste tag - Figma: separate rounded container
  /// Gradient: card color from top to 50%, then fade to accent at bottom
  Widget _buildTasteTag({
    required String label,
    required String level,
    required Color color,
    required AppColorScheme colors,
  }) {
    return Container(
      height: 86, // Figma: 86px
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Figma: ~16px radius
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0], // 카드색 50% 까지, 이후 강조색 페이드
          colors: [
            colors.surfaceCard,
            colors.surfaceCard,
            color.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label - Figma: 17px, 600 weight
          Text(
            label,
            style: AppTextStyles.headline2Bold.copyWith(
              color: colors.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Level - Figma: 14px, 400 weight
          Text(
            level,
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelNeutral,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorNotesCard(AppColorScheme colors) {
    final flavors = controller.flavorDescriptions;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        children: List.generate(flavors.length, (index) {
          final flavor = flavors[index];
          return Column(
            children: [
              _buildFlavorNoteItem(flavor, colors),
              if (index < flavors.length - 1)
                Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 20,
                  color: colors.lineSolidNeutral,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFlavorNoteItem(FlavorDescription flavor, AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Aroma image
          ClipOval(
            child: Image.asset(
              _flavorImagePath(flavor.title),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.componentFillNormal,
                  ),
                  child: Center(
                    child: Icon(
                      _flavorIcon(flavor.title),
                      size: 20,
                      color: colors.labelAlternative,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flavor.title,
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  flavor.description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: colors.labelAlternative,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _flavorImagePath(String title) {
    if (title.contains('과일')) return AssetPath.aromaFruit;
    if (title.contains('꽃')) return AssetPath.aromaFlower;
    if (title.contains('견과')) return AssetPath.aromaNutChoco;
    if (title.contains('로스팅')) return AssetPath.aromaRoasting;
    return AssetPath.aromaFruit;
  }

  IconData _flavorIcon(String title) {
    if (title.contains('과일')) return Icons.energy_savings_leaf_rounded;
    if (title.contains('꽃')) return Icons.local_florist_rounded;
    if (title.contains('견과')) return Icons.cookie_rounded;
    if (title.contains('로스팅')) return Icons.local_fire_department_rounded;
    return Icons.coffee_rounded;
  }

  Widget _buildRetakeSurveyButton(AppColorScheme colors) {
    return GestureDetector(
      onTap: () => controller.retakeSurvey(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: colors.componentFillNormal,
          borderRadius: BorderRadius.circular(99), // Figma: 99px
        ),
        child: Text(
          '취향 설문 다시 하기',
          style: AppTextStyles.headline2Bold.copyWith(
            color: colors.primaryNormal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ==================== ACCOUNT ACTIONS CONTAINER ====================
  // Figma: Separate container - border-radius 40px, padding 12px 24px

  Widget _buildAccountActionsContainer(AppColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ), // Figma: 12px 24px
      decoration: BoxDecoration(
        color: colors.surfaceCardStrong,
        borderRadius: BorderRadius.circular(40), // Figma: 40px
      ),
      child: Column(
        children: [
          // 테마 설정 cell — 현재 모드 라벨 표시 + 선택 모달
          _buildThemeModeCell(colors),
          Container(height: 1, color: colors.lineNormalNeutral),
          // 게스트일 때만 계정 연결 표시
          if (controller.isAnonymous) ...[
            _buildAccountCell(
              text: '계정 연결',
              color: colors.primaryNormal,
              onTap: () => controller.goToAccountLink(),
            ),
            Container(height: 1, color: colors.lineNormalNeutral),
          ],
          // 로그아웃 cell - Figma: height 48px, padding 12px 0
          _buildAccountCell(
            text: '로그아웃',
            color: colors.labelNormal,
            onTap: () => controller.logout(),
          ),
          // Divider line
          Container(height: 1, color: colors.lineNormalNeutral),
          // 회원탈퇴 cell - Figma: color #FF4242
          _buildAccountCell(
            text: '회원탈퇴',
            color: colors.statusNegative,
            onTap: () => controller.withdrawAccount(),
          ),
        ],
      ),
    );
  }

  /// 테마 설정 cell — '테마' + 현재 모드 라벨, 탭 시 3상태 선택 모달
  Widget _buildThemeModeCell(AppColorScheme colors) {
    final themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: () => _showThemeModeModal(themeController),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '테마',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ),
            Obx(
              () => Text(
                themeController.mode.label,
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colors.labelAlternative,
            ),
          ],
        ),
      ),
    );
  }

  /// 테마 모드 선택 모달 (시스템 설정 / 라이트 / 다크)
  Future<void> _showThemeModeModal(ThemeController themeController) async {
    const modes = AppThemeMode.values;
    final result = await SelectionModal.show(
      title: '테마 설정',
      options: [for (final mode in modes) mode.label],
      selectedIndex: modes.indexOf(themeController.mode),
    );
    if (result != null && result is int) {
      themeController.setMode(modes[result]);
    }
  }

  /// Account action cell - Figma: height 48px, padding 12px 0
  Widget _buildAccountCell({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48, // Figma: 48px
        padding: const EdgeInsets.symmetric(vertical: 12), // Figma: 12px 0
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppTextStyles.body1NormalRegular.copyWith(color: color),
        ),
      ),
    );
  }

  // ==================== LEGAL LINKS (페이지 배경 위 직접) ====================
  // 테마 라벨 토큰 사용 — 다크에서는 기존 회색 톤과 동일하게 보인다

  Widget _buildLegalLinks(AppColorScheme colors) {
    final linkColor = colors.labelNeutral;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24), // Same as containers
      child: Column(
        children: [
          // 개인정보처리방침
          _buildLegalCell(
            text: '개인정보처리방침',
            color: linkColor,
            onTap: () => controller.openPrivacyPolicy(),
          ),
          // 서비스 이용약관
          _buildLegalCell(
            text: '서비스 이용약관',
            color: linkColor,
            onTap: () => controller.openTermsOfService(),
          ),
        ],
      ),
    );
  }

  /// Legal link cell
  Widget _buildLegalCell({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppTextStyles.body1NormalRegular.copyWith(color: color),
        ),
      ),
    );
  }
}
