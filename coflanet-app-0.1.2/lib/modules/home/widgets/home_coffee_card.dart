import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';

/// Coffee Card for Home screen subscribe section
/// Figma: Coffee Card component - 104px height, radius 24px
class HomeCoffeeCard extends StatelessWidget {
  final CoffeeItem item;
  final VoidCallback? onTap;

  const HomeCoffeeCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Thumbnail area: w:84, p:4, image radius:20
            SizedBox(
              width: 84,
              height: 104,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: AppColor.componentFillNormal,
                    child: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Center(
                            child: Icon(
                              Icons.coffee,
                              color: item.color,
                              size: 32,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            // Contents area: flex:1, px:16, pt:18, pb:20
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand + badge row, gap:6
                    Row(
                      children: [
                        // Brand name
                        Text(
                          item.brand ?? '브랜드명',
                          style: AppTextStyles.label2Regular.copyWith(
                            color: AppColor.labelAlternative,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 6),
                        // "구독중" badge
                        _buildBadge('구독중'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Coffee name - max 2 lines
                    Text(
                      item.name,
                      style: AppTextStyles.label1NormalMedium.copyWith(
                        color: AppColor.labelNormal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Content Badge: Figma - Caption 2/Medium, primary color, bg: primary 8% opacity, radius:6
  Widget _buildBadge(String text) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColor.primaryNormal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppTextStyles.caption2Medium.copyWith(
          color: AppColor.primaryNormal,
        ),
      ),
    );
  }
}
