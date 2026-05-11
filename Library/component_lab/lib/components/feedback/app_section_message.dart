import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Section Message 강조 톤 — Figma `Section Message/Section Message`.
enum AppSectionMessageType {
  /// 중립 — 일반 안내. 배경은 회색 5%
  neutral,

  /// 정보성 안내 — primary 톤
  info,

  /// 긍정/성공 — green 톤
  success,

  /// 경고 — orange 톤
  warning,

  /// 오류 — red 톤
  error,
}

/// Section Message — 화면 내 인라인 안내/경고 박스.
///
/// Figma `Section Message/Section Message` 5 variant.
/// 컨테이너: 라운드 12, 패딩 12, 색상은 type 컬러 5% + 흰색 88% 합성.
class AppSectionMessage extends StatelessWidget {
  const AppSectionMessage({
    super.key,
    required this.title,
    this.description,
    this.type = AppSectionMessageType.neutral,
    this.leadingIcon,
    this.onClose,
    this.actionLabel,
    this.onAction,
    this.bottomActions = const [],
  });

  /// 헤딩 — Body 2 / Normal / Medium (15px).
  final String title;

  /// 보조 설명 — null이면 미표시.
  final String? description;

  /// 톤 — leading icon 기본값과 tint를 결정.
  final AppSectionMessageType type;

  /// 좌측 아이콘. null이면 type별 기본 아이콘 (neutral은 미표시).
  final IconData? leadingIcon;

  /// 우측 close(X) 버튼. null이면 미표시.
  final VoidCallback? onClose;

  /// 우측 trailing 버튼 라벨 — 짧은 액션 (예: '자세히'). null이면 미표시.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// 하단 액션 영역. 보통 1~2개의 짧은 inline 버튼.
  /// `AppSectionMessageBottomAction` 인스턴스를 권장.
  final List<AppSectionMessageBottomAction> bottomActions;

  Color get _tint {
    switch (type) {
      case AppSectionMessageType.neutral:
        return AppColor.labelAssistive;
      case AppSectionMessageType.info:
        return AppColor.primaryNormal;
      case AppSectionMessageType.success:
        return AppColor.statusPositive;
      case AppSectionMessageType.warning:
        return AppColor.statusCautionary;
      case AppSectionMessageType.error:
        return AppColor.statusNegative;
    }
  }

  IconData? get _defaultIcon {
    switch (type) {
      case AppSectionMessageType.neutral:
        return null;
      case AppSectionMessageType.info:
        return Icons.info_rounded;
      case AppSectionMessageType.success:
        return Icons.check_circle_rounded;
      case AppSectionMessageType.warning:
        return Icons.warning_amber_rounded;
      case AppSectionMessageType.error:
        return Icons.error_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = leadingIcon ?? _defaultIcon;
    final tint = _tint;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius12),
      child: Stack(
        children: [
          // 1) 흰색 88% 베이스
          Positioned.fill(
            child: Container(
              color: AppColor.backgroundNormalNormal.withValues(alpha: 0.88),
            ),
          ),
          // 2) tint 5% 오버레이
          Positioned.fill(
            child: Container(color: tint.withValues(alpha: 0.05)),
          ),
          // 3) 콘텐츠
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  SizedBox(
                    width: 20,
                    height: 22,
                    child: Center(
                      child: Icon(icon, size: 20, color: tint),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space8),
                ],
                Expanded(child: _buildMessage(context)),
                if (actionLabel != null) ...[
                  const SizedBox(width: AppSpacing.space8),
                  _TrailingButton(
                    label: actionLabel!,
                    onTap: onAction,
                    color: AppColor.primaryNormal,
                  ),
                ],
                if (onClose != null) ...[
                  const SizedBox(width: AppSpacing.space8),
                  _CloseButton(onTap: onClose!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: AppColor.labelNormal,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: AppColor.labelNeutral,
            ),
          ),
        ],
        if (bottomActions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space12),
          Row(
            children: [
              for (var i = 0; i < bottomActions.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.space16),
                _BottomActionButton(action: bottomActions[i]),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// 하단 액션 버튼 정의.
class AppSectionMessageBottomAction {
  const AppSectionMessageBottomAction({
    required this.label,
    this.onPressed,
    this.emphasized = true,
  });

  final String label;
  final VoidCallback? onPressed;

  /// true면 primary 컬러로 강조, false면 label/alternative 톤.
  final bool emphasized;
}

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton({required this.action});

  final AppSectionMessageBottomAction action;

  @override
  Widget build(BuildContext context) {
    final color = action.emphasized
        ? AppColor.primaryNormal
        : AppColor.labelAlternative;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(AppRadius.radius6),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
          child: Text(
            action.label,
            style: AppTextStyles.label1NormalBold.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

class _TrailingButton extends StatelessWidget {
  const _TrailingButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            label,
            style: AppTextStyles.label1NormalBold.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 22,
          height: 22,
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: AppColor.labelNormal,
          ),
        ),
      ),
    );
  }
}
