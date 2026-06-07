import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';

/// 원두 상세 헤더 — 이미지/브랜드/이름/설명/네이버 가격/정보 칩.
///
/// 다크 테마 읽기 전용. 모든 nullable 분기(이미지/브랜드/가격/원산지 등)는
/// 원본과 1:1 보존. controller 미참조 — bean 값만 주입.
class BeanDetailHeader extends StatelessWidget {
  const BeanDetailHeader({super.key, required this.bean});

  /// 원두 데이터
  final CoffeeItem bean;

  @override
  Widget build(BuildContext context) {
    final displayImage = bean.displayImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 원두 이미지 (네이버 이미지 우선)
          if (displayImage != null) ...[
            Center(
              child: ClipRRect(
                borderRadius: AppRadius.xlBorder,
                child: Image.network(
                  displayImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColor.colorGlobalCoolNeutral15,
                      borderRadius: AppRadius.xlBorder,
                    ),
                    child: Icon(Icons.coffee, size: 64, color: bean.color),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          // 브랜드
          if (bean.brand != null)
            Text(
              bean.brand!,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
          const SizedBox(height: 4),
          // 이름
          Text(
            bean.name,
            style: AppTextStyles.title1Bold.copyWith(
              color: AppColor.colorGlobalCommon100,
            ),
          ),
          const SizedBox(height: 8),
          // 설명
          Text(
            bean.description,
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
          // 네이버 쇼핑 가격 정보
          if (bean.naverLprice != null) ...[
            const SizedBox(height: 12),
            _buildPriceRow(),
          ],
          // 원산지/로스팅/가공 칩
          if (bean.origin != null || bean.roastLevel != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (bean.origin != null)
                  _buildInfoChip(Icons.place_outlined, bean.origin!),
                if (bean.roastLevel != null)
                  _buildInfoChip(
                    Icons.local_fire_department_outlined,
                    bean.roastLevel!,
                  ),
                if (bean.processMethod != null)
                  _buildInfoChip(
                    Icons.water_drop_outlined,
                    bean.processMethod!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 네이버 쇼핑 가격 정보 행
  Widget _buildPriceRow() {
    final formatter = AppUtil.changeNumberToWon(bean.naverLprice!);
    final mallName = bean.naverMallName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral15,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 18,
            color: AppColor.primaryNormal,
          ),
          const SizedBox(width: 8),
          Text(
            formatter,
            style: AppTextStyles.body1NormalBold.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
          if (bean.naverHprice != null &&
              bean.naverHprice != bean.naverLprice) ...[
            Text(
              ' ~ ${AppUtil.changeNumberToWon(bean.naverHprice!)}',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
          ],
          const Spacer(),
          if (mallName != null)
            Text(
              mallName,
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
        ],
      ),
    );
  }

  /// 원산지/로스팅/가공 정보 칩 (아이콘 + 라벨)
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral15,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColor.colorGlobalCoolNeutral60),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
        ],
      ),
    );
  }
}
