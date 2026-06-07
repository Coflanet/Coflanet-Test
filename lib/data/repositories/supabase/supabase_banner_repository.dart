import 'package:coflanet/data/models/banner_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/supabase/supabase_repository_base.dart';

/// Supabase implementation of BannerRepository
///
/// 홈 배너 조회(get_active_banners)와 쿠폰 발급(claim_coupon)을 RPC로 처리한다.
/// 예외는 잡지 않고 전파한다 — 호출자(HomeController)가 배너 실패를
/// 비치명으로 처리(홈 로딩 계속)할지 결정한다.
class SupabaseBannerRepository extends SupabaseRepositoryBase
    implements BannerRepository {
  @override
  Future<List<BannerModel>> getActiveBanners() async {
    final result = await guard(() => db.rpc('get_active_banners'));
    if (result is List) {
      return result
          .whereType<Map<String, dynamic>>()
          .map(BannerModel.fromJson)
          .whereType<BannerModel>()
          .toList();
    }
    return <BannerModel>[];
  }

  @override
  Future<Map<String, dynamic>> claimCoupon(String couponId) async {
    final result = await guard(
      () => db.rpc('claim_coupon', params: {'p_coupon_id': couponId}),
    );
    if (result is Map<String, dynamic>) return result;
    return <String, dynamic>{};
  }
}
