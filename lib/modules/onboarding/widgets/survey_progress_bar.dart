import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

class SurveyProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const SurveyProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$current',
          style: AppTextStyles.label1NormalBold.copyWith(
            color: colors.primaryNormal,
          ),
        ),
        Text(
          ' / $total',
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: colors.labelAssistive,
          ),
        ),
      ],
    );
  }
}

class SurveyProgressIndicator extends StatelessWidget {
  final double progress;

  const SurveyProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    // Figma: 전폭 트랙(#F4F4F5) 위에 채움(#9E86FC=primarySecondary)이 올라가는 구조.
    // 기존엔 트랙 없이 단색 한 줄만 늘어나 시각적으로 달랐음.
    return SizedBox(
      height: 4,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.backgroundNormalAlternative,
                  borderRadius: AppRadius.xsBorder,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                height: 4,
                decoration: BoxDecoration(
                  color: colors.primarySecondary,
                  borderRadius: AppRadius.xxsBorder,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
