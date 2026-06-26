import 'package:coflanet/data/models/banner_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';

/// Dummy implementation of BannerRepository (CI 테스트 모드)
///
/// 실제 빌드(더미 모드)에서도 홈이 Figma 처럼 꽉 차 보이도록 캐러셀/프로모
/// 배너 샘플을 제공한다. 이미지 자산이 없으므로 [BannerModel.bgColor] 만 채워
/// 카드(HomeCarousel/HomePromoBanner)가 그라데이션/단색 배너 + 카피로 렌더한다.
class DummyBannerRepository implements BannerRepository {
  @override
  Future<List<BannerModel>> getActiveBanners() async {
    return const <BannerModel>[
      // ── 캐러셀 슬롯 (home_carousel) — 색 배너 + 카피 ──
      BannerModel(
        id: 'carousel_1',
        slot: BannerSlot.homeCarousel,
        title: '이번 주 핸드드립 원두\n20% 할인 받아보기',
        bgColor: '#6541F2',
        actionType: BannerActionType.none,
        priority: 30,
      ),
      BannerModel(
        id: 'carousel_2',
        slot: BannerSlot.homeCarousel,
        title: '당신의 취향을 담은\n구독 원두를 만나보세요',
        bgColor: '#3A2A1E',
        actionType: BannerActionType.none,
        priority: 20,
      ),
      BannerModel(
        id: 'carousel_3',
        slot: BannerSlot.homeCarousel,
        title: '신선하게 로스팅한\n스페셜티 원두 입고',
        bgColor: '#1E3A2E',
        actionType: BannerActionType.none,
        priority: 10,
      ),
      // ── 프로모 슬롯 (home_promo) — 핑크 쿠폰 배너 ──
      BannerModel(
        id: 'promo_1',
        slot: BannerSlot.homePromo,
        title: '추천 원두 당일 구매 시 10% 할인',
        subtitle: '10% 할인 쿠폰 발급 받기',
        bgColor: '#F553DA',
        actionType: BannerActionType.claimCoupon,
        actionPayload: {'coupon_id': 'dummy_coupon_10'},
        priority: 10,
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> claimCoupon(String couponId) async {
    return <String, dynamic>{'is_new': true, 'coupon_name': '10% 할인 쿠폰'};
  }
}
