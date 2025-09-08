import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/enums.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/controllers/item_filter/item_filter_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

class AppUtil {
  static const String baseUrlScheme = 'https';
  static const String baseUrlHost = 'api.coflanet-dev.com';
  static const String baseUrl = 'https://api.coflanet-dev.com';

  // static const COGNITO_CLIENT_ID = '477a7be9c12a4ba6921b3b24ae082a49';
  // static const COGNITO_POOL_ID = 'ap-northeast-2_RBfujFfAY';
  // static const COGNITO_POOL_URL = 'coflanet-customer-dev.auth.ap-northeast-2';
  // static const CLIENT_SECRET =
  //     '1r7n03jpdplb4d4tes67hnvmb2hf5l56nt3f7dapsej66ad173jh';

  static void showPopup({title = 'New Page', content}) {
    Get.defaultDialog(
        title: title,
        content: Text(content),
        confirmTextColor: Colors.white,
        onConfirm: () => Get.offAllNamed(Routes.app),
        buttonColor: AppColor.subColor);
  }

  static void underConstructionPopup() {
    Get.defaultDialog(
        title: '안내',
        titleStyle: AppTextStyles.SYS_subhead.copyWith(
            color: AppColor.fillSecondaryColor),
        content: const Text('준비중 입니다.'),
        textConfirm: '확인',
        confirmTextColor: Colors.white,
        onConfirm: Get.back,
        buttonColor: AppColor.subColor);
  }

  static void showModalBottom({
    required BuildContext context,
    ItemFilterController? controller,
    double? height,
    Widget? page,
    bool? isCategory,
    bool? isPrice,
    bool? isSort,
  }) {
    Future future = showModalBottomSheet(
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
    if (isSort == true) {
      future.then((value) => controller?.onSortTap(sortType: value));
    } else if (isCategory == true) {
      future.then(
          (value) => controller?.onCategoryTap(selectedCategories: value));
    } else if (isPrice == true) {
      future.then((value) => controller?.onPriceTap(selectedPrices: value));
    }
  }

  static void showShareModalBottom({
    required BuildContext context,
    required VoidCallback firebaseCallback,
    required VoidCallback kakaoCallback,
  }) {
    Future future = showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('링크로 공유하기'),
                onTap: () => firebaseCallback(),
              ),
              ListTile(
                leading: SvgPicture.asset('assets/images/ic_20_kakao.svg'),
                title: const Text('카카오 공유하기'),
                onTap: () => kakaoCallback(),
              ),
            ],
          );
        });
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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

  static Future<XFile?> pickImage() async {
    try {
      XFile? result = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (result != null) {
        XFile image = XFile(result.path);
        return image;
      }
    } on PlatformException catch (e) {
      print('Error while picking gallery image: $e');
    }
    return null;
  }

  static Future<List<XFile>> pickImages() async {
    try {
      List<XFile>? result = await ImagePicker().pickMultiImage(
        imageQuality: 80,
      );
      if (result.isNotEmpty) {
        List<XFile> images = result.map((e) => XFile(e.path)).toList();
        return images;
      }
    } on PlatformException catch (e) {
      print('Error picking gallery image: $e');
    }
    return <XFile>[];
  }

  // 이미지 업로드
  static Future<List> uploadFile(List<dynamic> imageBytes,
      {required String authToken}) async {
    try {
      final url = Uri.parse('${AppUtil.baseUrl}/api/v1/customer/files');

      // Create a multipart request
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] =
          'Bearer ${authToken.replaceAll('"', '')}';
      for (var i = 0; i < imageBytes.length; i++) {
        var fileBytes = await imageBytes[i].readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: imageBytes[i].name,
        ));
      }
      var response = await request.send();
      if (response.statusCode == 201) {
        var code = await response.stream.bytesToString();
        List decodeCode =
            json.decode(code).map((e) => e['code'].toString()).toList();
        return decodeCode;
      } else {
        throw Exception('Failed to upload product images');
      }
    } catch (e) {
      print('Error uploading product images: $e');
      rethrow;
    }
  }

  // Connection closed before full header was received 이슈 대응
  static String reformatImageUrl(String url) {
    if (url.startsWith('https')) {
      url = url.replaceFirst('https', 'http');
    }
    return url;
  }
}
