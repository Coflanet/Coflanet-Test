import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';
import '../../foundation/coflanet_icons.dart';

// ═══════════════════════════════════════════════════════════════
// Pagination Counter — Figma `Pagination/Counter`
// ═══════════════════════════════════════════════════════════════

/// Counter 사이즈.
enum AppPaginationCounterSize {
  medium(32),
  small(24);

  const AppPaginationCounterSize(this.value);
  final double value;
}

/// Pagination Counter — 현재 페이지 번호를 도트/숫자로 표시.
///
/// Size: Medium / Small
/// Alternative: True / False (스타일 차이)
class AppPaginationCounter extends StatelessWidget {
  const AppPaginationCounter({
    super.key,
    required this.totalPages,
    required this.currentPage,
    this.size = AppPaginationCounterSize.medium,
    this.alternative = false,
  });

  final int totalPages;
  final int currentPage;
  final AppPaginationCounterSize size;
  final bool alternative;

  @override
  Widget build(BuildContext context) {
    if (alternative) {
      // 숫자 표시: "1 / 5"
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$currentPage',
            style: AppTextStyles.label1NormalBold.copyWith(
              color: AppColor.colorGlobalCoolNeutral10,
            ),
          ),
          Text(
            ' / $totalPages',
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: AppColor.colorGlobalCoolNeutral60,
            ),
          ),
        ],
      );
    }

    // 도트 인디케이터
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (i) {
        final isActive = i == currentPage - 1;
        final dotSize = size == AppPaginationCounterSize.medium ? 8.0 : 6.0;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? dotSize * 2 : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColor.colorGlobalCoolNeutral10
                  : AppColor.colorGlobalCoolNeutral90,
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Pagination Navigation — Figma `Pagination/Navigation`
// ═══════════════════════════════════════════════════════════════

/// Navigation 변형.
enum AppPaginationNavigationVariant {
  /// 전체 표시 (처음/이전/페이지번호들/다음/마지막)
  extended,

  /// 이전/페이지번호/다음
  compact,

  /// 이전/다음만
  minimize,
}

/// Pagination Navigation — 페이지 이동 네비게이션.
///
/// Variant: Extended / Compact / Minimize
class AppPaginationNavigation extends StatelessWidget {
  const AppPaginationNavigation({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChanged,
    this.variant = AppPaginationNavigationVariant.extended,
  });

  final int totalPages;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final AppPaginationNavigationVariant variant;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 처음 (Extended only)
        if (variant == AppPaginationNavigationVariant.extended)
          _NavButton(
            icon: Icons.first_page,
            onTap: currentPage > 1 ? () => onPageChanged(1) : null,
          ),

        // 이전
        _NavButton(
          icon: Icons.chevron_left,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),

        // 페이지 번호 (Extended, Compact)
        if (variant != AppPaginationNavigationVariant.minimize)
          ..._buildPageNumbers(),

        // 다음
        _NavButton(
          icon: Icons.chevron_right,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),

        // 마지막 (Extended only)
        if (variant == AppPaginationNavigationVariant.extended)
          _NavButton(
            icon: Icons.last_page,
            onTap: currentPage < totalPages
                ? () => onPageChanged(totalPages)
                : null,
          ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final pages = <Widget>[];
    final visibleCount = variant == AppPaginationNavigationVariant.extended ? 5 : 3;
    int start = (currentPage - visibleCount ~/ 2).clamp(1, totalPages);
    int end = (start + visibleCount - 1).clamp(1, totalPages);
    if (end - start < visibleCount - 1) {
      start = (end - visibleCount + 1).clamp(1, totalPages);
    }

    for (int i = start; i <= end; i++) {
      pages.add(_PageNumber(
        number: i,
        isActive: i == currentPage,
        onTap: () => onPageChanged(i),
      ));
    }
    return pages;
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: isDisabled
              ? AppColor.colorGlobalCoolNeutral90
              : AppColor.colorGlobalCoolNeutral30,
        ),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({
    required this.number,
    required this.isActive,
    required this.onTap,
  });

  final int number;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? AppColor.colorGlobalCoolNeutral10
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Text(
          '$number',
          style: AppTextStyles.label1NormalBold.copyWith(
            color: isActive
                ? AppColor.colorGlobalCommon100
                : AppColor.colorGlobalCoolNeutral40,
          ),
        ),
      ),
    );
  }
}
