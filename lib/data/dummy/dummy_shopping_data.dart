import 'package:coflanet/data/models/banner_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 쇼핑 탭 샘플 데이터 — [백엔드 API 연동 대기]
///
/// 쇼핑 전용 상품/배너 API 가 아직 없어, 화면이 빈 상태로 보이지 않도록
/// 커피 주제에 맞는 샘플 상품을 제공한다. 실제 API 연동 시 이 클래스를
/// 리포지토리 호출로 교체한다 (모델은 [CoffeeRecommendationModel] 재사용).
class DummyShoppingData {
  DummyShoppingData._();

  /// 상단 광고 캐러셀 — 이미지 없는 색 배너(서버 bg_color 대체).
  static const List<BannerModel> carouselBanners = [
    BannerModel(
      id: 'sb1',
      slot: BannerSlot.homeCarousel,
      title: '오늘의 스페셜티\n에티오피아 한정 입고',
      bgColor: '#7D5EF7',
      priority: 3,
    ),
    BannerModel(
      id: 'sb2',
      slot: BannerSlot.homeCarousel,
      title: '첫 구독 30% 할인\n지금 시작하세요',
      bgColor: '#1B1C1E',
      priority: 2,
    ),
    BannerModel(
      id: 'sb3',
      slot: BannerSlot.homeCarousel,
      title: '디카페인도 맛있게\n저녁의 커피 한 잔',
      bgColor: '#2D7D5E',
      priority: 1,
    ),
    BannerModel(
      id: 'sb4',
      slot: BannerSlot.homeCarousel,
      title: '원두 2종 이상 구매 시\n무료 배송',
      bgColor: '#C2410C',
      priority: 0,
    ),
  ];

  /// 프로모 배너 — 섹션 사이 가로 띠 배너.
  static const BannerModel promoBanner = BannerModel(
    id: 'sp1',
    slot: BannerSlot.homePromo,
    title: '취향 설문하고\n맞춤 원두 추천받기',
    subtitle: '1분이면 충분해요',
    bgColor: '#7D5EF7',
  );

