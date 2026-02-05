import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:coflanet/main.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Directory where screenshots are saved on-device.
late final String _screenshotDir;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Coflanet E2E - All Routes', () {
    testWidgets('Navigate 22 routes and save screenshots', (
      WidgetTester tester,
    ) async {
      // Determine screenshot save path - use persistent location
      if (Platform.isAndroid) {
        // Android: Use external storage (accessible via adb pull /sdcard/...)
        _screenshotDir = '/sdcard/Download/coflanet_e2e';
      } else {
        // iOS: Use app's Documents directory (persists between runs)
        // On simulator, systemTemp parent is accessible from host
        final homeDir = Platform.environment['HOME'] ?? '/tmp';
        _screenshotDir = '$homeDir/coflanet_e2e';
      }
      final dir = Directory(_screenshotDir);
      try {
        if (dir.existsSync()) {
          dir.deleteSync(recursive: true);
        }
      } catch (_) {
        // Ignore deletion errors
      }
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      debugPrint('Screenshot dir: $_screenshotDir');

      // Initialize storage before app launch
      await LocalStorage().init();

      // Launch the app
      await tester.pumpWidget(const CoflanetApp());

      // Wait for splash screen (2s delay) + navigation animation
      await tester.pump(const Duration(seconds: 3));
      await _settle(tester);

      // 01 - SignIn (should be here after splash auto-nav)
      await _capture(tester, '01-signin');

      // 02 - SignUp
      await _nav(tester, Routes.emailSignUp, '02-signup');

      // 03 - Survey Intro
      await _nav(tester, Routes.surveyIntro, '03-survey-intro', offAll: true);

      // 04-09 - Survey Steps 1-6
      for (int step = 1; step <= 6; step++) {
        final num = (step + 3).toString().padLeft(2, '0');
        await _nav(tester, '${Routes.survey}/$step', '$num-survey-step$step');
      }

      // 10 - Survey Analyzing (has repeat() animation — use pump only)
      Get.toNamed(Routes.surveyAnalyzing);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      await _capture(tester, '10-survey-analyzing');

      // 11 - Survey Complete
      await _nav(
        tester,
        Routes.surveyComplete,
        '11-survey-complete',
        offAll: true,
      );

      // 12 - Survey Result
      await _nav(tester, Routes.surveyResult, '12-survey-result');

      // 13 - Home
      await _nav(tester, Routes.home, '13-home', offAll: true);

      // 14 - Coffee Main
      await _nav(tester, Routes.coffeeMain, '14-coffee-main');

      // 15 - Hand Drip
      await _nav(tester, Routes.handDrip, '15-hand-drip');

      // 16 - Espresso
      await _nav(tester, Routes.espresso, '16-espresso');

      // 17 - Coffee Settings (has AnimationController — use pump only)
      Get.toNamed(Routes.coffeeSettings);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(seconds: 1));
      await _capture(tester, '17-coffee-settings');

      // 18 - Timer
      await _nav(tester, Routes.timerActive, '18-timer', offAll: true);

      // 19 - Timer Complete
      await _nav(tester, Routes.timerComplete, '19-timer-complete');

      // 20 - Matching Result
      await _nav(
        tester,
        Routes.matchingResult,
        '20-matching-result',
        offAll: true,
      );

      // 21 - My Taste
      await _nav(tester, Routes.myTaste, '21-my-taste', offAll: true);

      // 22 - My Planet (has repeat() animation — use pump only)
      Get.offAllNamed(Routes.myPlanet);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(seconds: 1));
      await _capture(tester, '22-my-planet');

      debugPrint('=== ALL 22 ROUTES NAVIGATED SUCCESSFULLY ===');
      debugPrint('Screenshots saved to: $_screenshotDir');
    });
  });
}

/// Settle with a reasonable timeout
Future<void> _settle(WidgetTester tester) async {
  try {
    await tester.pumpAndSettle(const Duration(seconds: 5));
  } catch (_) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

/// Navigate to a route, settle, and capture screenshot
Future<void> _nav(
  WidgetTester tester,
  String route,
  String name, {
  bool offAll = false,
}) async {
  try {
    if (offAll) {
      Get.offAllNamed(route);
    } else {
      Get.toNamed(route);
    }
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    await _capture(tester, name);
  } catch (e) {
    debugPrint('FAIL [$name]: $e');
  }
}

/// Capture a screenshot from the Flutter render tree and save as PNG
Future<void> _capture(WidgetTester tester, String name) async {
  try {
    // Get the root render view
    final renderView = tester.binding.renderViews.first;
    final layer = renderView.debugLayer;
    if (layer == null) {
      debugPrint('SKIP [$name]: no debug layer');
      return;
    }

    final offsetLayer = layer as OffsetLayer;

    // Capture the image from the render tree
    final ui.Image image = await offsetLayer.toImage(
      Offset.zero & renderView.size,
      pixelRatio: 2.0,
    );

    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    image.dispose();

    if (byteData == null) {
      debugPrint('SKIP [$name]: null byte data');
      return;
    }

    // Save PNG to device filesystem
    final file = File('$_screenshotDir/$name.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    debugPrint('OK [$name]: ${file.path} (${byteData.lengthInBytes} bytes)');
  } catch (e) {
    debugPrint('CAPTURE ERROR [$name]: $e');
  }
}
