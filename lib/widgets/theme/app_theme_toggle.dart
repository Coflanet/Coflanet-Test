import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/core/theme/theme_controller.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Theme toggle button for switching between light and dark themes.
///
/// Usage:
/// ```dart
/// AppThemeToggle(
///   size: ToggleSize.sm,
/// )
/// ```
enum ToggleSize {
  /// Small: 32x32
  sm,

  /// Medium: 40x40 (default)
  md,

  /// Large: 48x48
  lg,
}

class AppThemeToggle extends StatelessWidget {
  final ToggleSize size;
  final bool showLabel;
  final VoidCallback? onToggle;

  const AppThemeToggle({
    super.key,
    this.size = ToggleSize.md,
    this.showLabel = false,
    this.onToggle,
  });

  double get _toggleSize {
    switch (size) {
      case ToggleSize.sm:
        return 32;
      case ToggleSize.md:
        return 40;
      case ToggleSize.lg:
        return 48;
    }
  }

  double get _iconSize {
    switch (size) {
      case ToggleSize.sm:
        return 16;
      case ToggleSize.md:
        return 20;
      case ToggleSize.lg:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        final isDark = controller.isDarkModeValue;

        Widget toggleButton = Container(
          width: _toggleSize,
          height: _toggleSize,
          decoration: BoxDecoration(
            color: AppColor.componentFillNormal,
            borderRadius: AppRadius.fullBorder,
            border: Border.all(color: AppColor.lineNormalNormal, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle ?? controller.toggleTheme,
              borderRadius: AppRadius.fullBorder,
              child: Padding(
                padding: EdgeInsets.all((_toggleSize - _iconSize) / 2),
                child: Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  size: _iconSize,
                  color: AppColor.labelAlternative,
                ),
              ),
            ),
          ),
        );

        if (showLabel) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              toggleButton,
              SizedBox(width: AppSpacing.xs),
              Text(
                isDark ? '다크 모드' : '라이트 모드',
                style: AppTextStyles.label1NormalMedium.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
            ],
          );
        }

        return toggleButton;
      },
    );
  }
}

/// Theme switch widget for more detailed theme selection.
///
/// Usage:
/// ```dart
/// AppThemeSwitch(
///   onChanged: (theme) => _setTheme(theme),
/// )
/// ```
class AppThemeSwitch extends StatelessWidget {
  final Function(ThemeMode)? onChanged;

  const AppThemeSwitch({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        final currentTheme = controller.isDarkModeValue
            ? ThemeMode.dark
            : ThemeMode.light;

        return Container(
          padding: AppSpacing.cardPaddingAll,
          decoration: BoxDecoration(
            color: AppColor.backgroundElevatedNormal,
            borderRadius: AppRadius.cardBorder,
            border: Border.all(color: AppColor.lineNormalNormal, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                title: '라이트 모드',
                icon: Icons.light_mode,
                themeMode: ThemeMode.light,
                currentTheme: currentTheme,
                onChanged: onChanged,
              ),
              SizedBox(height: AppSpacing.xs),
              _buildThemeOption(
                title: '다크 모드',
                icon: Icons.dark_mode,
                themeMode: ThemeMode.dark,
                currentTheme: currentTheme,
                onChanged: onChanged,
              ),
              SizedBox(height: AppSpacing.xs),
              _buildThemeOption(
                title: '시스템 설정',
                icon: Icons.settings_system_daydream,
                themeMode: ThemeMode.system,
                currentTheme: currentTheme,
                onChanged: onChanged,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeMode currentTheme,
    required Function(ThemeMode)? onChanged,
  }) {
    final isSelected = themeMode == currentTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged?.call(themeMode),
        borderRadius: AppRadius.mdBorder,
        child: Container(
          padding: AppSpacing.listItemPadding,
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryLight : Colors.transparent,
            borderRadius: AppRadius.mdBorder,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.labelAlternative,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body1NormalRegular.copyWith(
                    color: isSelected
                        ? AppColor.primaryNormal
                        : AppColor.labelNormal,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: AppColor.primaryNormal,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
