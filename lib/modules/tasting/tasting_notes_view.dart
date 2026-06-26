import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/tasting_note_model.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/cards/screen_scaffold.dart';
import 'package:coflanet/widgets/tags/flavor_tag.dart';

/// 커피 저널 — 저장된 시음 노트 카드 리스트.
class TastingNotesView extends GetView<TastingNotesController> {
  const TastingNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    // 카드 밖(헤더/캔버스 위 액션)은 항상 다크 스킴.
    final canvas = AppColorScheme.canvas;

    return ScreenScaffold(
      title: '커피 저널',
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goToWrite,
        child: Icon(Icons.add, color: canvas.labelNormal, size: AppSpacing.xl),
      ),
      child: Obx(() {
        if (controller.notes.isEmpty) {
          return _EmptyState(onWrite: _goToWrite);
        }
        return Column(
          children: [
            for (int i = 0; i < controller.notes.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.cardGap),
              _NoteCard(
                note: controller.notes[i],
                onDelete: () => controller.deleteNote(controller.notes[i].id),
              ),
            ],
          ],
        );
      }),
    );
  }

  void _goToWrite() => Get.toNamed(Routes.tastingWrite);
}

/// 빈 상태 — 안내 + 첫 기록 CTA.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onWrite});

  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return CardSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSpacing.space80,
              height: AppSpacing.space80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryLight,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: AppSpacing.space40,
                color: colors.primaryNormal,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '아직 시음 기록이 없어요',
            style: AppTextStyles.headline2Bold.copyWith(
              color: colors.labelStrong,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '커피의 맛과 향을 기록하고\n나만의 시음 노트를 쌓아보세요',
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: colors.labelAlternative,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _WriteButton(label: '첫 시음 기록하기', onTap: onWrite),
        ],
      ),
    );
  }
}

/// 시음 노트 단일 카드 — 원두명/날짜/별점/향미칩 미리보기.
class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.onDelete});

  final TastingNoteModel note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final dateStr = DateFormat('yyyy.MM.dd', 'ko').format(note.date);

    return CardSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.beanName,
                      style: AppTextStyles.headline2Bold.copyWith(
                        color: colors.labelStrong,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      dateStr,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: colors.labelAlternative,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDelete,
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: AppSpacing.xl,
                  color: colors.labelAssistive,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _StarRow(rating: note.rating),
          if (note.flavorTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            FlavorTagGroup(
              tags: note.flavorTags,
              style: FlavorTagStyle.compact,
            ),
          ],
          if (note.memo.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              note.memo,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelNeutral,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// 별점 표시 (읽기 전용).
class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++) ...[
          if (i > 1) const SizedBox(width: AppSpacing.space2),
          Icon(
            i <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: AppSpacing.lg,
            // 별점 노랑 — 의미색 고정.
            color: i <= rating
                ? AppColor.colorGlobalYellow50
                : AppColorScheme.of(context).labelAssistive,
          ),
        ],
      ],
    );
  }
}

/// 카드 안 보조 CTA 버튼 (틴트).
class _WriteButton extends StatelessWidget {
  const _WriteButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.primaryNormal,
          borderRadius: AppRadius.fullBorder,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_outlined,
              size: AppSpacing.lg,
              color: AppColor.staticLabelWhiteStrong,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.body1NormalBold.copyWith(
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
