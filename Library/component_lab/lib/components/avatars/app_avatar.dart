import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// Figma Avatar 사이즈.
///
/// 피그마 variant `Size`: XSmall / Small / Medium / Large / XLarge / Custom
enum AppAvatarSize {
  /// 24px
  xSmall(24),

  /// 32px
  small(32),

  /// 40px (default)
  medium(40),

  /// 48px
  large(48),

  /// 56px
  xLarge(56);

  const AppAvatarSize(this.diameter);
  final double diameter;
}

/// Figma Avatar 유형.
///
/// - Person  : 원형, cornerRadius=10000
/// - Company : 둥근 사각형, size별 cornerRadius (XS=6, S=6, M=8, L=10, XL=12)
/// - Academic: 둥근 사각형, Company와 동일 cornerRadius
enum AppAvatarType { person, company, academic }

/// 프로필 아바타 — Figma `Avatar/Person`, `Avatar/Company`, `Avatar/Academic`.
///
/// 피그마 variant:
/// - `Size`   : XSmall(24) / Small(32) / Medium(40) / Large(48) / XLarge(56) / Custom
/// - `Variant`: Icon / Image
///
/// 피그마 boundVariables:
/// - Person fill: `Background/normal/normal`
/// - Company/Academic: 외부 fill 없음 (placeholder가 fill 담당)
/// - Person cornerRadius: 10000 (원형)
/// - Company/Academic cornerRadius: XS=6, S=6, M=8, L=10, XL=12
class AppAvatar extends StatelessWidget {
  /// 이미지 URL. null이면 fallback (initials 또는 아이콘).
  final String? imageUrl;

  /// fallback 텍스트 (이름의 1~2자). null이면 아이콘.
  final String? initials;

  /// 사이즈 프리셋. Custom 사이즈가 필요하면 [customDiameter] 사용.
  final AppAvatarSize size;

  /// Custom 사이즈일 때 직접 지정하는 지름.
  final double? customDiameter;

  /// 아바타 유형 — Person(원형) / Company·Academic(둥근사각).
  final AppAvatarType type;

  /// 탭 핸들러.
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AppAvatarSize.medium,
    this.customDiameter,
    this.type = AppAvatarType.person,
    this.onTap,
  });

  double get _diameter => customDiameter ?? size.diameter;

  /// Person: 원형. Company/Academic: size별 둥근 사각.
  BorderRadius _borderRadius(double d) {
    if (type == AppAvatarType.person) {
      return BorderRadius.circular(d / 2); // 원형
    }
    // Company / Academic — 피그마 size별 cornerRadius
    if (d <= 24) return AppRadius.radius6Border;
    if (d <= 32) return AppRadius.radius6Border;
    if (d <= 40) return AppRadius.radius8Border;
    if (d <= 48) return AppRadius.radius10Border;
    return AppRadius.radius12Border;
  }

  TextStyle _textStyleFor(double diameter) {
    if (diameter <= 24) return AppTextStyles.caption2Bold;
    if (diameter <= 32) return AppTextStyles.caption1Bold;
    if (diameter <= 40) return AppTextStyles.label2Bold;
    if (diameter <= 48) return AppTextStyles.label1NormalBold;
    return AppTextStyles.heading2Bold;
  }

  IconData get _fallbackIcon {
    switch (type) {
      case AppAvatarType.person:
        return Icons.person_rounded;
      case AppAvatarType.company:
        return Icons.business_rounded;
      case AppAvatarType.academic:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final diameter = _diameter;
    final radius = _borderRadius(diameter);

    // 피그마: Person fill = Background/normal/normal
    // Company/Academic: placeholder 자체가 배경
    final bg = isDark
        ? AppColor.darkBackgroundNormalNormal
        : AppColor.backgroundNormalNormal;
    final fg = isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;

    Widget content;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = Image.network(
        imageUrl!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(diameter, bg, fg),
      );
    } else {
      content = _fallback(diameter, bg, fg);
    }

    final body = ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: content,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: body,
        ),
      );
    }
    return body;
  }

  Widget _fallback(double diameter, Color bg, Color fg) {
    return Container(
      width: diameter,
      height: diameter,
      color: bg,
      alignment: Alignment.center,
      child: initials != null && initials!.isNotEmpty
          ? Text(
              initials!.length > 2
                  ? initials!.substring(0, 2).toUpperCase()
                  : initials!.toUpperCase(),
              style: _textStyleFor(diameter).copyWith(color: fg),
            )
          : Icon(
              _fallbackIcon,
              size: diameter * 0.55,
              color: fg,
            ),
    );
  }
}

/// Avatar 위에 뱃지를 배치하는 버튼 — Figma `Avatar Button`.
///
/// 피그마: Badge=True/False, 24px 고정, 원형, fill `Background/normal/normal`.
class AppAvatarButton extends StatelessWidget {
  final String? imageUrl;
  final bool showBadge;
  final Widget? badge;
  final VoidCallback? onTap;

  const AppAvatarButton({
    super.key,
    this.imageUrl,
    this.showBadge = false,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = AppAvatar(
      imageUrl: imageUrl,
      size: AppAvatarSize.xSmall,
      type: AppAvatarType.person,
      onTap: onTap,
    );

    if (!showBadge || badge == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -2,
          top: -2,
          child: badge!,
        ),
      ],
    );
  }
}

/// 겹쳐 보이는 아바타 그룹 — Figma `Avatar Group`.
///
/// 피그마: Size=XSmall/Small, Variant=Person/Company.
class AppAvatarGroup extends StatelessWidget {
  final List<AppAvatar> avatars;

  /// 겹치는 정도 (0이면 안 겹침, 기본 -8).
  final double overlap;

  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.overlap = -8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(avatars.length, (i) {
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : overlap),
          child: avatars[i],
        );
      }),
    );
  }
}
