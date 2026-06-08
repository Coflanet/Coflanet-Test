import 'package:coflanet/data/models/banner_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';

/// Dummy implementation of BannerRepository (CI 테스트 모드)
///
/// 배너는 빈 목록을 반환한다 — UI 가 배너 없음 상태(placeholder)를 렌더한다.
class DummyBannerRepository implements BannerRepository {
  @override
  Future<List<BannerModel>> getActiveBanners() async {
    return const <BannerModel>[];
  }

  @override
  Future<Map<String, dynamic>> claimCoupon(String couponId) async {
    return <String, dynamic>{'is_new': true, 'coupon_name': '쿠폰'};
  }
}
