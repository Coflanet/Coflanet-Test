import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Coffee Profile 속성 1행을 그리는 단위 — Figma `Contents/Coffee Profile/Attributes`.
///
/// `comparedValue` 가 null 이면 단일 트랙(보라), 있으면 듀얼 트랙(보라 위 / 노랑 아래).
class AppCoffeeAttributeBar extends StatelessWidget {
  const AppCoffeeAttributeBar({
    super.key,
    required this.label,
    required this.value,
    this.comparedValue,
    this.maxValue = 5.0,
  });

  /// 속성 이름 (예: 산미, 바디감, 단맛, 쓴맛, 밸런스).
  final String label;

  /// 기준 값 (보라 트랙). 0 ~ [maxValue] 사이.
  final double value;

  /// 비교 값 (노랑 트랙). null 이면 단일 트랙.
  final double? comparedValue;

  /// 만점. 보통 5.0.
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final hasCompare = comparedValue != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Track(
                  ratio: (value / maxValue).clamp(0.0, 1.0),
                  color: AppColor.primaryNormal,
                ),
                if (hasCompare) ...[
                  const SizedBox(height: 4),
                  _Track(
                    ratio: (comparedValue! / maxValue).clamp(0.0, 1.0),
                    color: AppColor.colorGlobalYellow50,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space8),
          SizedBox(
            width: 32,
            child: Text(
              value.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: AppColor.labelNormal,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Track extends StatelessWidget {
  const _Track({required this.ratio, required this.color});

  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius4),
      child: Stack(
        children: [
          Container(height: 8, color: AppColor.lineSolidNeutral),
          FractionallySizedBox(
            widthFactor: ratio,
            child: Container(height: 8, color: color),
          ),
        ],
      ),
    );
  }
}

/// Coffee Profile 속성 차트 — Figma `Contents/Coffee Profile/Attributes`.
///
/// 5축(산미·바디감·단맛·쓴맛·밸런스)을 [AppCoffeeAttributeBar] 로 누적.
/// `compared` 가 비어 있지 않으면 듀얼 트랙(커피 vs 내취향)으로 표시되고
/// 우상단에 범례가 함께 보인다.
class AppCoffeeAttributesChart extends StatelessWidget {
  const AppCoffeeAttributesChart({
    super.key,
    required this.values,
    this.compared,
    this.maxValue = 5.0,
    this.showLegend = true,
  });

  /// 속성 이름→값. 입력 순서대로 위→아래로 그려진다.
  final Map<String, double> values;

  /// 비교 값. 키는 [values] 와 동일해야 한다. null 이면 단일 트랙.
  final Map<String, double>? compared;

  final double maxValue;

  /// 듀얼 트랙일 때 우상단 범례 노출 여부.
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    final hasCompare = compared != null && compared!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasCompare && showLegend) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LegendDot(color: AppColor.primaryNormal, label: '커피'),
                const SizedBox(width: AppSpacing.space12),
                _LegendDot(
                  color: AppColor.colorGlobalYellow50,
                  label: '내취향',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
        ],
        ...values.entries.map(
          (e) => AppCoffeeAttributeBar(
            label: e.key,
            value: e.value,
            comparedValue: hasCompare ? compared![e.key] : null,
            maxValue: maxValue,
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.labelAlternative,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}

/// Flavor Notes 칩 클러스터 — Figma `Contents/Coffee Profile/Flavor Notes`.
///
/// 향미 태그를 가로로 흘려 줄바꿈 한다.
class AppFlavorNotesChips extends StatelessWidget {
  const AppFlavorNotesChips({
    super.key,
    required this.notes,
    this.spacing = AppSpacing.space8,
    this.runSpacing = AppSpacing.space8,
  });

  final List<String> notes;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: notes.map((n) => _FlavorChip(label: n)).toList(),
    );
  }
}

class _FlavorChip extends StatelessWidget {
  const _FlavorChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Text(
        label,
        style: AppTextStyles.label2Regular.copyWith(
          color: AppColor.labelNormal,
        ),
      ),
    );
  }
}

/// Coffee Profile 카드 — Figma `Contents/Coffee Profile/Coffee Profile`.
///
/// 속성 차트 + 향미 칩을 한 카드 안에 묶어 보여준다.
class AppCoffeeProfileCard extends StatelessWidget {
  const AppCoffeeProfileCard({
    super.key,
    required this.values,
    required this.flavorNotes,
    this.compared,
    this.maxValue = 5.0,
  });

  final Map<String, double> values;
  final Map<String, double>? compared;
  final List<String> flavorNotes;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCoffeeAttributesChart(
            values: values,
            compared: compared,
            maxValue: maxValue,
          ),
          const SizedBox(height: AppSpacing.space12),
          AppFlavorNotesChips(notes: flavorNotes),
        ],
      ),
    );
  }
}
