import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
// [리팩토링 대상] HandDripStep 모델이 controller 파일에 정의되어 있어 부득이 import
// (위젯은 모델 클래스만 사용 — GetX controller 인스턴스 미참조)
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/settings/widgets/value_stepper.dart';

/// 추출 스텝 1개 항목 — 타이틀 + 삭제 + 물의 양 스테퍼 + 시간 스테퍼.
///
/// 모든 상태 변경은 콜백 주입 (controller 미참조). 시간 감소의 최소값
/// (5초 초과) 가드는 호출부 클로저에서 처리한다 (원본 동작 1:1 보존).
///
/// 주의: [step] 값이 매 빌드 달라지므로 호출부에서 const 인스턴스화 금지.
class ExtractionStepTile extends StatelessWidget {
  const ExtractionStepTile({
    super.key,
    required this.step,
    required this.onDelete,
    required this.onWaterIncrement,
    required this.onWaterDecrement,
    required this.onDurationIncrement,
    required this.onDurationDecrement,
  });

  /// 추출 스텝 데이터
  final HandDripStep step;

  /// 스텝 삭제 콜백
  final VoidCallback onDelete;

  /// 물의 양 +10ml
  final VoidCallback onWaterIncrement;

  /// 물의 양 -10ml
  final VoidCallback onWaterDecrement;

  /// 시간 +5초
  final VoidCallback onDurationIncrement;

  /// 시간 -5초 (최소값 가드는 호출부)
  final VoidCallback onDurationDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                step.title,
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.delete_outline,
                size: 20,
                color: colors.labelAlternative,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 물의 양
        Row(
          children: [
            Expanded(
              child: Text(
                '물의 양',
                style: AppTextStyles.label1NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ),
            ValueStepper(
              text: '${step.waterAmount}ml',
              onIncrement: onWaterIncrement,
              onDecrement: onWaterDecrement,
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 시간
        Row(
          children: [
            Row(
              children: [
                Text(
                  '시간',
                  style: AppTextStyles.label1NormalRegular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
                const SizedBox(width: 4),
                Tooltip(
                  message: '물을 붓는 시간과 기다리는 시간을 포함해요.',
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: colors.labelAlternative,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ValueStepper(
              text: formatDuration(step.duration),
              onIncrement: onDurationIncrement,
              onDecrement: onDurationDecrement,
            ),
          ],
        ),
      ],
    );
  }

  /// mm:ss 포맷팅
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
