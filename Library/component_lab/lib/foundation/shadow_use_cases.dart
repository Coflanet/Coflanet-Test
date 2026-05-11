import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'app_color.dart';
import 'app_radius.dart';
import 'app_shadow.dart';

/// Shadow use_cases — Primary(Violet) / Black 각 5단계 강도.
final List<WidgetbookComponent> shadowUseCases = [
  WidgetbookComponent(
    name: 'Black Shadow',
    useCases: [
      WidgetbookUseCase(
        name: '5단계 강도 + Bottom + Floating',
        builder: (context) => _grid(context, [
          ('shadowBlackNormal', AppShadows.shadowBlackNormal,
              '가벼운 카드'),
          ('shadowBlackEmphasize', AppShadows.shadowBlackEmphasize,
              '강조 카드'),
          ('shadowBlackStrong', AppShadows.shadowBlackStrong,
              '모달, 팝오버'),
          ('shadowBlackHeavy', AppShadows.shadowBlackHeavy,
              '큰 모달, FAB'),
          ('shadowBlackHeavyBottom', AppShadows.shadowBlackHeavyBottom,
              'Bottom Sheet (위쪽 그림자)'),
          ('shadowBlackFloating', AppShadows.shadowBlackFloating,
              '다이얼로그, 핵심 액션'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Primary Shadow',
    useCases: [
      WidgetbookUseCase(
        name: 'Violet 색조 그림자 (브랜드 강조)',
        builder: (context) => _grid(context, [
          ('shadowPrimaryNormal',
              AppShadows.shadowPrimaryNormal, '단일 그림자'),
          ('shadowPrimaryNormalList',
              AppShadows.shadowPrimaryNormalList, '여러 그림자 합성'),
          ('shadowPrimaryEmphasize',
              AppShadows.shadowPrimaryEmphasize, '강조 카드'),
          ('shadowPrimaryStrong',
              AppShadows.shadowPrimaryStrong, '모달, 팝오버'),
          ('shadowPrimaryHeavy', AppShadows.shadowPrimaryHeavy,
              '큰 모달, FAB'),
          ('shadowPrimaryHeavyBottom',
              AppShadows.shadowPrimaryHeavyBottom,
              'Bottom Sheet (위쪽 그림자)'),
          ('shadowPrimaryFloating',
              AppShadows.shadowPrimaryFloating,
              '다이얼로그, 핵심 액션'),
        ]),
      ),
    ],
  ),
];

Widget _grid(
  BuildContext context,
  List<(String, List<BoxShadow>, String)> items,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final boxColor = isDark
      ? AppColor.darkBackgroundElevatedNormal
      : AppColor.backgroundElevatedNormal;
  final labelColor =
      isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
  final altColor = isDark
      ? AppColor.darkLabelAlternative
      : AppColor.labelAlternative;
  final pageBg = isDark
      ? AppColor.darkBackgroundNormalNormal
      : AppColor.backgroundNormalNormal;

  return Container(
    color: pageBg,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 32,
        runSpacing: 40,
        children: items.map((it) {
          return SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 120,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: AppRadius.radius16Border,
                    boxShadow: it.$2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  it.$1,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  it.$3,
                  style: TextStyle(color: altColor, fontSize: 11),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ),
  );
}
