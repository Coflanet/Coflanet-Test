import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/select/widgets/taste_progress_bar.dart';

/// 아코디언형 원두 카드 — 헤더(썸네일/이름/가격) + 펼침 콘텐츠(맛 프로필/향미/액션).
///
/// 펼침 상태와 애니메이션(300ms)은 위젯 내부 State 가 관리한다 (GetX 무관).
/// 모든 상태 변경/네비게이션은 콜백 주입 — controller 인스턴스 미참조.
/// 주의: 호출부 리스트는 원본과 동일하게 key 미전달 (index 기반 State 귀속,
/// viewport 밖 스크롤 시 펼침 초기화는 기존 동작).
class CoffeeAccordionCard extends StatefulWidget {
  const CoffeeAccordionCard({
    super.key,
    required this.item,
    required this.isEditing,
    required this.isSelected,
    required this.initiallyExpanded,
    this.onTap,
    required this.onDetailPressed,
    required this.onRecipePressed,
  });

  /// 원두 데이터
  final CoffeeItem item;

  /// 편집 모드 여부 — 진입 시 자동 collapse
  final bool isEditing;

  /// 선택 강조 보더 여부
  final bool isSelected;

  /// 초기 펼침 여부 (호출부에서 index == 0 판단)
  final bool initiallyExpanded;

  /// 편집 모드 탭 콜백 (일반 모드에서는 펼침 토글이 내부 처리)
  final VoidCallback? onTap;

  /// '원두 상세' 버튼 콜백
  final VoidCallback onDetailPressed;

  /// '레시피 실행' 버튼 콜백
  final VoidCallback onRecipePressed;

  @override
  State<CoffeeAccordionCard> createState() => _CoffeeAccordionCardState();
}

class _CoffeeAccordionCardState extends State<CoffeeAccordionCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    // 편집 모드에서는 접힌 상태로 시작
    _isExpanded = widget.isEditing ? false : widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurns = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: 0.5,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CoffeeAccordionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 편집 모드 진입 시 모든 카드 접기
    if (widget.isEditing && !oldWidget.isEditing && _isExpanded) {
      _isExpanded = false;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isEditing) {
      widget.onTap?.call();
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100, // 항상 흰 카드
          borderRadius: BorderRadius.circular(20),
          border: widget.isSelected
              ? Border.all(color: AppColor.primaryNormal, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColor.colorGlobalCommon0.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더 (항상 표시)
            _buildHeader(),
            // 펼침 콘텐츠
            ClipRect(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Align(
                    heightFactor: _heightFactor.value,
                    alignment: Alignment.topCenter,
                    child: child,
                  );
                },
                child: _buildExpandedContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 헤더 행 — Figma: List/Coffee List/Accordion > List
  /// 편집 모드에서는 체크박스/드래그 핸들이 카드 밖(부모 리스트)에 있음
  Widget _buildHeader() {
    // Figma: 브랜드 텍스트 rgba(55, 56, 60, 0.61)
    final subtitleColor = AppColor.labelAlternative;
    // Figma: 원두 이름 #171719
    const textColor = AppColor.colorGlobalCoolNeutral10;
    final displayImage = widget.item.displayImageUrl;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            // 썸네일 — Figma: 64x64, radius 12. 네이버 이미지 우선
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: displayImage == null
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.item.color.withValues(alpha: 0.3),
                          widget.item.color.withValues(alpha: 0.15),
                        ],
                      )
                    : null,
                color: displayImage != null
                    ? AppColor.colorGlobalCoolNeutral95
                    : null,
                borderRadius: BorderRadius.circular(12),
                image: displayImage != null
                    ? DecorationImage(
                        image: NetworkImage(displayImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: displayImage == null
                  ? Icon(Icons.coffee, color: widget.item.color, size: 32)
                  : null,
            ),
            const SizedBox(width: 16), // Figma: gap 16px
            // 텍스트 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.item.brand != null) ...[
                    Text(
                      widget.item.brand!,
                      style: AppTextStyles.label1NormalMedium.copyWith(
                        color: subtitleColor,
                        letterSpacing: 0.0145,
                      ),
                    ),
                    const SizedBox(height: 6), // Figma: gap 6px
                  ],
                  Text(
                    widget.item.name,
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: textColor,
                      letterSpacing: 0.0096,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // 네이버 쇼핑 가격 표시
                  if (widget.item.naverLprice != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppUtil.changeNumberToWon(widget.item.naverLprice!),
                      style: AppTextStyles.label1NormalMedium.copyWith(
                        color: AppColor.primaryNormal,
                        letterSpacing: 0.0145,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // 펼침 화살표 (일반 모드만 — 편집 모드는 드래그 핸들이 카드 밖)
            if (!widget.isEditing)
              RotationTransition(
                turns: _iconTurns,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.labelNeutral,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 펼침 콘텐츠 — Figma: Contents
  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 커피 프로필 (맛바 + divider + 향미 태그를 한 컨테이너에)
          _buildCoffeeProfileSection(),
          const SizedBox(height: 16),
          // 액션 버튼
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 커피 프로필 — Figma: Coffee Profile
  /// 맛 게이지 5축 + divider + 향미 태그 (회색 컨테이너 radius 24)
  Widget _buildCoffeeProfileSection() {
    final profile = widget.item.flavorProfile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 맛 게이지 (Figma: 5축 × 20px, gap 없음) ──
          TasteProgressBar(label: '산미', value: profile.acidity),
          TasteProgressBar(label: '바디감', value: profile.body),
          TasteProgressBar(label: '단맛', value: profile.sweetness),
          TasteProgressBar(label: '쓴맛', value: profile.bitterness),
          TasteProgressBar(label: '밸런스', value: profile.balance),

          // ── divider + 향미 태그 ──
          if (widget.item.allFlavorTags.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(height: 1, color: AppColor.componentFillNormal),
            const SizedBox(height: 20),
            // 향미 태그 — FlavorTag 와 보더/패딩/radius 가 달라 공통화하지 않음
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: widget.item.allFlavorTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.componentFillNormal,
                    borderRadius: AppRadius.fullBorder,
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.label1NormalMedium.copyWith(
                      color: AppColor.colorGlobalCoolNeutral10,
                      letterSpacing: 0.0145,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// 액션 버튼 — Figma: Button List (40px pill ×2, gap 4)
  Widget _buildActionButtons() {
    return Row(
      children: [
        // 보조 버튼 — 원두 상세 (회색)
        Expanded(
          child: GestureDetector(
            onTap: widget.onDetailPressed,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                // Figma: rgba(112, 115, 124, 0.08)
                color: AppColor.colorGlobalCoolNeutral50.withValues(
                  alpha: 0.08,
                ),
                borderRadius: AppRadius.fullBorder,
              ),
              child: Center(
                child: Text(
                  '원두 상세',
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: AppColor.colorGlobalCoolNeutral10, // #171719
                    letterSpacing: 0.0096,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4), // Figma: gap 4px
        // 주 버튼 — 레시피 실행 (보라)
        Expanded(
          child: GestureDetector(
            onTap: widget.onRecipePressed,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: AppColor.colorGlobalViolet50, // #6541F2
                borderRadius: AppRadius.fullBorder,
              ),
              child: Center(
                child: Text(
                  '레시피 실행',
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: AppColor.colorGlobalCommon100, // #FFFFFF
                    letterSpacing: 0.0096,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
