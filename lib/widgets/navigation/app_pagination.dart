import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// 페이지네이션 스타일
enum PaginationStyle {
  /// 숫자 버튼
  numbered,

  /// 이전/다음 버튼만
  simple,

  /// 점프 입력 포함
  withJump,

  /// 컴팩트 (현재/전체)
  compact,
}

/// 페이지네이션
///
/// Figma: 🔢 Pagination 페이지
///
/// 목록 페이지네이션에 사용
///
/// Usage:
/// ```dart
/// // 기본 숫자 스타일
/// AppPagination(
///   currentPage: 3,
///   totalPages: 10,
///   onPageChanged: (page) => setState(() => _page = page),
/// )
///
/// // 심플 스타일
/// AppPagination(
///   currentPage: 1,
///   totalPages: 5,
///   style: PaginationStyle.simple,
///   onPageChanged: (page) {},
/// )
///
/// // 컴팩트 스타일
/// AppPagination(
///   currentPage: 3,
///   totalPages: 10,
///   style: PaginationStyle.compact,
///   onPageChanged: (page) {},
/// )
/// ```
class AppPagination extends StatelessWidget {
  /// 현재 페이지 (1부터 시작)
  final int currentPage;

  /// 전체 페이지 수
  final int totalPages;

  /// 페이지 변경 콜백
  final ValueChanged<int> onPageChanged;

  /// 스타일
  final PaginationStyle style;

  /// 표시할 페이지 버튼 수 (numbered 스타일)
  final int visiblePages;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.style = PaginationStyle.numbered,
    this.visiblePages = 5,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case PaginationStyle.numbered:
        return _buildNumberedStyle();
      case PaginationStyle.simple:
        return _buildSimpleStyle();
      case PaginationStyle.withJump:
        return _buildWithJumpStyle();
      case PaginationStyle.compact:
        return _buildCompactStyle();
    }
  }

  Widget _buildNumberedStyle() {
    final effectiveActiveColor = activeColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor = inactiveColor ?? AppColor.labelAssistive;

    // 표시할 페이지 범위 계산
    int startPage = currentPage - (visiblePages ~/ 2);
    int endPage = currentPage + (visiblePages ~/ 2);

    if (startPage < 1) {
      startPage = 1;
      endPage = visiblePages.clamp(1, totalPages);
    }
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = (totalPages - visiblePages + 1).clamp(1, totalPages);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 이전 버튼
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          color: effectiveInactiveColor,
        ),

        SizedBox(width: AppSpacing.space8),

        // 첫 페이지
        if (startPage > 1) ...[
          _PageButton(
            page: 1,
            isActive: false,
            activeColor: effectiveActiveColor,
            inactiveColor: effectiveInactiveColor,
            onTap: () => onPageChanged(1),
          ),
          if (startPage > 2)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.space4),
              child: Text(
                '...',
                style: AppTextStyles.label1NormalRegular.copyWith(
                  color: effectiveInactiveColor,
                ),
              ),
            ),
        ],

        // 페이지 버튼들
        ...List.generate(endPage - startPage + 1, (index) {
          final page = startPage + index;
          return _PageButton(
            page: page,
            isActive: page == currentPage,
            activeColor: effectiveActiveColor,
            inactiveColor: effectiveInactiveColor,
            onTap: () => onPageChanged(page),
          );
        }),

        // 마지막 페이지
        if (endPage < totalPages) ...[
          if (endPage < totalPages - 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.space4),
              child: Text(
                '...',
                style: AppTextStyles.label1NormalRegular.copyWith(
                  color: effectiveInactiveColor,
                ),
              ),
            ),
          _PageButton(
            page: totalPages,
            isActive: false,
            activeColor: effectiveActiveColor,
            inactiveColor: effectiveInactiveColor,
            onTap: () => onPageChanged(totalPages),
          ),
        ],

        SizedBox(width: AppSpacing.space8),

        // 다음 버튼
        _NavButton(
          icon: Icons.chevron_right_rounded,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          color: effectiveInactiveColor,
        ),
      ],
    );
  }

  Widget _buildSimpleStyle() {
    final effectiveInactiveColor = inactiveColor ?? AppColor.labelAssistive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 이전 버튼
        _SimpleNavButton(
          label: '이전',
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          color: effectiveInactiveColor,
        ),

        SizedBox(width: AppSpacing.space16),

        // 페이지 정보
        Text(
          '$currentPage / $totalPages',
          style: AppTextStyles.label1NormalMedium.copyWith(
            color: AppColor.labelNormal,
          ),
        ),

        SizedBox(width: AppSpacing.space16),

        // 다음 버튼
        _SimpleNavButton(
          label: '다음',
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          color: effectiveInactiveColor,
        ),
      ],
    );
  }

  Widget _buildWithJumpStyle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNumberedStyle(),
        SizedBox(width: AppSpacing.space16),
        _JumpInput(totalPages: totalPages, onJump: onPageChanged),
      ],
    );
  }

  Widget _buildCompactStyle() {
    final effectiveActiveColor = activeColor ?? AppColor.primaryNormal;
    final effectiveInactiveColor = inactiveColor ?? AppColor.labelAssistive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          color: effectiveInactiveColor,
        ),
        SizedBox(width: AppSpacing.space12),
        RichText(
          text: TextSpan(
            style: AppTextStyles.label1NormalMedium,
            children: [
              TextSpan(
                text: '$currentPage',
                style: TextStyle(color: effectiveActiveColor),
              ),
              TextSpan(
                text: ' / $totalPages',
                style: TextStyle(color: effectiveInactiveColor),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.space12),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          color: effectiveInactiveColor,
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _PageButton({
    required this.page,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorder,
        child: Container(
          width: 36,
          height: 36,
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.space2),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: AppRadius.mdBorder,
          ),
          child: Center(
            child: Text(
              '$page',
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: isActive
                    ? AppColor.staticLabelWhiteStrong
                    : inactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _NavButton({required this.icon, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorder,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdBorder,
            border: Border.all(color: AppColor.lineNormalNormal),
          ),
          child: Icon(
            icon,
            size: 20,
            color: onTap != null ? color : color.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class _SimpleNavButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const _SimpleNavButton({
    required this.label,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorder,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space12,
            vertical: AppSpacing.space8,
          ),
          child: Text(
            label,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: isEnabled ? color : color.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}

class _JumpInput extends StatefulWidget {
  final int totalPages;
  final ValueChanged<int> onJump;

  const _JumpInput({required this.totalPages, required this.onJump});

  @override
  State<_JumpInput> createState() => _JumpInputState();
}

class _JumpInputState extends State<_JumpInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleJump() {
    final page = int.tryParse(_controller.text);
    if (page != null && page >= 1 && page <= widget.totalPages) {
      widget.onJump(page);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          height: 36,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.label1NormalMedium,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space8,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.mdBorder,
                borderSide: BorderSide(color: AppColor.lineNormalNormal),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.mdBorder,
                borderSide: BorderSide(color: AppColor.lineNormalNormal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.mdBorder,
                borderSide: BorderSide(color: AppColor.primaryNormal),
              ),
            ),
            onSubmitted: (_) => _handleJump(),
          ),
        ),
        SizedBox(width: AppSpacing.space8),
        Text(
          '페이지로',
          style: AppTextStyles.label2Regular.copyWith(
            color: AppColor.labelAssistive,
          ),
        ),
      ],
    );
  }
}
