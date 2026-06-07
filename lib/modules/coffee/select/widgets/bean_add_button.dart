import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';

/// 원두 추가 원형 버튼 — 음각(인셋 그림자) 효과.
///
/// 일반/편집 모드 두 variant 의 그라데이션·그림자·hex 를 각 분기에서 1:1 보존.
/// raw hex 는 디자인 토큰 미매칭으로 named const 로 캡슐화 ([디자인 토큰 부재]).
class BeanAddButton extends StatelessWidget {
  const BeanAddButton({
    super.key,
    required this.isEditing,
    required this.onTap,
  });

  /// 편집 모드 여부 (아웃라인형 음각 variant)
  final bool isEditing;

  /// 탭 콜백
  final VoidCallback onTap;

  // [디자인 토큰 부재] Figma 음각 버튼 회색 계열 — 토큰화 검토 대상
  static const Color _normalBase = Color(0xFFE8E8E8);
  static const Color _normalEdge = Color(0xFFD8D8D8);
  static const Color _normalBorder = Color(0xFFCCCCCC);
  static const Color _editBase = Color(0xFFEAEAEA);
  static const Color _editCenter = Color(0xFFF0F0F0);
  static const Color _editEdge = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isEditing ? _buildEditMode() : _buildNormalMode(),
    );
  }

  /// 일반 모드 — 회색 채움 + 인셋 그림자 (음각)
  Widget _buildNormalMode() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _normalBase,
        boxShadow: [
          // 우하단 밝은 그림자 (좌상단 광원 시뮬레이션)
          BoxShadow(
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.8),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
          // 좌상단 어두운 그림자 (깊이/음각)
          BoxShadow(
            color: AppColor.colorGlobalCommon0.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // 인셋 효과용 내부 그라데이션
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [_normalBase, _normalEdge],
            stops: [0.6, 1.0],
          ),
          border: Border.all(
            color: _normalBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(Icons.add, color: AppColor.labelAlternative, size: 24),
      ),
    );
  }

  /// 편집 모드 — 아웃라인형 음각
  Widget _buildEditMode() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _editBase,
        boxShadow: [
          // 좌상단 어두운 인셋 그림자
          BoxShadow(
            color: AppColor.colorGlobalCommon0.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(-1, -1),
            spreadRadius: -1,
          ),
          // 우하단 밝은 대비
          BoxShadow(
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.9),
            blurRadius: 3,
            offset: const Offset(1, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [_editCenter, _editEdge],
            stops: [0.5, 1.0],
          ),
          border: Border.all(
            color: AppColor.colorGlobalCoolNeutral50.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColor.colorGlobalCoolNeutral50,
          size: 24,
        ),
      ),
    );
  }
}
