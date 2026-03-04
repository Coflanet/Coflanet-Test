import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// Equipment item model for the checklist
class EquipmentItem {
  final String id;
  final String name;
  final String? description;
  final bool isRequired;

  const EquipmentItem({
    required this.id,
    required this.name,
    this.description,
    this.isRequired = true,
  });
}

/// Default equipment items for hand drip
class DefaultEquipment {
  static const List<EquipmentItem> handDrip = [
    EquipmentItem(
      id: 'v60_dripper',
      name: 'V60 드리퍼 & 필터',
      description: '하리오 V60 또는 호환 드리퍼',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'server',
      name: '서버 또는 머그컵',
      description: '추출한 커피를 담을 용기',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'scale',
      name: '저울',
      description: '원두와 물의 양을 측정',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'kettle',
      name: '드립 포트 (케틀)',
      description: '세밀한 물줄기 조절용',
      isRequired: false,
    ),
    EquipmentItem(
      id: 'timer',
      name: '타이머',
      description: '추출 시간 측정용',
      isRequired: false,
    ),
  ];

  static const List<EquipmentItem> espresso = [
    EquipmentItem(
      id: 'espresso_machine',
      name: '에스프레소 머신',
      description: '반자동 또는 자동 머신',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'grinder',
      name: '그라인더',
      description: '에스프레소용 미세 분쇄',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'portafilter',
      name: '포터필터',
      description: '커피 바스켓 포함',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'tamper',
      name: '탬퍼',
      description: '커피 압축용',
      isRequired: true,
    ),
    EquipmentItem(
      id: 'scale_espresso',
      name: '저울',
      description: '도징 및 추출량 측정',
      isRequired: false,
    ),
  ];
}

/// Equipment Checklist Widget (준비물 체크리스트)
///
/// Displays a list of equipment items with checkboxes.
/// Used in coffee brewing preparation screens.
class EquipmentChecklist extends StatelessWidget {
  /// List of equipment items to display
  final List<EquipmentItem> items;

  /// Set of checked item IDs
  final Set<String> checkedItems;

  /// Callback when an item is toggled
  final ValueChanged<String>? onItemToggle;

  /// Callback when "변경하기" is tapped
  final VoidCallback? onChangePressed;

  /// Whether to show the change button
  final bool showChangeButton;

  /// Title of the checklist
  final String title;

  /// Whether the checklist is in compact mode
  final bool compact;

  const EquipmentChecklist({
    super.key,
    required this.items,
    required this.checkedItems,
    this.onItemToggle,
    this.onChangePressed,
    this.showChangeButton = true,
    this.title = '준비물',
    this.compact = false,
  });

  /// Factory constructor for hand drip equipment
  factory EquipmentChecklist.handDrip({
    Key? key,
    required Set<String> checkedItems,
    ValueChanged<String>? onItemToggle,
    VoidCallback? onChangePressed,
    bool showChangeButton = true,
    bool compact = false,
  }) {
    return EquipmentChecklist(
      key: key,
      items: DefaultEquipment.handDrip,
      checkedItems: checkedItems,
      onItemToggle: onItemToggle,
      onChangePressed: onChangePressed,
      showChangeButton: showChangeButton,
      title: '핸드드립 준비물',
      compact: compact,
    );
  }

