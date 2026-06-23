import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Base URL for API calls
const String baseUrl = 'https://api.coflanet-dev.com';

class AppUtil {
  static const String baseUrlScheme = 'https';
  static const String baseUrlHost = 'api.coflanet-dev.com';

  static void showPopup({title = 'New Page', content}) {
    // Get.defaultDialog 는 context 밖에서 호출되므로 Get.context 로 스킴 취득
    final colors = AppColorScheme.of(Get.context!);
    Get.defaultDialog(
      title: title,
      titleStyle: AppTextStyles.headline2Bold.copyWith(
        color: colors.labelNormal,
      ),
      content: Text(
        content,
        style: AppTextStyles.body2NormalRegular.copyWith(
          color: colors.labelNormal,
        ),
      ),
      backgroundColor: colors.backgroundElevatedNormal,
      confirmTextColor: AppColor.staticLabelWhiteStrong,
      onConfirm: () => Get.offAllNamed(Routes.mainShell),
      buttonColor: colors.primaryNormal,
    );
  }

  static void underConstructionPopup() {
    // Get.defaultDialog 는 context 밖에서 호출되므로 Get.context 로 스킴 취득
    final colors = AppColorScheme.of(Get.context!);
    Get.defaultDialog(
      title: '안내',
      titleStyle: AppTextStyles.headline2Bold.copyWith(
        color: colors.labelNormal,
      ),
      content: Text(
        '준비중 입니다.',
        style: AppTextStyles.body2NormalRegular.copyWith(
          color: colors.labelNormal,
        ),
      ),
      backgroundColor: colors.backgroundElevatedNormal,
      textConfirm: '확인',
      confirmTextColor: AppColor.staticLabelWhiteStrong,
      onConfirm: Get.back,
      buttonColor: colors.primaryNormal,
    );
  }

  static void showModalBottom({
    required BuildContext context,
    double? height,
    Widget? page,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: page,
          ),
        );
      },
    );
  }

  static void showToast(String msg) {
    final colors = AppColorScheme.of(Get.context!);
    Get.snackbar(
      '',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colors.statusNegative,
      colorText: AppColor.staticLabelWhiteStrong,
      duration: const Duration(seconds: 2),
    );
  }

  /// 성공/안내 스낵바 — 보라(primary) 배경 + 흰 텍스트, 테마 반응.
  ///
  /// 컨트롤러에서 색을 직접 만지지 말고 항상 이 유틸을 사용한다
  /// (정적 토큰 직접 사용으로 인한 다크모드 불일치 재발 방지).
  static void showSuccessSnackbar(String title, String message) {
    final colors = AppColorScheme.of(Get.context!);
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colors.primaryNormal.withValues(alpha: 0.95),
      colorText: AppColor.staticLabelWhiteStrong,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  /// 에러 스낵바 — 빨강(statusNegative) 배경 + 흰 텍스트, 테마 반응.
  static void showErrorSnackbar(String title, String message) {
    final colors = AppColorScheme.of(Get.context!);
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colors.statusNegative.withValues(alpha: 0.95),
      colorText: AppColor.staticLabelWhiteStrong,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(Icons.error_outline, color: AppColor.staticLabelWhiteStrong),
    );
  }

  /// 상단에서 부드럽게 내려와 잠시 보였다가 다시 올라가는 안내 토스트.
  ///
  /// 에러용(빨강) [showToast] 와 달리 중립 반전 톤 — 가벼운 안내/검증 메시지에 사용.
  /// 테마 반전(inverse) 토큰 사용: 라이트=어두운 토스트, 다크=밝은 토스트.
  static void showTopToast(String msg) {
    final colors = AppColorScheme.of(Get.context!);
    // 떠 있는 토스트가 있으면 닫고 새로 표시 (중복 누적 방지)
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.rawSnackbar(
      messageText: Text(
        msg,
        textAlign: TextAlign.center,
        style: AppTextStyles.body2NormalMedium.copyWith(
          color: colors.inverseLabelStrong,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: colors.inverseBackground.withValues(alpha: 0.96),
      borderRadius: 14,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      duration: const Duration(milliseconds: 1600),
      animationDuration: const Duration(milliseconds: 450),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      boxShadows: AppShadows.shadowBlackStrong,
    );
  }

  /// Format datetime string to 'yyyy.MM.dd'
  static String changeDateFormat(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat('yyyy.MM.dd', 'ko').format(dateTime);
  }

  /// Format datetime string to 'MM/dd(E)'
  static String changeDateFormatWithDay(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat("MM/dd(E)", 'ko').format(dateTime);
  }

  /// Format datetime string to 'yyyy-MM-dd HH:mm:ss'
  static String changeDateFormatWithTime(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat("yyyy-MM-dd HH:mm:ss", 'ko').format(dateTime);
  }

  /// Format datetime string to 'yyyy년 M월'
  static String changeDateFormatToYearAndMonth(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat('yyyy년 M월', 'ko').format(dateTime);
  }

  /// Format datetime string to relative time ('1초 전', '3일 전', etc.)
  static String changeDateToAgo(String datetime) {
    DateTime now = DateTime.now();
    DateTime parsedDate = DateTime.parse(datetime);
    Duration diff = now.difference(parsedDate);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}년 전';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}달 전';
    } else if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()}주 전';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}일 전';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간 전';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inSeconds > 0) {
      return '${diff.inSeconds}초 전';
    } else if (diff.inSeconds == 0) {
      return '방금 전';
    } else {
      return '';
    }
  }

  /// Format number to "100,000,000원"
  static String changeNumberToWon(dynamic number) {
    return NumberFormat('###,###,###원').format(number);
  }

  /// Format number to "2,000"
  static String formatNumberWithComma(dynamic number) {
    return NumberFormat('#,###').format(number);
  }
}
