import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/brew_log_model.dart';
import 'package:coflanet/modules/extraction/extraction_list_controller.dart';

/// 추출 기록 목록 — 통계 카드 + 무한 스크롤 기록 리스트.
///
/// 이전에는 Scaffold 배경 미지정 + 흰 텍스트 고정이라 배치 위치에 따라
/// 깨졌다. 테마 스킴 기반으로 배경을 명시하고 라벨 토큰을 사용한다.
class ExtractionListView extends GetView<ExtractionListController> {
  const ExtractionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundNormalAlternative,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.primaryNormal),
            );
          }

          if (controller.brewLogs.isEmpty) {
            return _buildEmptyState(colors);
          }

          return RefreshIndicator(
            color: colors.primaryNormal,
            onRefresh: controller.refreshLogs,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter < 200) {
                  controller.loadMore();
                }
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  // Stats card
                  SliverToBoxAdapter(child: _buildStatsCard(colors)),
                  // Brew log list
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= controller.brewLogs.length) {
                          // Loading more indicator
                          return controller.hasMore
                              ? Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: colors.primaryNormal,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        return _buildLogItem(controller.brewLogs[index], colors);
                      },
                      childCount:
                          controller.brewLogs.length +
                          (controller.hasMore ? 1 : 0),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // 보라 그라데이션 — 브랜드 고정색 (테마 무관)
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.colorGlobalViolet80,
                  AppColor.colorGlobalViolet50,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.coffee_rounded,
                size: 40,
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '추출 기록이 없습니다',
            style: AppTextStyles.title2Bold.copyWith(color: colors.labelStrong),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              '타이머를 사용하여 커피를 추출하면\n기록이 자동으로 저장됩니다',
              style: AppTextStyles.caption1Regular.copyWith(
                color: colors.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AppColorScheme colors) {
    return Obx(() {
      final stats = controller.stats;
      if (stats == null) return const SizedBox.shrink();

      final totalBrews = stats['total_brews'] as int? ?? 0;
      final uniqueBeans = stats['unique_beans'] as int? ?? 0;
      final uniqueMethods = stats['unique_methods'] as int? ?? 0;
      final avgRating = stats['avg_rating'] as num?;

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('총 추출', '$totalBrews회', colors),
            _buildStatItem('원두', '$uniqueBeans종', colors),
            _buildStatItem('기구', '$uniqueMethods종', colors),
            _buildStatItem(
              '평균 평점',
              avgRating != null ? avgRating.toStringAsFixed(1) : '-',
              colors,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, AppColorScheme colors) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading2Bold.copyWith(color: colors.labelStrong),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption1Regular.copyWith(
            color: colors.labelAlternative,
          ),
        ),
      ],
    );
  }

  Widget _buildLogItem(BrewLogModel log, AppColorScheme colors) {
    final dateStr = DateFormat('MM.dd (E)', 'ko').format(log.brewedAt);

    return Dismissible(
      key: Key(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colors.statusNegative,
        child: Icon(Icons.delete, color: AppColor.staticLabelWhiteStrong),
      ),
      onDismissed: (_) => controller.deleteLog(log.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Coffee emoji / icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.colorGlobalViolet80.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('☕', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.beanName ?? log.recipeName ?? '커피 추출',
                    style: AppTextStyles.body1NormalMedium.copyWith(
                      color: colors.labelStrong,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      log.brewMethodName ?? log.brewMethodSlug ?? '',
                      dateStr,
                    ].where((s) => s.isNotEmpty).join(' · '),
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ],
              ),
            ),
            // Rating
            if (log.rating != null) ...[
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 별점 노랑 — 의미색 고정
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppColor.colorGlobalYellow50,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${log.rating}',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelStrong,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