  /// 전체 상품 풀 — 섹션별로 잘라 쓴다.
  static const List<CoffeeRecommendationModel> _pool = [
    CoffeeRecommendationModel(
      id: 's1',
      name: '에티오피아 예가체프 G1',
      manufacturer: '커피랩',
      origin: '에티오피아',
      roastLevel: '라이트',
      description: '꽃향과 시트러스 노트가 특징',
      originalPrice: 18000,
      discountPrice: 15840,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 95,
      flavorTags: ['산미 강함', '자몽', '라벤더', '베르가못', '홍차'],
      rating: 4.86,
      reviewCount: 4538,
      tasteProfile: TasteProfileModel(
        acidity: 88,
        sweetness: 70,
        bitterness: 20,
        body: 40,
        aroma: 92,
        balance: 78,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's2',
      name: '콜롬비아 핑크버번 워시드',
      manufacturer: '빈브라더스',
      origin: '콜롬비아',
      roastLevel: '미디엄',
      description: '복숭아와 꿀 같은 단맛',
      originalPrice: 21000,
      discountPrice: 18480,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 88,
      flavorTags: ['복숭아', '꿀', '캐러멜'],
      rating: 4.78,
      reviewCount: 3120,
      tasteProfile: TasteProfileModel(
        acidity: 62,
        sweetness: 82,
        bitterness: 35,
        body: 58,
        aroma: 76,
        balance: 84,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's3',
      name: '과테말라 안티구아 SHB',
      manufacturer: '로스팅하우스',
      origin: '과테말라',
      roastLevel: '미디엄',
      description: '다크초콜릿과 스파이시한 향',
      originalPrice: 17000,
      discountPrice: 14960,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 72,
      flavorTags: ['다크초콜릿', '견과류', '스파이시'],
      rating: 4.71,
      reviewCount: 2870,
      tasteProfile: TasteProfileModel(
        acidity: 48,
        sweetness: 64,
        bitterness: 56,
        body: 70,
        aroma: 72,
        balance: 82,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's4',
      name: '케냐 AA 니에리',
      manufacturer: '프릳츠커피',
      origin: '케냐',
      roastLevel: '라이트',
      description: '블랙커런트와 와인 같은 산미',
      originalPrice: 23000,
      discountPrice: 20240,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 80,
      flavorTags: ['블랙커런트', '와인', '토마토'],
      rating: 4.82,
      reviewCount: 5210,
      tasteProfile: TasteProfileModel(
        acidity: 90,
        sweetness: 58,
        bitterness: 34,
        body: 62,
        aroma: 86,
        balance: 74,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's5',
      name: '브라질 세하도 펄프드내추럴',
      manufacturer: '테라로사',
      origin: '브라질',
      roastLevel: '미디엄',
      description: '부드럽고 고소한 견과류 풍미',
      originalPrice: 15000,
      discountPrice: 13200,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 66,
      flavorTags: ['헤이즐넛', '밀크초콜릿', '고소함'],
      rating: 4.69,
      reviewCount: 1980,
      tasteProfile: TasteProfileModel(
        acidity: 36,
        sweetness: 68,
        bitterness: 48,
        body: 72,
        aroma: 60,
        balance: 88,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's6',
      name: '파나마 게이샤 내추럴',
      manufacturer: '나무사이로',
      origin: '파나마',
      roastLevel: '라이트',
      description: '자스민 향과 복숭아 노트의 프리미엄',
      originalPrice: 45000,
      discountPrice: 38250,
      discountPercent: 15,
      weight: '200g',
      matchPercent: 91,
      flavorTags: ['자스민', '복숭아', '리치'],
      rating: 4.94,
      reviewCount: 6720,
      tasteProfile: TasteProfileModel(
        acidity: 84,
        sweetness: 90,
        bitterness: 16,
        body: 38,
        aroma: 96,
        balance: 80,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's7',
      name: '인도네시아 만델링 G1',
      manufacturer: '모모스커피',
      origin: '인도네시아',
      roastLevel: '다크',
      description: '묵직한 바디감과 허브 향',
      originalPrice: 19000,
      discountPrice: 16720,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 58,
      flavorTags: ['허브', '스모키', '다크초콜릿'],
      rating: 4.64,
      reviewCount: 1540,
      tasteProfile: TasteProfileModel(
        acidity: 24,
        sweetness: 46,
        bitterness: 82,
        body: 92,
        aroma: 64,
        balance: 70,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's8',
      name: '코스타리카 따라주 허니',
      manufacturer: '엘카페커피',
      origin: '코스타리카',
      roastLevel: '미디엄',
      description: '깔끔한 산미와 꿀 같은 단맛',
      originalPrice: 20000,
      discountPrice: 17600,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 76,
      flavorTags: ['꿀', '오렌지', '캐러멜'],
      rating: 4.75,
      reviewCount: 2340,
      tasteProfile: TasteProfileModel(
        acidity: 70,
        sweetness: 80,
        bitterness: 40,
        body: 56,
        aroma: 76,
        balance: 86,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's9',
      name: '르완다 키부 부르봉',
      manufacturer: '커피몽타주',
      origin: '르완다',
      roastLevel: '라이트',
      description: '레드베리와 플로럴 노트',
      originalPrice: 21000,
      discountPrice: 18480,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 69,
      flavorTags: ['레드베리', '플로럴', '오렌지'],
      rating: 4.7,
      reviewCount: 1760,
      tasteProfile: TasteProfileModel(
        acidity: 80,
        sweetness: 70,
        bitterness: 30,
        body: 50,
        aroma: 82,
        balance: 76,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's10',
      name: '하와이 코나 엑스트라팬시',
      manufacturer: '앤트러사이트',
      origin: '하와이',
      roastLevel: '미디엄',
      description: '부드러운 바디와 버터 같은 질감',
      originalPrice: 38000,
      discountPrice: 32300,
      discountPercent: 15,
      weight: '200g',
      matchPercent: 73,
      flavorTags: ['버터', '브라운슈거', '아몬드'],
      rating: 4.88,
      reviewCount: 4010,
      tasteProfile: TasteProfileModel(
        acidity: 46,
        sweetness: 72,
        bitterness: 40,
        body: 76,
        aroma: 80,
        balance: 84,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's11',
      name: '엘살바도르 파카마라 내추럴',
      manufacturer: '리브레',
      origin: '엘살바도르',
      roastLevel: '라이트',
      description: '열대과일과 와인의 복합미',
      originalPrice: 24000,
      discountPrice: 21120,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 84,
      flavorTags: ['망고', '레드와인', '카카오닙스'],
      rating: 4.81,
      reviewCount: 2210,
      tasteProfile: TasteProfileModel(
        acidity: 78,
        sweetness: 76,
        bitterness: 28,
        body: 60,
        aroma: 88,
        balance: 79,
      ),
    ),
    CoffeeRecommendationModel(
      id: 's12',
      name: '콜롬비아 디카페인 슈가케인',
      manufacturer: '커피그래피티',
      origin: '콜롬비아',
      roastLevel: '미디엄',
      description: '카페인 걱정 없이 즐기는 균형감',
      originalPrice: 16000,
      discountPrice: 14080,
      discountPercent: 12,
      weight: '200g',
      matchPercent: 62,
      flavorTags: ['밀크초콜릿', '아몬드', '레드애플'],
      rating: 4.66,
      reviewCount: 1320,
      tasteProfile: TasteProfileModel(
        acidity: 50,
        sweetness: 70,
        bitterness: 44,
        body: 58,
        aroma: 66,
        balance: 82,
      ),
    ),
  ];

  /// {닉네임}님을 위한 추천 원두 — 일치율 높은 순(가로 스크롤).
  static List<CoffeeRecommendationModel> get recommended =>
      (_pool.toList()..sort((a, b) => b.matchPercent.compareTo(a.matchPercent)))
          .take(6)
          .toList();

  /// 카테고리별 베스트 상품 — 2열 그리드(6종).
  static List<CoffeeRecommendationModel> get categoryBest =>
      _pool.skip(2).take(6).toList();

  /// Coflanet 인기 원두 랭킹 — 리뷰 수 상위 5종(세로 랭킹).
  static List<CoffeeRecommendationModel> get ranking =>
      (_pool.toList()
            ..sort((a, b) => (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0)))
          .take(5)
          .toList();

  /// 이번주 실시간 인기 원두 — 별점 상위(가로 스크롤).
  static List<CoffeeRecommendationModel> get realtimePopular =>
      (_pool.toList()
            ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0)))
          .take(6)
          .toList();

  /// 오늘만 열리는 커피 행성(타임세일) — 2열 그리드(4종).
  static List<CoffeeRecommendationModel> get timeSale =>
      _pool.skip(5).take(4).toList();
}
