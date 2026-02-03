import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/enums.dart';
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
        confirmTextColor: Colors.white,
        onConfirm: () => Get.offAllNamed(Routes.app),
        buttonColor: AppColor.primaryNormal);
  }

  static void underConstructionPopup() {
    Get.defaultDialog(
        title: '안내',
        titleStyle: AppTextStyles.headline2Bold.copyWith(
            color: AppColor.labelNormal),
        content: const Text('준비중 입니다.'),
        textConfirm: '확인',
        confirmTextColor: Colors.white,
        onConfirm: Get.back,
        buttonColor: AppColor.primaryNormal);
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
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: height,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                child: page),
          );
        });
  }

  static void showToast(String msg) {
    Get.snackbar(
      '',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // change datetime type from '2023-09-18T14:46:09.360527Z' to '2023.09.18'
  static String changeDateFormat(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat('yyyy.MM.dd', 'ko').format(dateTime);
  }

  // change datetime type from '2023-09-18T14:46:09.360527Z' to '09/19(화)'
  static String changeDateFormatWithDay(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat("MM/dd(E)", 'ko').format(dateTime);
  }

  // change datetime type from '2023-09-18T14:46:09.360527Z' to '2023-09-18 14:46:09'
  static String changeDateFormatWithTime(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat("yyyy-MM-dd HH:mm:ss", 'ko').format(dateTime);
  }

  // change datetime type from '2023-09-18T14:46:09.360527Z' to '2023년 9월'
  static String changeDateFormatToYearAndMonth(String datetime) {
    final dateTime = DateTime.parse(datetime);
    return DateFormat('yyyy년 M월', 'ko').format(dateTime);
  }

  // change datetime type from '2023-09-18T14:46:09.360527Z' to '1초 전'
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

  /// change number to "100,000,000원" type
  static String changeNumberToWon(dynamic number) {
    return NumberFormat('###,###,###원').format(number);
  }

  /// change number to "2,000" type
  static String formatNumberWithComma(dynamic number) {
    return NumberFormat('#,###').format(number);
  }

  static Map<String, dynamic> getProductDetailStatus(
      ProductOrderDetailStatus status) {
    switch (status) {
      case ProductOrderDetailStatus.PAYMENT_WAITING:
        return {'isReviewBtn': false, 'statusText': '결제 대기'};
      case ProductOrderDetailStatus.PAID:
        return {'isReviewBtn': false, 'statusText': '결제 완료'};
      case ProductOrderDetailStatus.PRODUCT_PREPARING:
        return {'isReviewBtn': false, 'statusText': '상품 준비중'};
      case ProductOrderDetailStatus.PREPARE_CANCELED:
        return {'isReviewBtn': false, 'statusText': '발주 취소'};
      case ProductOrderDetailStatus.DELIVERY_PREPARING:
        return {'isReviewBtn': false, 'statusText': '배송 준비중'};
      case ProductOrderDetailStatus.NATIONAL_DELIVERING:
        return {'isReviewBtn': true, 'statusText': '국내 배송중'};
      case ProductOrderDetailStatus.INTERNATIONAL_DELIVERY_PREPARING:
        return {'isReviewBtn': true, 'statusText': '국제 발송대기'};
      case ProductOrderDetailStatus.INTERNATIONAL_DELIVERING:
        return {'isReviewBtn': true, 'statusText': '국제 배송중'};
      case ProductOrderDetailStatus.DELIVERED:
        return {'isReviewBtn': true, 'statusText': '배송완료'};
      case ProductOrderDetailStatus.PURCHASE_DECIDED:
        return {'isReviewBtn': true, 'statusText': '구매확정'};
      case ProductOrderDetailStatus.CANCELED:
        return {'isReviewBtn': true, 'statusText': '취소완료'};
      case ProductOrderDetailStatus.RETURNED:
        return {'isReviewBtn': true, 'statusText': '반품완료'};
    }
  }

  static double getProductDetailStatusPercentage(
      ProductOrderDetailStatus status) {
    switch (status) {
      case ProductOrderDetailStatus.PAYMENT_WAITING:
        return 0.0;
      case ProductOrderDetailStatus.PAID:
        return 7 / 100;
      case ProductOrderDetailStatus.PRODUCT_PREPARING:
        return 7 / 100 * 2;
      case ProductOrderDetailStatus.DELIVERY_PREPARING:
        return 7 / 100 * 3;
      case ProductOrderDetailStatus.NATIONAL_DELIVERING:
        return 7 / 100 * 4;
      case ProductOrderDetailStatus.INTERNATIONAL_DELIVERY_PREPARING:
        return 7 / 100 * 5;
      case ProductOrderDetailStatus.INTERNATIONAL_DELIVERING:
        return 7 / 100 * 6;
      case ProductOrderDetailStatus.DELIVERED:
        return 7 / 100 * 7;
      case ProductOrderDetailStatus.PURCHASE_DECIDED:
        return 0.0;
      case ProductOrderDetailStatus.CANCELED:
        return 0.0;
      case ProductOrderDetailStatus.RETURNED:
        return 0.0;
      case ProductOrderDetailStatus.PREPARE_CANCELED:
        return 0.0;
    }
  }

  static String getZoneCode(city) {
    String zoneCode = '';

    switch (city) {
      case '하노이':
        zoneCode = 'VN:HN';
        break;
      case '다낭':
        zoneCode = 'VN:DN';
        break;
      case '호치민':
        zoneCode = 'VN:SG';
        break;
      default:
        zoneCode = '';
    }

    return zoneCode;
  }

  static String getZoneKorName(city) {
    String zoneName = '';

    switch (city) {
      case 'Ha Noi':
        zoneName = '하노이';
        break;
      case 'Da Nang':
        zoneName = '다낭';
        break;
      case 'Ho Chi Minh':
        zoneName = '호치민';
        break;
      default:
        zoneName = city;
    }

    return zoneName;
  }

  // Connection closed before full header was received 이슈 대응
  static String reformatImageUrl(String url) {
    if (url.startsWith('https')) {
      url = url.replaceFirst('https', 'http');
    }
    return url;
  }
}
