import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

class MyPlanetView extends GetView<MyPlanetController> {
  const MyPlanetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCoolNeutral10,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.colorGlobalViolet50,
              ),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header - User name
                _buildHeader(),
                const SizedBox(height: 24),
                // Main content: empty or filled
                if (controller.hasTasteProfile)
                  _buildFilledContent()
                else
                  _buildEmptyContent(),
                const SizedBox(height: 24),
                // Bottom section: logout + withdraw
                _buildBottomActions(),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ==================== HEADER ====================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        controller.userName,
        style: AppTextStyles.heading1Bold.copyWith(
          color: AppColor.colorGlobalCommon100,
        ),
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  // Figma CSS: background: #F4F4F5; border-radius: 40px; padding: 16px;

  Widget _buildEmptyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16), // Figma: padding 16px
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F5), // Figma: #F4F4F5 (gray)
          borderRadius: BorderRadius.circular(40), // Figma: 40px
        ),
        child: Column(
          children: [
            // Contents container with 8px padding
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Headline - Figma: Title 3/Bold 24px, color #171719
                  Text(
                    '내 커피 취향을\n찾아볼까요?',
                    style: AppTextStyles.title3Bold.copyWith(
                      color: const Color(0xFF171719), // Figma: #171719
                      letterSpacing: -0.023 * 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // Mascot illustration
                  _buildMascotPlaceholder(),
                ],
              ),
            ),
            // CTA Button - Figma: rgba(112, 115, 124, 0.08) bg, border-radius: 99px, padding 12px 28px
            GestureDetector(
              onTap: () => controller.goToSurvey(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 28,
                ), // Figma: 12px 28px
                decoration: BoxDecoration(
                  color: const Color(0x14707C7C), // rgba(112, 115, 124, 0.08)
                  borderRadius: BorderRadius.circular(99), // Figma: 99px
                ),
                child: Center(
                  child: Text(
                    '취향 설문 하기',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Figma: 600
                      height: 1.5, // 150%
                      letterSpacing: 0.0057 * 16,
                      color: Color(0xFF6541F2), // Figma: #6541F2
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotPlaceholder() {
    return Image.asset(
      AssetPath.charFront,
      width: 180,
      height: 180,
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

  Widget _buildTasteProfileGrid() {
    // Figma: 4 horizontal tags with category-specific bottom gradients
    final profile = controller.surveyResult?.tasteProfile;
    if (profile == null) return const SizedBox.shrink();

    final items = [
      _TasteItem(label: '산미', value: profile.acidity),
      _TasteItem(label: '바디감', value: profile.body),
      _TasteItem(label: '단맛', value: profile.sweetness),
      _TasteItem(label: '쓴맛', value: profile.bitterness),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100, // White card base
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _buildTasteProfileTag(items[i]),
            ],
          ],
        ),
      ),
    );
  }

  /// Individual taste tag with bottom gradient (Figma style)
  /// Figma: White base with category-specific gradient at bottom, fading upward
  /// Colors per category: 산미=Blue/Cyan, 바디감=Pink/Magenta, 단맛=Yellow, 쓴맛=Green/Teal
  Widget _buildTasteProfileTag(_TasteItem item) {
    final String levelText;
    final Color gradientColor;

    // Determine level text based on value
    if (item.value >= 70) {
      levelText = '좋음';
    } else if (item.value >= 40) {
      levelText = '보통';
    } else {
      levelText = '싫음';
    }

    // Category-specific gradient colors (Figma design)
    switch (item.label) {
      case '산미':
        gradientColor = const Color(0xFF00BFFF); // Blue/Cyan
        break;
      case '바디감':
        gradientColor = const Color(0xFFFF69B4); // Pink/Magenta
        break;
      case '단맛':
        gradientColor = const Color(0xFFFFD700); // Yellow/Gold
        break;
      case '쓴맛':
        gradientColor = const Color(0xFF20B2AA); // Green/Teal
        break;
      default:
        gradientColor = const Color(0xFF00BFFF);
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.colorGlobalCommon100, // White at top
              AppColor.colorGlobalCommon100, // White in middle
              gradientColor.withOpacity(0.35), // Gradient color at bottom
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category label (top)
            Text(
              item.label,
              style: AppTextStyles.headline2Bold.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
            const SizedBox(height: 4),
            // Level text
            Text(
              levelText,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlavorNotesCard() {
    final flavors = controller.flavorDescriptions;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => controller.retakeSurvey(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(
              0x14707C7C,
            ), // rgba(112, 115, 124, 0.08) per Figma
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
      ),
    );
  }

  // ==================== BOTTOM ACTIONS ====================
  // Figma CSS: background: #F4F4F5; border-radius: 40px; padding: 12px 24px;

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Account actions container - Figma: #F4F4F5, 40px radius, 12px 24px padding
          Container(
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
                // 로그아웃 cell - Figma: height 48px, padding 12px 0
                _buildAccountCell(
                  text: '로그아웃',
                  color: const Color(0xFF171719), // Figma: #171719
                  onTap: () => controller.logout(),
                ),
                // Divider line - Figma: rgba(112, 115, 124, 0.16)
                Container(
                  height: 1,
                  color: const Color(0x29707C7C), // rgba(112, 115, 124, 0.16)
                ),
                // 회원탈퇴 cell - Figma: color #FF4242
                _buildAccountCell(
                  text: '회원탈퇴',
                  color: const Color(0xFFFF4242), // Figma: #FF4242
                  onTap: () => controller.withdrawAccount(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Legal links container - Figma: separate container
          _buildLegalLinks(),
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
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16, // Figma: 16px
            fontWeight: FontWeight.w400, // Figma: 400
            height: 1.5, // 150%
            letterSpacing: 0.0057 * 16,
            color: Color(0xFF171719),
          ).copyWith(color: color),
        ),
      ),
    );
  }

  /// Legal links - Figma: rgba(194, 196, 200, 0.88) text color
  Widget _buildLegalLinks() {
    // Figma CSS: color: rgba(194, 196, 200, 0.88);
    const linkColor = Color(0xE0C2C4C8); // rgba(194, 196, 200, 0.88)

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
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
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0.0057 * 16,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Internal model for the 4-column taste grid items.
class _TasteItem {
  final String label;
  final int value;

  const _TasteItem({required this.label, required this.value});
}
