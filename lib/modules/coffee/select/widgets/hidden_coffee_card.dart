import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';

/// 숨겨진 원두 카드 — 흐린 썸네일 + 복원/삭제 버튼.
///
/// controller 미참조 — 값/콜백 주입.
class HiddenCoffeeCard extends StatelessWidget {
  const HiddenCoffeeCard({
    super.key,
    required this.item,
    required this.onRestore,
    required this.onDelete,
  });

  /// 원두 데이터
  final CoffeeItem item;

  /// 복원 콜백
  final VoidCallback onRestore;

  /// 삭제 콜백
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal.withValues(alpha: 0.5),
          borderRadius: AppRadius.lgBorder,
        ),
        child: Row(
          children: [
            // 흐린 커피 썸네일
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.backgroundNormalAlternative,
                borderRadius: AppRadius.mdBorder,
              ),
              child: Center(
                child: Icon(
                  Icons.coffee,
                  color: item.color.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 커피 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.brand != null)
                    Text(
                      item.brand!,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: colors.labelAssistive,
                      ),
                    ),
                  Text(
                    item.name,
                    style: AppTextStyles.body2NormalMedium.copyWith(
                      color: colors.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 복원 버튼
            GestureDetector(
              onTap: onRestore,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryNormal.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smBorder,
                ),
                child: Text(
                  '복원',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: colors.primaryNormal,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 삭제 버튼
            GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.close, color: colors.labelAssistive, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
