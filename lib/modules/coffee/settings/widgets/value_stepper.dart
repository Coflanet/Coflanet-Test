import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 증감 스테퍼 컨트롤 (Figma: [+] 값 [−]).
///
/// 장바구니 수량 스테퍼([−]값[+], 보더형)와 버튼 순서/컨테이너/아이콘이 달라
/// 공통 위젯으로 승격하지 않는다. 레시피 폼 전용.
/// [임시] 4단계(espresso_settings 등)에서 동일 패턴 발견 시 lib/widgets/ 승격 후보.
///
/// [text] 는 호출부 Obx 클로저 안에서 평가된 문자열을 받는다 (Rx 미참조).
class ValueStepper extends StatelessWidget {
  const ValueStepper({
    super.key,
    required this.text,
    required this.onIncrement,
    required this.onDecrement,
  });

  /// 표시 값 텍스트 (예: '18g', '92°C', '01:30')
  final String text;

  /// 증가 콜백
  final VoidCallback onIncrement;

  /// 감소 콜백
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.mdBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.add, onIncrement),
          Container(
            height: 32,
            constraints: const BoxConstraints(minWidth: 64),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.backgroundNormalNormal,
              borderRadius: AppRadius.smBorder,
            ),
            child: Text(
              text,
              style: AppTextStyles.body2NormalBold.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
          _buildButton(Icons.remove, onDecrement),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32,
        height: 40,
        child: Icon(icon, size: 18, color: AppColor.labelAlternative),
      ),
    );
  }
}
