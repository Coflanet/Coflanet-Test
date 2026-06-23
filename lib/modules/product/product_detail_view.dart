import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/util_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/widgets/cards/card_section.dart';
import 'package:coflanet/widgets/cards/screen_scaffold.dart';
import 'package:coflanet/widgets/tags/flavor_tag.dart';

/// 인앱 상품 상세 화면 (추천 원두/상품).
///
/// 상품 데이터는 호출부에서 `Get.arguments['product']`(CoffeeRecommendationModel)
/// 으로 전달받는다 (원두 상세 `Get.arguments['bean']` 선례와 동일 패턴).
/// 별도 controller/binding 불필요 — 전달된 모델을 그대로 렌더하는 정적 화면이다.
///
/// 디자인: Static/Black 캔버스 + iyumi 카드([ScreenScaffold]/[CardSection]).
/// 카드 밖(캔버스)은 canvas(다크) 스킴, 카드 안은 of(context). 그림자 없음.
/// 외부 구매는 화면 하단 "구매하러 가기" CTA 로만 (기존 purchaseUrl 외부 열기).
/// 모델에 없는 정보는 표시하지 않는다 (있는 필드로만 구성).
class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  CoffeeRecommendationModel? get _productArg {
    final args = Get.arguments as Map<String, dynamic>?;
    return args?['product'] as CoffeeRecommendationModel?;
  }

  @override
  Widget build(BuildContext context) {
    final product = _productArg;
    return ScreenScaffold(
      title: '상품 상세',
      child: product == null
          ? _buildNotFound()
          : _buildContent(context, product),
    );
  }

  /// 인자 없이 진입한 비정상 케이스 — 캔버스(다크) 스킴 안내.
  Widget _buildNotFound() {
    final canvas = AppColorScheme.canvas;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.coffee_outlined, size: 48, color: canvas.labelAssistive),
          const SizedBox(height: AppSpacing.md),
          Text(
            '상품 정보를 불러올 수 없어요.',
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: canvas.labelAlternative,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, CoffeeRecommendationModel p) {
    // 카드 안 텍스트 색 — 활성 스킴
    final colors = AppColorScheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ===== 1) 히어로 — 이미지 + 이름 + 가격 =====
        CardSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImage(colors, p.imageUrl),
              const SizedBox(height: AppSpacing.lg),
              if (p.matchPercent > 0) ...[
                _buildMatchTag(colors, p.matchPercent),
                const SizedBox(height: AppSpacing.xs),
              ],
              Text(
                p.name,
                style: AppTextStyles.title3Bold.copyWith(
                  color: colors.labelStrong,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${p.manufacturer ?? '브랜드명'} | ${p.origin}',
                style: AppTextStyles.body2NormalRegular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildPriceRow(colors, p),
            ],
          ),
        ),

        // ===== 2) 추천 이유 (reason) =====
        if (p.reason != null && p.reason!.isNotEmpty) ...[
          const CardGap(),
          CardSection(
            title: '추천 이유',
            child: Text(
              p.reason!,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelNeutral,
                height: 1.5,
              ),
            ),
          ),
        ],

        // ===== 3) 상품 정보 (원산지/로스팅/중량) =====
        const CardGap(),
        CardSection(
          title: '상품 정보',
          child: Column(
            children: [
              _buildInfoRow(colors, '원산지', p.origin),
              _buildInfoRow(colors, '로스팅', p.roastLevel),
              if (p.weight != null && p.weight!.isNotEmpty)
                _buildInfoRow(colors, '중량', p.weight!),
            ],
          ),
        ),

        // ===== 4) 향미 태그 (flavorTags) =====
        if (p.flavorTags.isNotEmpty) ...[
          const CardGap(),
          CardSection(
            title: '향미',
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [for (final tag in p.flavorTags) FlavorTag(label: tag)],
            ),
          ),
        ],

        // ===== 5) 상품 설명 (description) =====
        if (p.description.isNotEmpty) ...[
          const CardGap(),
          CardSection(
            title: '상품 설명',
            child: Text(
              p.description,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelNeutral,
                height: 1.5,
              ),
            ),
          ),
        ],

        // ===== 6) 구매 CTA (purchaseUrl 있을 때만) — 외부 브라우저 =====
        if (p.purchaseUrl != null && p.purchaseUrl!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            text: '구매하러 가기',
            icon: Icons.open_in_new_rounded,
            iconAfterText: true,
            onPressed: () => _openPurchase(p.purchaseUrl!),
          ),
        ],
      ],
    );
  }

  /// 상품 이미지 (1:1) — 카드 안 인셋 톤(surfaceCardStrong) + itemRadius.
  Widget _buildImage(AppColorScheme colors, String? imageUrl) {
    return ClipRRect(
      borderRadius: AppRadius.itemRadiusBorder,
      child: AspectRatio(
        aspectRatio: 1,
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _imagePlaceholder(colors),
              )
            : _imagePlaceholder(colors),
      ),
    );
  }

  Widget _imagePlaceholder(AppColorScheme colors) {
    return Container(
      color: colors.surfaceCardStrong,
      alignment: Alignment.center,
      child: Icon(Icons.coffee, size: 48, color: colors.primaryNormal),
    );
  }

  /// 취향 일치율 태그 — product_card 와 동일한 시맨틱(연보라 칩).
  Widget _buildMatchTag(AppColorScheme colors, int matchPercent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: colors.primaryNormal.withValues(alpha: 0.1),
          borderRadius: AppRadius.smBorder,
        ),
        child: Text(
          '취향 $matchPercent%',
          style: AppTextStyles.caption1Medium.copyWith(
            color: colors.primaryNormal,
          ),
        ),
      ),
    );
  }

  /// 가격 행 — 할인율 + 가격(원). 가격 정보 없으면 미표시.
  Widget _buildPriceRow(AppColorScheme colors, CoffeeRecommendationModel p) {
    final price = p.discountPrice ?? p.originalPrice;
    if (price == null && p.discountPercent == null) {
      return const SizedBox.shrink();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (p.discountPercent != null) ...[
          Text(
            '${p.discountPercent}%',
            style: AppTextStyles.headline2Bold.copyWith(
              color: colors.primaryNormal,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        if (price != null)
          Text(
            AppUtil.changeNumberToWon(price),
            style: AppTextStyles.headline1Bold.copyWith(
              color: colors.labelStrong,
            ),
          ),
      ],
    );
  }

  /// 정보 행 — 좌측 라벨 + 우측 값 (카드 안).
  Widget _buildInfoRow(AppColorScheme colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.space64 + AppSpacing.xs, // 72 — 라벨 열 고정 폭
            child: Text(
              label,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: colors.labelNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 판매(구매) 링크를 외부 브라우저로 연다 (외부 구매는 CTA 로만 유지).
  Future<void> _openPurchase(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
