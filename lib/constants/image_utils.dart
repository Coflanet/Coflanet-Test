import 'package:flutter/material.dart';
import 'package:coflanet/constants/util_constant.dart';

class ImageUtils {
  static void addSingleImg({required List<dynamic> imgList}) async {
    var file = await AppUtil.pickImage();
    if (imgList.isNotEmpty) {
      imgList.clear();
    }
    imgList.add(file);
  }

  static void deleteSingleImg({required List<dynamic> imgList}) async {
    imgList.clear();
  }

  static void addMultiImgs(BuildContext context,
      {required List<dynamic> imgList,
      dynamic img,
      required int maxImgCount}) async {
    if (img != null) {
      imgList.remove(img);
    }
    var files = await AppUtil.pickImages();
    if (imgList.length + files.length < maxImgCount + 1) {
      imgList.addAll(files);
    } else {
      AppUtil.showPopup(title: '업로드는 최대 $maxImgCount개까지 가능합니다.');
    }
  }

  static void deleteMultImgs(
      {required List<dynamic> imgList, required dynamic img}) async {
    imgList.remove(img);
  }
}
