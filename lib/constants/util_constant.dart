import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Base URL for API calls
const String baseUrl = 'https://api.coflanet-dev.com';

class AppUtil {
  static const String baseUrlScheme = 'https';
  static const String baseUrlHost = 'api.coflanet-dev.com';

  static void showPopup({title = 'New Page', content}) {
    Get.defaultDialog(
      title: title,
      content: Text(content),
      confirmTextColor: AppColor.staticLabelWhiteStrong,
      onConfirm: () => Get.offAllNamed(Routes.mainShell),
      buttonColor: AppColor.primaryNormal,
    );
  }

  static void underConstructionPopup() {
    Get.defaultDialog(
      title: '안내',
      titleStyle: AppTextStyles.headline2Bold.copyWith(
        color: AppColor.labelNormal,
      ),
      content: const Text('준비중 입니다.'),
      textConfirm: '확인',
      confirmTextColor: AppColor.staticLabelWhiteStrong,
      onConfirm: Get.back,
      buttonColor: AppColor.primaryNormal,
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
    Get.snackbar(
      '',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: AppColor.staticLabelWhiteStrong,
      duration: const Duration(seconds: 2),
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
