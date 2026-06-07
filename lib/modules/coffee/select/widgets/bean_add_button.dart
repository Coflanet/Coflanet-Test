import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';

/// 원두 추가 원형 버튼 — 음각(인셋 그림자) 효과.
///
/// 일반/편집 모드 두 variant 의 그라데이션·그림자·hex 를 각 분기에서 1:1 보존.
/// raw hex 는 디자인 토큰 미매칭으로 named const 로 캡슐화 ([디자인 토큰 부재]).
/// 다크 모드는 어두운 음각이 되도록 coolNeutral22~30 계열 상수 세트를 사용한다.
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

  // [디자인 토큰 부재] Figma 음각 버튼 회색 계열 (라이트) — 토큰화 검토 대상
  static const Color _normalBase = Color(0xFFE8E8E8);
  static const Color _normalEdge = Color(0xFFD8D8D8);
  static const Color _normalBorder = Color(0xFFCCCCCC);
  static const Color _editBase = Color(0xFFEAEAEA);
  static const Color _editCenter = Color(0xFFF0F0F0);
  static const Color _editEdge = Color(0xFFE0E0E0);

  // [디자인 토큰 부재] 다크 음각 버튼 회색 계열 — coolNeutral22~30 근사
  static const Color _darkNormalBase = Color(0xFF2E2F33);
  static const Color _darkNormalEdge = Color(0xFF35363A);
  static const Color _darkNormalBorder = Color(0xFF45464A);
  static const Color _darkEditBase = Color(0xFF303135);
  static const Color _darkEditCenter = Color(0xFF38393D);
  static const Color _darkEditEdge = Color(0xFF2A2B2F);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: isEditing
          ? _buildEditMode(isDark, colors)
          : _buildNormalMode(isDark, colors),
    );
  }

  /// 일반 모드 — 회색 채움 + 인셋 그림자 (음각)
  Widget _buildNormalMode(bool isDark, AppColorScheme colors) {
    final base = isDark ? _darkNormalBase : _normalBase;
    final edge = isDark ? _darkNormalEdge : _normalEdge;
    final border = isDark ? _darkNormalBorder : _normalBorder;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base,
        boxShadow: [
          // 우하단 밝은 그림자 (좌상단 광원 시뮬레이션)
          BoxShadow(
            color: AppColor.colorGlobalCommon100.withValues(
              alpha: isDark ? 0.12 : 0.8,
            ),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
          // 좌상단 어두운 그림자 (깊이/음각)
          BoxShadow(
            color: AppColor.colorGlobalCommon0.withValues(
              alpha: isDark ? 0.4 : 0.15,
            ),
            blurRadius: 4,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // 인셋 효과용 내부 그라데이션
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [base, edge],
            stops: const [0.6, 1.0],
          ),
          border: Border.all(
            color: border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        // 아이콘 — 테마 라벨색 (이전 static 라이트 토큰은 다크에서 안 보임)
        child: Icon(Icons.add, color: colors.labelAlternative, size: 24),
      ),
    );
  }

  /// 편집 모드 — 아웃라인형 음각
  Widget _buildEditMode(bool isDark, AppColorScheme colors) {
    final base = isDark ? _darkEditBase : _editBase;
    final center = isDark ? _darkEditCenter : _editCenter;
    final edge = isDark ? _darkEditEdge : _editEdge;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base,
        boxShadow: [
          // 좌상단 어두운 인셋 그림자
          BoxShadow(
            color: AppColor.colorGlobalCommon0.withValues(
              alpha: isDark ? 0.3 : 0.08,
            ),
            blurRadius: 3,
            offset: const Offset(-1, -1),
            spreadRadius: -1,
          ),
          // 우하단 밝은 대비
          BoxShadow(
            color: AppColor.colorGlobalCommon100.withValues(
              alpha: isDark ? 0.1 : 0.9,
            ),
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
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [center, edge],
            stops: const [0.5, 1.0],
          ),
          border: Border.all(
            color: colors.interactionInactive.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        // 아이콘 — 테마 라벨색 (다크에서도 또렷하게)
        child: Icon(Icons.add, color: colors.labelAlternative, size: 24),
      ),
    );
  }
}
