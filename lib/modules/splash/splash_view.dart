import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/splash/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access controller to trigger lazy initialization (onInit)
    final _ = controller;

    // Set status bar to light (white icons) for dark background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.colorGlobalViolet50,
              AppColor.colorGlobalViolet40,
            ],
          ),
        ),
        child: Center(
          // 상수 프리로드 실패 시 재시도 UI, 그 외(로딩/정상)에는 로고 표시
          child: Obx(
            () => controller.config.hasError
                ? _buildErrorRetry()
                : _buildLogo(),
          ),
        ),
      ),
    );
  }

  /// 로고 (로딩/정상 상태 공통)
  Widget _buildLogo() {
    // Logo - Using logo_splash.png which already contains icon + "Coflanet" text
    return Image.asset(
      AssetPath.logoSplash,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
      semanticLabel: 'Coflanet 로고',
      errorBuilder: (context, error, stackTrace) => Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.15),
          borderRadius: AppRadius.fullBorder,
        ),
        child: Icon(
          Icons.all_inclusive_rounded,
          size: 64,
          color: AppColor.staticLabelWhiteStrong,
        ),
      ),
    );
  }

  /// 프리로드 실패 시 안내 + 다시 시도 버튼
  Widget _buildErrorRetry() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: AppColor.staticLabelWhiteStrong,
          ),
          const SizedBox(height: 20),
          Text(
            '연결에 실패했어요.\n잠시 후 다시 시도해 주세요.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: AppColor.staticLabelWhiteStrong,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: controller.retry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.staticLabelWhiteStrong,
              foregroundColor: AppColor.colorGlobalViolet50,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonBorder,
              ),
            ),
            child: Text('다시 시도', style: AppTextStyles.headline2Bold),
          ),
        ],
      ),
    );
  }
}
