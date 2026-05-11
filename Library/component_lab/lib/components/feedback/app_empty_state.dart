import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Empty State — 데이터 없음/검색 결과 없음/권한 없음/오류 등 빈 화면 표현.
///
/// Figma `Empty State/Empty State` — Platform(Desktop/Mobile) × Padding(Normal/Compact)
/// 4 variant. Mobile-Normal을 기본값으로 사용 (Flutter 앱 주 대상).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.illustration,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  /// 타이틀 — Headline 1 / Medium (18px 정도).
  final String title;

  /// 보조 설명. null이면 미표시. 최대 2줄 권장.
  final String? description;

  /// 일러스트 위젯 슬롯. icon보다 우선 사용됨.
  /// 통상 `Image.asset` 또는 `SvgPicture.asset`.
  final Widget? illustration;

  /// 일러스트 미사용 시 표시할 icon. primaryLight 원형 배경 + primaryNormal icon.
  final IconData? icon;

  /// 액션 버튼 라벨 — null이면 미표시.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// true면 상하 패딩을 80→40으로 축소 (compact variant).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final visual = illustration ?? _buildIconBadge();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 335),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: compact ? 40 : 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (visual != null) ...[
                SizedBox(width: 128, height: 128, child: Center(child: visual)),
                const SizedBox(height: AppSpacing.space8),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline1Medium.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.space12),
                      Text(
                        description!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body2NormalRegular.copyWith(
                          color: AppColor.labelAlternative,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: AppSpacing.space24),
                _OutlinedAction(
                  label: actionLabel!,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildIconBadge() {
    if (icon == null) return null;
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 36, color: AppColor.primaryNormal),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radius10),
        side: BorderSide(color: AppColor.lineNormalNeutral, width: 1),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.radius10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space20, vertical: 9),
          child: Text(
            label,
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
        ),
      ),
    );
  }
}
