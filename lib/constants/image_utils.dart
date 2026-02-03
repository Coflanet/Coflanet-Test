import 'package:get/get.dart';

/// Image utility functions
/// TODO: Add image_picker package when needed
class ImageUtils {
  static void showImageLimitPopup(int maxImgCount) {
    Get.snackbar(
      '알림',
      '업로드는 최대 $maxImgCount개까지 가능합니다.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void deleteSingleImg({required List<dynamic> imgList}) {
    imgList.clear();
  }

  static void deleteMultiImgs({
    required List<dynamic> imgList,
    required dynamic img,
  }) {
    imgList.remove(img);
  }
}
