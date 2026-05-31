import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';

/// Home Controller — Figma `Home_Item_yes` 화면 데이터 공급
///
/// 노출 데이터:
/// - 상단 추천(보유 원두) 캐러셀: 사용자의 원두 목록 활용
/// - 취향 기반 추천 그리드: 백엔드 API 미연동 → 빈 배열 [백엔드 API 연동 대기]
/// - 카테고리/베스트/실시간 인기 등 섹션: 백엔드 미연동 → 빈 배열 [백엔드 API 연동 대기]
class HomeController extends BaseController {
  final CoffeeRepository _coffeeRepository =
      RepositoryProvider.coffeeRepository;
  final AuthService _authService = Get.find<AuthService>();
  final SurveyService _surveyService = Get.find<SurveyService>();

  // 보유 원두 (스토어 데이터) — 상단 캐러셀에 표시
  final _myBeans = <CoffeeItem>[].obs;
  List<CoffeeItem> get myBeans => _myBeans;
  bool get hasMyBeans => _myBeans.isNotEmpty;

  /// 취향 기반 추천 그리드 — [백엔드 API 연동 대기]
  final _tasteRecommendations = <CoffeeItem>[].obs;
  List<CoffeeItem> get tasteRecommendations => _tasteRecommendations;
  bool get hasTasteRecommendations => _tasteRecommendations.isNotEmpty;

  /// 카테고리별 베스트 상품 — [백엔드 API 연동 대기]
  final _categoryBest = <CoffeeItem>[].obs;
  List<CoffeeItem> get categoryBest => _categoryBest;
  bool get hasCategoryBest => _categoryBest.isNotEmpty;

  /// 실시간 인기 — [백엔드 API 연동 대기]
  final _realtimePopular = <CoffeeItem>[].obs;
  List<CoffeeItem> get realtimePopular => _realtimePopular;
  bool get hasRealtimePopular => _realtimePopular.isNotEmpty;

  /// 좋아요 (찜) ID 집합 — 로컬 상태, [백엔드 API 연동 대기]
  final _likedIds = <String>{}.obs;

  /// 상단 광고 캐러셀 — [백엔드 API 연동 대기] banners 테이블 연결 시 실제 데이터
  /// 현재는 placeholder 5개로 페이지 카운트만 운영
  static const int carouselTotalCount = 5;
  final PageController carouselController = PageController();
  final RxInt carouselIndex = 0.obs;

  void onCarouselPageChanged(int index) {
    carouselIndex.value = index;
  }

  String get userName {
    final name = _authService.currentUser?.name;
    return (name != null && name.isNotEmpty) ? name : 'ㅇㅇㅇ';
  }

  /// 설문 완료 여부 — 노란 배너 표시 조건
  bool get hasTasteProfile => _surveyService.hasResult;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    showLoading();
    try {
      // 보유 원두 (실제 스토어 데이터)
      _myBeans.value = await _coffeeRepository.getCoffeeItems();

      // [백엔드 API 연동 대기] 추천 / 카테고리 / 인기 API
      // 현재는 빈 배열 유지 → UI 가 empty 상태 분기 표시
      _tasteRecommendations.clear();
      _categoryBest.clear();
      _realtimePopular.clear();
    } finally {
      hideLoading();
    }
  }

  @override
  Future<void> refresh() async => _loadData();

  @override
  void onClose() {
    carouselController.dispose();
    super.onClose();
  }

  bool isLiked(String id) => _likedIds.contains(id);

  /// 좋아요 토글 — [백엔드 API 연동 대기] 서버 반영
  void toggleLike(String id) {
    if (_likedIds.contains(id)) {
      _likedIds.remove(id);
    } else {
      _likedIds.add(id);
    }
    _likedIds.refresh();
  }
}
