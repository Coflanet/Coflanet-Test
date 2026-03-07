import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
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
          // Logo - Using logo_splash.png which already contains icon + "Coflanet" text
          child: Image.asset(
            AssetPath.logoSplash,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColor.staticLabelWhiteStrong.withOpacity(0.15),
                borderRadius: AppRadius.fullBorder,
              ),
              child: Icon(
                Icons.all_inclusive_rounded,
                size: 64,
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
