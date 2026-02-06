import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/constants/color_constant.dart';

/// Dummy coffee data for development and testing
class DummyCoffeeData {
  DummyCoffeeData._();

  static const List<CoffeeItem> coffeeItems = [
    // Original 4 items
    CoffeeItem(
      id: '1',
      name: '에티오피아 예가체프',
      description: '과일향, 꽃향이 풍부한 산미 커피',
      color: AppColor.colorGlobalOrange50,
    ),
    CoffeeItem(
      id: '2',
      name: '콜롬비아 수프리모',
      description: '균형 잡힌 맛과 부드러운 바디감',
      color: AppColor.colorGlobalGreen50,
    ),
    CoffeeItem(
      id: '3',
      name: '케냐 AA',
      description: '강한 산미와 와인 같은 풍미',
      color: AppColor.colorGlobalRed50,
    ),
    CoffeeItem(
      id: '4',
      name: '과테말라 안티구아',
      description: '스모키한 향과 초콜릿 같은 맛',
      color: AppColor.colorGlobalViolet50,
    ),
    // 12 new items
    CoffeeItem(
      id: '5',
      name: '브라질 산토스',
      description: '고소한 견과류 향과 낮은 산미',
      color: AppColor.colorGlobalBlue50,
    ),
    CoffeeItem(
      id: '6',
      name: '인도네시아 만델링',
      description: '묵직한 바디감과 허브 향',
      color: AppColor.colorGlobalPink50,
    ),
    CoffeeItem(
      id: '7',
      name: '코스타리카 따라주',
      description: '밝은 산미와 깔끔한 뒷맛',
      color: AppColor.colorGlobalCyan50,
    ),
    CoffeeItem(
      id: '8',
      name: '파나마 게이샤',
      description: '재스민 향과 복숭아 같은 단맛',
      color: AppColor.colorGlobalYellow50,
    ),
    CoffeeItem(
      id: '9',
      name: '르완다 킨보',
      description: '베리류 과일향과 부드러운 산미',
      color: AppColor.colorGlobalOrange50,
    ),
    CoffeeItem(
      id: '10',
      name: '에티오피아 시다모',
      description: '레몬 시트러스와 플로럴 노트',
      color: AppColor.colorGlobalGreen50,
    ),
    CoffeeItem(
      id: '11',
      name: '탄자니아 킬리만자로',
      description: '와인 같은 산미와 풍부한 향',
      color: AppColor.colorGlobalRed50,
    ),
    CoffeeItem(
      id: '12',
      name: '하와이 코나',
      description: '부드럽고 달콤한 캐러멜 향',
      color: AppColor.colorGlobalViolet50,
    ),
    CoffeeItem(
      id: '13',
      name: '자메이카 블루마운틴',
      description: '완벽한 균형과 부드러운 맛',
      color: AppColor.colorGlobalBlue50,
    ),
    CoffeeItem(
      id: '14',
      name: '예멘 모카',
      description: '초콜릿과 와인의 복합적인 풍미',
      color: AppColor.colorGlobalPink50,
    ),
    CoffeeItem(
      id: '15',
      name: '베트남 로부스타',
      description: '강렬한 쓴맛과 진한 바디감',
      color: AppColor.colorGlobalCyan50,
    ),
    CoffeeItem(
      id: '16',
      name: '페루 찬차마요',
      description: '밀크 초콜릿과 견과류 풍미',
      color: AppColor.colorGlobalYellow50,
    ),
  ];
}
