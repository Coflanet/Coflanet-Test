import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'app_color.dart';
import 'app_spacing.dart';

/// Spacing 토큰 카탈로그 항목.
class _S {
  final String name;
  final double value;
  final String? description;

  const _S(this.name, this.value, [this.description]);
}

/// Spacing use_cases — Palette 16단계 + Semantic 의미 토큰 + Safe Area.
final List<WidgetbookComponent> spacingUseCases = [
  WidgetbookComponent(
    name: 'Palette',
    useCases: [
      WidgetbookUseCase(
        name: '원시 값 16단계 (Figma Spacing 토큰 + Phase 1-C 신규)',
        builder: (context) => _bars(context, const [
          _S('space0', AppSpacing.space0, 'zero padding (Phase 1-C 신규)'),
          _S('space4', AppSpacing.space4),
          _S('space8', AppSpacing.space8),
          _S('space12', AppSpacing.space12),
          _S('space14', AppSpacing.space14),
          _S('space16', AppSpacing.space16),
          _S('space20', AppSpacing.space20),
          _S('space24', AppSpacing.space24),
          _S('space28', AppSpacing.space28, 'button bottom / GNB logo (Phase 1-C 신규)'),
          _S('space32', AppSpacing.space32),
          _S('space34', AppSpacing.space34),
          _S('space36', AppSpacing.space36),
          _S('space40', AppSpacing.space40),
          _S('space44', AppSpacing.space44),
          _S('space48', AppSpacing.space48),
          _S('space56', AppSpacing.space56, 'banner (Phase 1-C 신규)'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Container & Box Padding',
    useCases: [
      WidgetbookUseCase(
        name: '의미 토큰 — Container/Box 관련 패딩',
        builder: (context) => _bars(context, const [
          _S('containerVerticalPadding', AppSpacing.containerVerticalPadding,
              'Container 기본 상하 패딩'),
          _S('containerHorizontalPadding',
              AppSpacing.containerHorizontalPadding, 'Box 안 좌우 패딩'),
          _S('inBoxTopPadding', AppSpacing.inBoxTopPadding, 'Box 내부 위쪽 패딩'),
          _S('bottomAfterBox', AppSpacing.bottomAfterBox,
              '박스로 컨텐츠 끝날 때 하단 (좌우와 동일)'),
          _S('bottomAfterText', AppSpacing.bottomAfterText,
              '텍스트로 컨텐츠 끝날 때 하단'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Element Gap',
    useCases: [
      WidgetbookUseCase(
        name: '의미 토큰 — 요소 간 간격',
        builder: (context) => _bars(context, const [
          _S('itemSpacing', AppSpacing.itemSpacing, '목록 아이템 간격'),
          _S('textContentsSpacing', AppSpacing.textContentsSpacing,
              '텍스트 컨텐츠 사이'),
          _S('textToBoxSpacing', AppSpacing.textToBoxSpacing,
              '텍스트와 박스 사이'),
          _S('betweenBoxesSpacing', AppSpacing.betweenBoxesSpacing,
              '박스와 박스 사이'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Padding Category',
    useCases: [
      WidgetbookUseCase(
        name: 'Figma Spacing.Padding.* 매핑',
        builder: (context) => _bars(context, const [
          _S('paddingContentsInBox', AppSpacing.paddingContentsInBox,
              'Contents in Box (24)'),
          _S('paddingBoxInBox', AppSpacing.paddingBoxInBox, 'Box in Box (16)'),
          _S('paddingContentsInBoxSmall',
              AppSpacing.paddingContentsInBoxSmall,
              'Contents in Box small (8) — 16+8=24 합성용'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Button',
    useCases: [
      WidgetbookUseCase(
        name: 'Figma Spacing.Button.*',
        builder: (context) => _bars(context, const [
          _S('buttonPaddingHorizontal', AppSpacing.buttonPaddingHorizontal,
              'Button 좌우 (8)'),
          _S('buttonPaddingVertical', AppSpacing.buttonPaddingVertical,
              'Button 상하 (12)'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Safe Area',
    useCases: [
      WidgetbookUseCase(
        name: '플랫폼별 기준값 (실제 앱은 SafeArea 위젯 권장)',
        builder: (context) => _bars(context, const [
          _S('safeAreaStatusIos', AppSpacing.safeAreaStatusIos,
              'iOS Status Bar (44)'),
          _S('safeAreaStatusAndroid', AppSpacing.safeAreaStatusAndroid,
              'Android Status Bar (36)'),
          _S('safeAreaStatusWeb', AppSpacing.safeAreaStatusWeb, 'Web (0)'),
          _S('safeAreaBottomIos', AppSpacing.safeAreaBottomIos,
              'iOS Home Indicator (34)'),
          _S('safeAreaBottomAndroid', AppSpacing.safeAreaBottomAndroid,
              'Android Gesture (14)'),
          _S('safeAreaBottomWeb', AppSpacing.safeAreaBottomWeb, 'Web (0)'),
        ]),
      ),
    ],
  ),
];

/// Spacing 토큰을 막대 그래프로 시각화.
Widget _bars(BuildContext context, List<_S> items) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final labelColor = isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
  final altColor =
      isDark ? AppColor.darkLabelAlternative : AppColor.labelAlternative;
  final barColor = isDark ? AppColor.darkPrimaryNormal : AppColor.primaryNormal;
  final trackColor = isDark
      ? AppColor.darkComponentFillNormal
      : AppColor.componentFillNormal;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((it) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.darkBackgroundElevatedNormal
                : AppColor.backgroundElevatedNormal,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? AppColor.darkLineSolidNormal
                  : AppColor.lineSolidNormal,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      it.name,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${it.value.toStringAsFixed(0)}px',
                    style: TextStyle(
                      color: altColor,
                      fontSize: 13,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              if (it.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  it.description!,
                  style: TextStyle(color: altColor, fontSize: 12),
                ),
              ],
              const SizedBox(height: 8),
              // 막대 시각화 (1px 토큰 = 4px 픽셀)
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: trackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: it.value * 4,
                    height: 8,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
