import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/dummy/dummy_tasting_data.dart';
import 'package:coflanet/data/models/tasting_note_model.dart';
import 'package:coflanet/modules/tasting/tasting_write_controller.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/cards/screen_scaffold.dart';
import 'package:coflanet/widgets/tags/flavor_tag.dart';

/// 시음 기록 작성 폼.
class TastingWriteView extends GetView<TastingWriteController> {
  const TastingWriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: '시음 기록',
      scrollable: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: AppSpacing.bottomScrollInset(context),
              ),
              child: const Column(
                children: [
                  _BeanNameSection(),
                  SizedBox(height: AppSpacing.cardGap),
                  _RatingSection(),
                  SizedBox(height: AppSpacing.cardGap),
                  _TasteSection(),
                  SizedBox(height: AppSpacing.cardGap),
                  _FlavorSection(),
                  SizedBox(height: AppSpacing.cardGap),
                  _MemoSection(),
                ],
              ),
            ),
          ),
          _SaveBar(),
        ],
      ),
    );
  }
}

/// 원두명 입력.
class _BeanNameSection extends GetView<TastingWriteController> {
  const _BeanNameSection();

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return CardSection(
      title: '원두',
      child: TextField(
        controller: controller.beanNameController,
        onChanged: (v) => controller.beanName.value = v,
        style: AppTextStyles.body1NormalRegular.copyWith(
          color: colors.labelStrong,
        ),
        decoration: InputDecoration(
          hintText: '원두명을 입력하세요',
          hintStyle: AppTextStyles.body1NormalRegular.copyWith(
            color: colors.labelAssistive,
          ),
          filled: true,
          fillColor: colors.surfaceCardStrong,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.inputBorder,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorder,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorder,
            borderSide: BorderSide(color: colors.primaryNormal),
          ),
        ),
      ),
    );
  }
}

/// 별점 입력 (탭 가능한 별 5개).
class _RatingSection extends GetView<TastingWriteController> {
  const _RatingSection();

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: '별점',
      child: Obx(
        () => Row(
          children: [
            for (int i = 1; i <= 5; i++) ...[
              if (i > 1) const SizedBox(width: AppSpacing.xs),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.setRating(i),
                child: Icon(
                  i <= controller.rating.value
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: AppSpacing.space40,
                  color: i <= controller.rating.value
                      ? AppColor.colorGlobalYellow50
                      : AppColorScheme.of(context).labelAssistive,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 맛 5축 슬라이더.
class _TasteSection extends GetView<TastingWriteController> {
  const _TasteSection();

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return CardSection(
      title: '맛 프로필',
      child: Obx(
        () => Column(
          children: [
            for (int i = 0; i < TastingNoteModel.tasteKeys.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              _TasteRow(
                label: TastingNoteModel
                    .tasteLabels[TastingNoteModel.tasteKeys[i]]!,
                value: controller.tasteValues[TastingNoteModel.tasteKeys[i]] ??
                    0.0,
                onChanged: (v) =>
                    controller.setTaste(TastingNoteModel.tasteKeys[i], v),
                colors: colors,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TasteRow extends StatelessWidget {
  const _TasteRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.colors,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.space56,
          child: Text(
            label,
            style: AppTextStyles.label1NormalMedium.copyWith(
              color: colors.labelNormal,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: colors.primaryNormal,
              inactiveTrackColor: colors.lineNormalAlternative,
              thumbColor: colors.primaryNormal,
              overlayColor: colors.primaryNormal.withValues(alpha: 0.12),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 5,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: AppSpacing.space32,
          child: Text(
            value.toStringAsFixed(1),
            textAlign: TextAlign.end,
            style: AppTextStyles.label1NormalBold.copyWith(
              color: colors.primaryNormal,
            ),
          ),
        ),
      ],
    );
  }
}

/// 향미 태그 다중 선택.
class _FlavorSection extends GetView<TastingWriteController> {
  const _FlavorSection();

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: '향미 태그',
      child: Obx(
        () => FlavorTagGroup(
          tags: DummyTastingData.flavorTagCandidates,
          selectedTags: controller.selectedTags,
          onTagTap: controller.toggleTag,
        ),
      ),
    );
  }
}

/// 메모 입력 (멀티라인).
class _MemoSection extends GetView<TastingWriteController> {
  const _MemoSection();

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return CardSection(
      title: '메모',
      child: TextField(
        controller: controller.memoController,
        maxLines: 4,
        style: AppTextStyles.body1NormalRegular.copyWith(
          color: colors.labelStrong,
        ),
        decoration: InputDecoration(
          hintText: '맛, 향, 인상을 자유롭게 기록하세요',
          hintStyle: AppTextStyles.body1NormalRegular.copyWith(
            color: colors.labelAssistive,
          ),
          filled: true,
          fillColor: colors.surfaceCardStrong,
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          border: OutlineInputBorder(
            borderRadius: AppRadius.inputBorder,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorder,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorder,
            borderSide: BorderSide(color: colors.primaryNormal),
          ),
        ),
      ),
    );
  }
}

/// 하단 고정 저장 CTA.
class _SaveBar extends GetView<TastingWriteController> {
  const _SaveBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.headerHorizontalPadding,
        AppSpacing.md,
        AppSpacing.headerHorizontalPadding,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      child: Obx(
        () => PrimaryButton(
          text: '저장',
          isEnabled: controller.canSave,
          onPressed: controller.save,
        ),
      ),
    );
  }
}
