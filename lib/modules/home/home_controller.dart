import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/auth_service.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/models/banner_model.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Home Controller — Figma `Home_Item_yes` 화면 데이터 공급
///
/// 노출 데이터:
/// - 상단 추천(보유 원두) 캐러셀: 사용자의 원두 목록 활용
/// - 취향 기반 추천 그리드: 백엔드 API 미연동 → 빈 배열 [백엔드 API 연동 대기]
/// - 카테고리/베스트/실시간 인기 등 섹션: 백엔드 미연동 → 빈 배열 [백엔드 API 연동 대기]
class HomeController extends BaseController {
  final CoffeeRepository _coffeeRepository =
      RepositoryProvider.coffeeRepository;
  final BannerRepository _bannerRepository =
      RepositoryProvider.bannerRepository;
  final AuthService _authService = Get.find<AuthService>();
  final SurveyService _surveyService = Get.find<SurveyService>();

  // 보유 원두 (스토어 데이터) — 상단 캐러셀에 표시
  final _myBeans = <CoffeeItem>[].obs;
  List<CoffeeItem> get myBeans => _myBeans;
  bool get hasMyBeans => _myBeans.isNotEmpty;

  /// 취향 기반 추천 그리드 — 설문 결과(get_my_recommendations) 연동
  final _tasteRecommendations = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get tasteRecommendations =>
      _tasteRecommendations;
  bool get hasTasteRecommendations => _tasteRecommendations.isNotEmpty;

  /// 취향 배너 — 커피 타입 라벨 (예: '시트러스 러버')
  String get tasteTypeLabel =>
      _surveyService.surveyResult?.coffeeTypeLabel ?? '';

  /// 취향 배너 — 향미 설명 칩 (이름/이모지)
  List<FlavorDescriptionModel> get tasteFlavors =>
      _surveyService.surveyResult?.flavorDescriptions ?? [];

  /// 카테고리별 베스트 상품 — [백엔드 API 연동 대기] (전용 API 부재로 빈 상태 유지)
  final _categoryBest = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get categoryBest => _categoryBest;
  bool get hasCategoryBest => _categoryBest.isNotEmpty;

  /// 실시간 인기 — [백엔드 API 연동 대기] (전용 API 부재로 빈 상태 유지)
  final _realtimePopular = <CoffeeRecommendationModel>[].obs;
  List<CoffeeRecommendationModel> get realtimePopular => _realtimePopular;
  bool get hasRealtimePopular => _realtimePopular.isNotEmpty;

  /// 좋아요 (찜) ID 집합 — 로컬 상태, [백엔드 API 연동 대기]
  final _likedIds = <String>{}.obs;

  /// 홈 배너 (banners 테이블 — get_active_banners RPC)
  final _banners = <BannerModel>[].obs;

  /// 캐러셀 슬롯 배너 (비어 있으면 캐러셀이 placeholder 1장 표시)
  List<BannerModel> get carouselBanners =>
      _banners.where((b) => b.slot == BannerSlot.homeCarousel).toList();

  /// 프로모 슬롯 배너 — 없으면 프로모 배너 섹션 미노출
  BannerModel? get promoBanner {
    for (final banner in _banners) {
      if (banner.slot == BannerSlot.homePromo) return banner;
    }
    return null;
  }

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
      // 설문 결과(취향 프로필 + 추천) 최신화
      await _surveyService.refresh();

      // 보유 원두 (실제 스토어 데이터)
      _myBeans.value = await _coffeeRepository.getCoffeeItems();

      // 홈 배너 — 실패해도 홈 로딩은 계속 (비치명)
      try {
        _banners.value = await _bannerRepository.getActiveBanners();
      } catch (e) {
        if (kDebugMode) debugPrint('[HomeController] 배너 조회 실패: $e');
        _banners.clear();
      }

      // 취향 기반 추천 — 설문 결과의 recommendations 사용
      _tasteRecommendations.value =
          _surveyService.surveyResult?.recommendations ?? [];

      // [백엔드 API 연동 대기] 카테고리 / 실시간 인기 전용 API
      // 현재는 빈 배열 유지 → UI 가 empty 상태 분기 표시
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

  /// 배너 탭 — action_type 별 분기
  Future<void> onBannerTap(BannerModel banner) async {
    switch (banner.actionType) {
      case BannerActionType.openUrl:
        final url = banner.url;
        if (url == null || url.isEmpty) return;
        final uri = Uri.tryParse(url);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      case BannerActionType.claimCoupon:
        await _claimCoupon(banner.couponId);
      case BannerActionType.openBean:
        // [스펙 미확정] 원두 상세 진입 동선 확정 시 라우팅 연결
        break;
      case BannerActionType.none:
        break;
    }
  }

  /// 쿠폰 발급 — 중복 발급은 안내, 실패는 에러 스낵바
  Future<void> _claimCoupon(String? couponId) async {
    if (couponId == null || couponId.isEmpty) return;
    try {
      final result = await _bannerRepository.claimCoupon(couponId);
      final isNew = result['is_new'] == true;
      Get.snackbar(
        '쿠폰',
        isNew ? '쿠폰이 발급되었습니다' : '이미 발급받은 쿠폰입니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[HomeController] 쿠폰 발급 실패: $e');
      Get.snackbar(
        '쿠폰',
        '쿠폰 발급에 실패했습니다. 잠시 후 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 추천 상품 카드 탭 (C1) — 인앱 상품 상세로 이동한다 (원두 상세와 동일 인자 패턴).
  /// 외부 구매(purchaseUrl)는 상세 화면의 "구매하러 가기" CTA 에서 처리한다.
  void onRecommendationTap(CoffeeRecommendationModel item) {
    Get.toNamed(Routes.productDetail, arguments: {'product': item});
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
