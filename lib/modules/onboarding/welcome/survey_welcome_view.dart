import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Survey Welcome Screen (Figma: 1114:59435 - Survey_intro)
/// Exact Figma CSS implementation
class SurveyWelcomeView extends StatelessWidget {
  const SurveyWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<LocalStorage>();
    final userName = storage.getUserName() ?? '사용자';

    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal, // #FFFFFF
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Text section
            _buildTextSection(userName),

            // Gap between text and thumbnail (59px per Figma)
            const SizedBox(height: 39), // 59 - 20 (text section bottom padding)
            // Thumbnail placeholder (200x200)
            _buildThumbnailPlaceholder(),

            const Spacer(),

            // Bottom CTA
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AssetPath.iconArrowBack,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            AppColor.labelNormal, // #171719
            BlendMode.srcIn,
          ),
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

  /// Text section per Figma CSS
  /// padding: 24px 20px 20px, gap: 8px
  Widget _buildTextSection(String userName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          // "커플래닛에 오신 걸 환영해요 🎉"
          // font-size: 14px, font-weight: 600, line-height: 142.9%, color: #6541F2
          Text(
            '커플래닛에 오신 걸 환영해요 🎉',
            style: AppTextStyles.label1NormalBold.copyWith(
              color: AppColor.primaryNormal, // #6541F2
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.429,
              letterSpacing: 0.0145 * 14, // 0.0145em
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // "[이름]님의 취향을 찾으러 가볼까요?"
          // font-size: 24px, font-weight: 700, line-height: 133.4%, color: #171719
          Text(
            '$userName님의 취향을\n찾으러 가볼까요?',
            style: AppTextStyles.title1Bold.copyWith(
              color: AppColor.labelNormal, // #171719
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.334,
              letterSpacing: -0.023 * 24, // -0.023em
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Thumbnail placeholder (200x200 per Figma)
  /// Will be replaced with actual image later
  Widget _buildThumbnailPlaceholder() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: AppColor.labelAssistive,
        ),
      ),
    );
  }

  /// Bottom CTA per Figma CSS
  /// Button: background: #6541F2, border-radius: 99px, height: 52px
  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: '취향 찾으러 가기',
            onPressed: () {
              Get.toNamed(Routes.surveyIndex);
            },
          ),
          const SizedBox(height: 34), // Home indicator space
        ],
      ),
    );
  }
}