  /// Factory constructor for espresso equipment
  factory EquipmentChecklist.espresso({
    Key? key,
    required Set<String> checkedItems,
    ValueChanged<String>? onItemToggle,
    VoidCallback? onChangePressed,
    bool showChangeButton = true,
    bool compact = false,
  }) {
    return EquipmentChecklist(
      key: key,
      items: DefaultEquipment.espresso,
      checkedItems: checkedItems,
      onItemToggle: onItemToggle,
      onChangePressed: onChangePressed,
      showChangeButton: showChangeButton,
      title: '에스프레소 준비물',
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral15,
        borderRadius: AppRadius.lgBorder,
      ),
      padding: EdgeInsets.all(compact ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: compact ? 12 : 16),
          ...items.map((item) => _buildChecklistItem(item)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              (compact
                      ? AppTextStyles.body1NormalBold
                      : AppTextStyles.headline2Bold)
                  .copyWith(color: AppColor.colorGlobalCommon100),
        ),
        if (showChangeButton)
          GestureDetector(
            onTap: onChangePressed,
            child: Text(
              '변경하기',
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: AppColor.primaryNormal,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChecklistItem(EquipmentItem item) {
    final isChecked = checkedItems.contains(item.id);

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 12),
      child: GestureDetector(
        onTap: onItemToggle != null ? () => onItemToggle!(item.id) : null,
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            _buildCheckbox(isChecked),
            SizedBox(width: compact ? 10 : 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style:
                            (compact
                                    ? AppTextStyles.body2NormalMedium
                                    : AppTextStyles.body1NormalMedium)
                                .copyWith(
                                  color: isChecked
                                      ? AppColor.colorGlobalCommon100
                                      : AppColor.colorGlobalCoolNeutral60,
                                  decoration: isChecked ? null : null,
                                ),
                      ),
                      if (item.isRequired) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primaryNormal.withOpacity(0.15),
                            borderRadius: AppRadius.xsBorder,
                          ),
                          child: Text(
                            '필수',
                            style: AppTextStyles.caption1Regular.copyWith(
                              color: AppColor.primaryNormal,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.description != null && !compact) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColor.colorGlobalCoolNeutral50,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isChecked) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: compact ? 20 : 24,
      height: compact ? 20 : 24,
      decoration: BoxDecoration(
        color: isChecked ? AppColor.primaryNormal : AppColor.transparent,
        borderRadius: BorderRadius.circular(compact ? 5 : 6),
        border: Border.all(
          color: isChecked
              ? AppColor.primaryNormal
              : AppColor.colorGlobalCoolNeutral40,
          width: 2,
        ),
      ),
      child: isChecked
          ? Center(
              child: SvgPicture.asset(
                AssetPath.iconCheck,
                width: compact ? 12 : 14,
                height: compact ? 12 : 14,
                colorFilter: const ColorFilter.mode(
                  AppColor.colorGlobalCommon100,
                  BlendMode.srcIn,
                ),
              ),
            )
          : null,
    );
  }
}

/// Interactive Equipment Checklist with state management
///
/// Stateful wrapper for EquipmentChecklist that manages checked state internally.
class InteractiveEquipmentChecklist extends StatefulWidget {
  /// Initial list of equipment items
  final List<EquipmentItem> items;

  /// Initial checked item IDs
  final Set<String>? initialCheckedItems;

  /// Callback when checked items change
  final ValueChanged<Set<String>>? onCheckedItemsChanged;

  /// Callback when "변경하기" is tapped
  final VoidCallback? onChangePressed;

  /// Whether to show the change button
  final bool showChangeButton;

  /// Title of the checklist
  final String title;

  /// Whether to start with all required items checked
  final bool autoCheckRequired;

  /// Compact mode
  final bool compact;

  const InteractiveEquipmentChecklist({
    super.key,
    required this.items,
    this.initialCheckedItems,
    this.onCheckedItemsChanged,
    this.onChangePressed,
    this.showChangeButton = true,
    this.title = '준비물',
    this.autoCheckRequired = true,
    this.compact = false,
  });

  @override
  State<InteractiveEquipmentChecklist> createState() =>
      _InteractiveEquipmentChecklistState();
}

class _InteractiveEquipmentChecklistState
    extends State<InteractiveEquipmentChecklist> {
  late Set<String> _checkedItems;

  @override
  void initState() {
    super.initState();
    _checkedItems = widget.initialCheckedItems?.toSet() ?? {};

    // Auto-check required items if enabled
    if (widget.autoCheckRequired && _checkedItems.isEmpty) {
      for (final item in widget.items) {
        if (item.isRequired) {
          _checkedItems.add(item.id);
        }
      }
    }
  }

  void _toggleItem(String id) {
    setState(() {
      if (_checkedItems.contains(id)) {
        _checkedItems.remove(id);
      } else {
        _checkedItems.add(id);
      }
    });
    widget.onCheckedItemsChanged?.call(_checkedItems);
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentChecklist(
      items: widget.items,
      checkedItems: _checkedItems,
      onItemToggle: _toggleItem,
      onChangePressed: widget.onChangePressed,
      showChangeButton: widget.showChangeButton,
      title: widget.title,
      compact: widget.compact,
    );
  }
}
