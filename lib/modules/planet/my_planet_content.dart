import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

/// Content widget for My Planet screen (without Scaffold/bottom nav)
/// Used inside MainShellView's IndexedStack
///
/// Figma Layout Structure:
/// - Black background (handled by MainShellView for tab 3)
/// - Main container (gray #F4F4F5, border-radius 40px top) - taste profile + flavors
/// - Logout/Withdraw container (gray #F4F4F5, border-radius 40px) - separate
/// - Legal links (black background, directly on black)
class MyPlanetContent extends GetView<MyPlanetController> {
  const MyPlanetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.colorGlobalViolet50),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== MAIN CONTAINER (Gray background) =====
            // Figma: #F4F4F5, border-radius 40px, padding 12px 24px, width: stretch
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ), // Figma: 12px 24px
              decoration: BoxDecoration(
                color: AppColor.colorGlobalCoolNeutral98, // Figma: #F4F4F5
                borderRadius: BorderRadius.circular(
                  40,
                ), // Figma: 40px all corners
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Main content: empty or filled (auto-switches based on survey data)
                  if (controller.hasTasteProfile)
                    _buildFilledContent()
                  else
                    _buildEmptyContent(),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ===== LOGOUT/WITHDRAW CONTAINER (Separate gray container) =====
            // Figma: #F4F4F5, border-radius 40px, padding 12px 24px, width: stretch
            const SizedBox(height: 8),
            _buildAccountActionsContainer(),

            // ===== LEGAL LINKS (Black background) =====
            // Figma: Directly on black background
            const SizedBox(height: 16),
            _buildLegalLinksOnBlack(),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  // ==================== EMPTY STATE ====================
  // Figma: White card with sitting mascot and CTA
  // node-id=1341-16217

  Widget _buildEmptyContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Figma: White background (no gradient)
        color: AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Headline - Figma: Bold, dark text, centered
          Text(
            '내 커피 취향을\n찾아볼까요?',
            style: AppTextStyles.title3Bold.copyWith(
              color: AppColor.labelNormal,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Mascot illustration - sitting rabbit
          _buildMascotPlaceholder(),
          const SizedBox(height: 24),
          // CTA Button - Figma: Light gray background, violet text, pill shape
          GestureDetector(
            onTap: () => controller.goToSurvey(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              decoration: BoxDecoration(
                // Figma: Light gray background on white card
                color: AppColor.colorGlobalCoolNeutral98,
                borderRadius: BorderRadius.circular(99), // Pill shape
              ),
              child: Center(
                child: Text(
                  '취향 설문 하기',
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: AppColor.primaryNormal, // #6541F2
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
              color: AppColor.colorGlobalCommon100,
            ),
          ),
        );
      },
    );
  }

  // ==================== FILLED STATE ====================

  Widget _buildFilledContent() {
    // Survey Result style: separate sections
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Taste profile grid (4 individual tiles with emoji)
        _buildTasteProfileGrid(),
        const SizedBox(height: 20),
        // 2. Flavor notes list (white card)
        _buildFlavorNotesCard(),
        const SizedBox(height: 16),
        // 3. Retake survey button
        _buildRetakeSurveyButton(),
      ],
    );
  }

  /// Taste Profile Grid - Figma: 4 separate containers with gap
  /// Each tag: white at top → color at bottom (vertical gradient)
  /// Colors: 산미=Orange, 바디감=Yellow, 단맛=Pink, 쓴맛=Purple
  Widget _buildTasteProfileGrid() {
    final profile = controller.surveyResult?.tasteProfile;
    if (profile == null) return const SizedBox.shrink();

    // Get level text for each value
    String getLevelText(int value) {
      if (value >= 70) return '좋음';
      if (value >= 40) return '보통';
      return '싫음';
    }

    // Figma colors: 산미=Orange/Peach, 바디감=Yellow, 단맛=Pink, 쓴맛=Purple
    final items = [
      {
        'label': '산미',
        'level': getLevelText(profile.acidity),
        'color': const Color(0xFFFFAA5C),
      }, // Orange/Peach
      {
        'label': '바디감',
        'level': getLevelText(profile.body),
        'color': const Color(0xFFFFD966),
      }, // Yellow
      {
        'label': '단맛',
        'level': getLevelText(profile.sweetness),
        'color': const Color(0xFFFF8FAB),
      }, // Pink
      {
        'label': '쓴맛',
        'level': getLevelText(profile.bitterness),
        'color': const Color(0xFFB39DDB),
      }, // Purple/Violet
    ];

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(
            child: _buildTasteTag(
              label: items[i]['label'] as String,
              level: items[i]['level'] as String,
              color: items[i]['color'] as Color,
            ),
          ),
          if (i < items.length - 1)
            const SizedBox(width: 8), // Gap between tags
        ],
      ],
    );
  }

  /// Individual taste tag - Figma: separate rounded container
  /// Gradient: white from top to 50%, then fade to color at bottom
  Widget _buildTasteTag({
    required String label,
    required String level,
    required Color color,
  }) {
    return Container(
      height: 86, // Figma: 86px
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Figma: ~16px radius
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0], // White until 50%, then fade to color
          colors: [
            AppColor.colorGlobalCommon100, // White at top (0%)
            AppColor.colorGlobalCommon100, // White at middle (50%)
            color.withOpacity(0.6), // Color at bottom (100%)
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label - Figma: 17px, 600 weight, #171719
          Text(
            label,
            style: AppTextStyles.headline2Bold.copyWith(
              color: AppColor.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Level - Figma: 14px, 400 weight, rgba(46, 47, 51, 0.88)
          Text(
            level,
            style: AppTextStyles.caption1Regular.copyWith(
              color: AppColor.labelNeutral,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorNotesCard() {
    final flavors = controller.flavorDescriptions;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        children: List.generate(flavors.length, (index) {
          final flavor = flavors[index];
          return Column(
            children: [
              _buildFlavorNoteItem(flavor),
              if (index < flavors.length - 1)
                Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 20,
                  color: AppColor.lineSolidNeutral,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFlavorNotesList() {
    final flavors = controller.flavorDescriptions;
    return Column(
      children: List.generate(flavors.length, (index) {
        final flavor = flavors[index];
        return Column(
          children: [
            _buildFlavorNoteItem(flavor),
            if (index < flavors.length - 1)
              Divider(
                height: 1,
                indent: 72,
                endIndent: 20,
                color: AppColor.lineSolidNeutral,
              ),
          ],
        );
      }),
    );
  }

  Widget _buildFlavorNoteItem(FlavorDescription flavor) {
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
                    color: AppColor.componentFillNormal,
                  ),
                  child: Center(
                    child: Icon(
                      _flavorIcon(flavor.title),
                      size: 20,
                      color: AppColor.labelAlternative,
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
                    color: AppColor.labelNormal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  flavor.description,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
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

  Widget _buildRetakeSurveyButton() {
    return GestureDetector(
      onTap: () => controller.retakeSurvey(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColor
              .componentFillNormal, // rgba(112, 115, 124, 0.08) per Figma
          borderRadius: BorderRadius.circular(99), // Figma: 99px
        ),
        child: Text(
          '취향 설문 다시 하기',
          style: AppTextStyles.headline2Bold.copyWith(
            color: AppColor.primaryNormal, // Violet text #6541F2
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ==================== ACCOUNT ACTIONS CONTAINER ====================
  // Figma: Separate gray container - #F4F4F5, border-radius 40px, padding 12px 24px

  Widget _buildAccountActionsContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ), // Figma: 12px 24px
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F5), // Figma: #F4F4F5 (gray)
        borderRadius: BorderRadius.circular(40), // Figma: 40px
      ),
      child: Column(
        children: [
          // 게스트일 때만 계정 연결 표시
          if (controller.isAnonymous) ...[
            _buildAccountCell(
              text: '계정 연결',
              color: AppColor.primaryNormal,
              onTap: () => controller.goToAccountLink(),
            ),
            Container(height: 1, color: AppColor.lineNormalNeutral),
          ],
          // 로그아웃 cell - Figma: height 48px, padding 12px 0
          _buildAccountCell(
            text: '로그아웃',
            color: AppColor.labelNormal, // Figma: #171719
            onTap: () => controller.logout(),
          ),
          // Divider line - Figma: rgba(112, 115, 124, 0.16)
          Container(
            height: 1,
            color: AppColor.lineNormalNeutral, // rgba(112, 115, 124, 0.16)
          ),
          // 회원탈퇴 cell - Figma: color #FF4242
          _buildAccountCell(
            text: '회원탈퇴',
            color: AppColor.statusNegative, // Figma: #FF4242
            onTap: () => controller.withdrawAccount(),
          ),
        ],
      ),
    );
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

  // ==================== LEGAL LINKS (On Black Background) ====================
  // Figma: Directly on black background, rgba(194, 196, 200, 0.88) text color

  Widget _buildLegalLinksOnBlack() {
    // Figma CSS: color: rgba(194, 196, 200, 0.88);
    final linkColor = AppColor.inverseLabelNeutral; // rgba(194, 196, 200, 0.88)

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
