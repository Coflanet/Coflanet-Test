import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/catalog_bean_model.dart';
import 'package:coflanet/modules/search/search_controller.dart';
import 'package:coflanet/widgets/feedback/app_empty_state.dart';
import 'package:coflanet/widgets/forms/app_text_field.dart';

/// 원두 검색 화면 — 상단 검색 입력 + 결과 목록
class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors),
            Expanded(child: _buildBody(colors)),
          ],
        ),
      ),
    );
  }

  // ===== 헤더 (뒤로가기 + 검색 입력) =====
  Widget _buildHeader(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          Semantics(
            label: '뒤로가기',
            button: true,
            child: IconButton(
              onPressed: Get.back,
              icon: Icon(Icons.arrow_back, color: colors.labelNormal),
            ),
          ),
          Expanded(child: _buildSearchField()),
        ],
      ),
    );
  }

  /// 앱 공통 검색 인풋(AppSearchField) 사용 — 다른 화면과 동일한 스타일.
  /// 세로 중앙 정렬, 일관된 아이콘/텍스트 색, 박스 전체 포커스 테두리, 지우기 버튼 내장.
  Widget _buildSearchField() {
    return AppSearchField(
      hintText: '원두 이름으로 검색',
      autofocus: true,
      onChanged: controller.onQueryChanged,
    );
  }

  // ===== 본문 (상태별 분기) =====
  Widget _buildBody(AppColorScheme colors) {
    return Obx(() {
      if (controller.isSearching) {
        return Center(
          child: CircularProgressIndicator(color: colors.primaryNormal),
        );
      }
      if (!controller.hasSearched) {
        return _buildHint(colors);
      }
      if (controller.results.isEmpty) {
        return const AppEmptyState(
          icon: Icons.search_off,
          title: '검색 결과가 없어요',
          description: '다른 검색어로 다시 시도해보세요',
        );
      }
      return _buildResultList(colors);
    });
  }

  /// 검색 전 초기 안내
  Widget _buildHint(AppColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.coffee_outlined, size: 48, color: colors.labelAssistive),
            const SizedBox(height: 16),
            Text(
              '찾고 싶은 원두를 검색해보세요',
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: colors.labelAlternative,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultList(AppColorScheme colors) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.results.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: colors.lineSolidNormal),
      itemBuilder: (context, index) =>
          _buildResultTile(colors, controller.results[index]),
    );
  }

  Widget _buildResultTile(AppColorScheme colors, CatalogBean bean) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 썸네일
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.surfaceCardStrong,
              borderRadius: BorderRadius.circular(8),
              image: bean.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(bean.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: bean.imageUrl == null
                ? Icon(Icons.coffee, color: colors.primaryNormal, size: 24)
                : null,
          ),
          const SizedBox(width: 12),
          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bean.name,
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: colors.labelNormal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(bean),
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: colors.labelAlternative,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (bean.displayPrice != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    AppUtil.changeNumberToWon(bean.displayPrice),
                    style: AppTextStyles.body2NormalBold.copyWith(
                      color: colors.labelNormal,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 담기 버튼
          Semantics(
            label: '${bean.name} 장바구니 담기',
            button: true,
            child: GestureDetector(
              onTap: () => controller.addToCart(bean),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_shopping_cart,
                  size: 18,
                  color: colors.primaryNormal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 산지 · 로스팅 보조 라벨
  String _subtitle(CatalogBean bean) {
    final parts = <String>[];
    if (bean.originLabel.isNotEmpty) parts.add(bean.originLabel);
    if (bean.roastLevel != null && bean.roastLevel!.isNotEmpty) {
      parts.add(bean.roastLevel!);
    }
    return parts.isEmpty ? '원두' : parts.join(' · ');
  }
}
