import 'package:flutter/material.dart';

import '../foundation/app_spacing.dart';

/// 카탈로그 use_case에서 공통으로 쓰는 컬러 카드 위젯.
class Swatch extends StatelessWidget {
  final String name;
  final Color color;
  final String? note;

  const Swatch({super.key, required this.name, required this.color, this.note});

  String _toHex(Color c) {
    final argb = c.toARGB32();
    final hex = argb.toRadixString(16).padLeft(8, '0').toUpperCase();
    if (hex.startsWith('FF')) return '#${hex.substring(2)}';
    return '#$hex';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      padding: const EdgeInsets.all(AppSpacing.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            _toHex(color),
            style: TextStyle(
              color: textColor.withValues(alpha: 0.85),
              fontSize: 11,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: 2),
            Text(
              note!,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 색상 그리드 — use_case 빌더에서 바로 호출.
Widget swatchGrid(List<(String, Color)> items, {int crossAxisCount = 4}) {
  return Padding(
    padding: const EdgeInsets.all(AppSpacing.space16),
    child: GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items
          .map((it) => Swatch(name: it.$1, color: it.$2))
          .toList(),
    ),
  );
}
