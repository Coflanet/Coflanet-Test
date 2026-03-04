import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$current',
          style: AppTextStyles.label1NormalBold.copyWith(
            color: AppColor.primaryNormal,
          ),
        ),
        Text(
          ' / $total',
          style: AppTextStyles.label1NormalRegular.copyWith(
            color: AppColor.labelAssistive,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: constraints.maxWidth * progress.clamp(0.0, 1.0),
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.primaryNormal,
              borderRadius: AppRadius.xxsBorder,
            ),
          ),
        );
      },
    );
  }
}
