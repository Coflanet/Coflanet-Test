import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/banner_model.dart';

/// 홈 프로모 배너 — 서버 배너(home_promo 슬롯) 기반.
///
/// 배너 데이터가 있을 때만 호출부에서 렌더한다 (목데이터 없음).
/// 배경색은 서버 `bg_color`(hex) 를 따르고, 없으면 핑크 토큰으로 fallback.
/// 배너가 고정 비비드 색이므로 텍스트는 테마 무관 static 흰색 토큰을 쓴다.
class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key, required this.banner, this.onTap});

  /// 프로모 슬롯 배너 데이터
  final BannerModel banner;

  /// 배너 탭 콜백 (action_type 분기는 호출부 담당)
  final VoidCallback? onTap;

  /// 서버 hex 문자열 → Color (런타임 데이터 파싱 — 하드코딩 색상 아님)
  Color get _backgroundColor {
    final hex = banner.bgColor?.replaceFirst('#', '');
    if (hex != null && hex.length == 6) {
      final value = int.tryParse('FF$hex', radix: 16);
      if (value != null) return Color(value);
    }
    return AppColor.colorGlobalPink50;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: banner.title,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: AppRadius.xxlBorder,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.title,
                      style: AppTextStyles.body1NormalBold.copyWith(
                        color: AppColor.colorGlobalCommon100,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (banner.subtitle != null &&
                        banner.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        banner.subtitle!,
                        style: AppTextStyles.caption1Medium.copyWith(
                          color: AppColor.colorGlobalCommon100.withValues(
                            alpha: 0.9,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 우측 이미지 — 서버 이미지 없으면 흰 박스 + 커피 아이콘
              Container(
                width: 64,
                height: 64,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCommon100,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  image: banner.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(banner.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: banner.imageUrl == null
                    ? Icon(
                        Icons.coffee,
                        color: AppColor.primaryNormal,
                        size: 32,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
