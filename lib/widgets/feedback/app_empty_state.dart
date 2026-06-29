import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';

/// Reusable empty state widget for displaying when content is not available.
///
/// Usage:
/// ```dart
/// AppEmptyState(
///   icon: Icons.coffee_outlined,
///   title: '저장된 커피가 없어요',
///   description: '자주 마시는 커피를 추가해보세요',
///   actionLabel: '커피 추가하기',
///   onAction: () => controller.addNewCoffee(),
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  /// Icon to display at the top
  final IconData icon;

  /// Optional illustration asset shown instead of the icon circle.
  /// null 이면 기존 아이콘 원형을 사용한다.
  final String? imagePath;

  /// Main title text
  final String title;

  /// Optional description text below the title
  final String? description;

  /// Optional action button label
  final String? actionLabel;

  /// Callback when action button is pressed
  final VoidCallback? onAction;

  /// Size of the icon circle (default: 120)
  final double iconCircleSize;

  /// Size of the icon inside the circle (default: 60)
  final double iconSize;

  /// Custom icon color (default: AppColor.primaryNormal)
  final Color? iconColor;

  /// Custom icon circle background color (default: AppColor.primaryLight)
  final Color? iconBackgroundColor;

  /// Width of the action button (default: 200)
  final double actionButtonWidth;

  const AppEmptyState({
    super.key,
    required this.icon,
    this.imagePath,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.iconCircleSize = 120,
    this.iconSize = 60,
    this.iconColor,
    this.iconBackgroundColor,
    this.actionButtonWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconCircle(colors),
            const SizedBox(height: 32),
            _buildTitle(colors),
            if (description != null) ...[
              const SizedBox(height: 12),
              _buildDescription(colors),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 40),
              _buildActionButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(AppColorScheme colors) {
    // 일러스트가 있으면 흰 배경 일러스트를 우선 사용 (로드 실패 시 아이콘 폴백).
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: iconCircleSize,
        height: iconCircleSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildIconCircleFallback(colors),
      );
    }
    return _buildIconCircleFallback(colors);
  }

  Widget _buildIconCircleFallback(AppColorScheme colors) {
    return Container(
      width: iconCircleSize,
      height: iconCircleSize,
      decoration: BoxDecoration(
        color: iconBackgroundColor ?? colors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? colors.primaryNormal,
      ),
    );
  }

  Widget _buildTitle(AppColorScheme colors) {
    return Text(
      title,
      style: AppTextStyles.headline1Bold.copyWith(color: colors.labelNormal),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(AppColorScheme colors) {
    return Text(
      description!,
      style: AppTextStyles.body1NormalRegular.copyWith(
        color: colors.labelAlternative,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton() {
    return PrimaryButton(
      text: actionLabel!,
      onPressed: onAction!,
      width: actionButtonWidth,
    );
  }
}
