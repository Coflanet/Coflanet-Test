import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/dummy/dummy_shopping_data.dart';
import 'package:coflanet/data/models/banner_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/routes/app_pages.dart';

/// 쇼핑 탭 컨트롤러 — Figma `Shopping_Main`(101:28335) 데이터 공급.
///
/// 상품/배너 데이터는 쇼핑 전용 API 부재로 [DummyShoppingData] 샘플을 쓴다
/// ([백엔드 API 연동 대기]). 좋아요/타임세일 카운트다운은 로컬 상태.
class ShoppingController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();
  final SurveyService _surveyService = Get.find<SurveyService>();

  // ===== 상단 캐러셀 =====
  final PageController carouselController = PageController();
  final RxInt carouselIndex = 0.obs;
  List<BannerModel> get carouselBanners => DummyShoppingData.carouselBanners;
  void onCarouselPageChanged(int index) => carouselIndex.value = index;

  /// 프로모 배너
  BannerModel get promoBanner => DummyShoppingData.promoBanner;

  // ===== 상품 섹션 (반응형 — 재추천 시 갱신) =====
  final _recommended = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get recommended => _recommended;

  final _categoryBest = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get categoryBest => _categoryBest;

  final _ranking = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get ranking => _ranking;

  final _realtimePopular = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get realtimePopular => _realtimePopular;

  final _timeSale = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get timeSale => _timeSale;

  // ===== 좋아요(찜) — 로컬 상태, [백엔드 API 연동 대기] =====
  final _likedIds = <String>{}.obs;
  bool isLiked(String id) => _likedIds.contains(id);
  void toggleLike(String id) {
    if (_likedIds.contains(id)) {
      _likedIds.remove(id);
    } else {
      _likedIds.add(id);
    }
    _likedIds.refresh();
  }

  // ===== 취향 배너 (홈과 동일 소스) =====
  String get userName {
    final name = _authService.currentUser?.name;
    return (name != null && name.isNotEmpty) ? name : '커피러버';
  }

  String get tasteTypeLabel =>
      _surveyService.surveyResult?.coffeeTypeLabel ?? '';
  List<FlavorDescriptionModel> get tasteFlavors =>
      _surveyService.surveyResult?.flavorDescriptions ?? const [];

  // ===== 타임세일 카운트다운 =====
  final RxString timeSaleRemaining = '00:00:00'.obs;
  Timer? _saleTimer;
  // 마감까지 남은 시간(초). 데모용 고정 시작값 — 0 도달 시 하루로 리셋.
  static const int _saleStartSeconds = 5 * 3600 + 32 * 60 + 17;
  int _saleSeconds = _saleStartSeconds;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _startSaleTimer();
  }

  Future<void> _loadData() async {
    showLoading();
    _recommended.value = DummyShoppingData.recommended;
    _categoryBest.value = DummyShoppingData.categoryBest;
    _ranking.value = DummyShoppingData.ranking;
    _realtimePopular.value = DummyShoppingData.realtimePopular;
    _timeSale.value = DummyShoppingData.timeSale;
    hideLoading();
    // 설문 결과(취향 배너용)는 비치명 — 실패해도 쇼핑은 계속.
    try {
      await _surveyService.refresh();
    } catch (_) {}
  }

  void _startSaleTimer() {
    _updateSaleText();
    _saleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _saleSeconds = _saleSeconds <= 0 ? _saleStartSeconds : _saleSeconds - 1;
      _updateSaleText();
    });
  }

  void _updateSaleText() {
    final h = _saleSeconds ~/ 3600;
    final m = (_saleSeconds % 3600) ~/ 60;
    final s = _saleSeconds % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    timeSaleRemaining.value = '${two(h)}:${two(m)}:${two(s)}';
  }

  /// '다시 추천해주세요' — 추천 목록을 섞어 새 셀렉션을 보여준다.
  void reshuffleRecommended() {
    final shuffled = _recommended.toList()..shuffle();
    _recommended.value = shuffled;
  }

  /// 상품 카드 탭 — 인앱 상품 상세로 이동.
  void onProductTap(CoffeeRecommendationModel item) {
    Get.toNamed(Routes.productDetail, arguments: {'product': item});
  }

  /// '전체보기' 등 미연동 동선 — [백엔드 API 연동 대기] 안내.
  void showComingSoon() {
    Get.snackbar(
      '쇼핑',
      '전체 목록은 준비 중이에요',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    _saleTimer?.cancel();
    carouselController.dispose();
    super.onClose();
  }
}
