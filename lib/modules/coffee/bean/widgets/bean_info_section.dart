import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// 원두 정보 섹션 — "원두 정보" 타이틀 + 라벨/값 행 카드.
///
/// nullable 분기(원산지/로스팅/가공/브랜드) 원본 1:1 보존. controller 미참조.
class BeanInfoSection extends StatelessWidget {
  const BeanInfoSection({super.key, required this.bean});

  /// 원두 데이터
  final CoffeeItem bean;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: '원두 정보',
            titleStyle: AppTextStyles.headline2Bold.copyWith(
              color: colors.labelStrong,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: AppRadius.xlBorder,
            ),
            child: Column(
              children: [
                if (bean.origin != null)
                  _buildInfoRow(colors, '원산지', bean.origin!),
                if (bean.roastLevel != null)
                  _buildInfoRow(colors, '로스팅', bean.roastLevel!),
                if (bean.processMethod != null)
                  _buildInfoRow(colors, '가공 방식', bean.processMethod!),
                if (bean.brand != null)
                  _buildInfoRow(colors, '브랜드', bean.brand!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 라벨 + 값 행
  Widget _buildInfoRow(AppColorScheme colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: colors.labelAlternative,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: colors.labelStrong,
            ),
          ),
        ],
      ),
    );
  }
}
