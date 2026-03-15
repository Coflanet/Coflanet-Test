-- ============================================================
-- 커피 원두 시드 데이터
-- 원본: refs/App/data/coffees.json (99개 중 97개, taste 전부 null인 2개 제외)
-- 생성일: 2026-02-12
-- ============================================================

-- ============================================================
-- 1. coffee_beans 테이블 INSERT
-- taste 값: 1-5 스케일 → 0-100 스케일 (x20, 소수점 반올림)
-- roast_level: 1-3=light, 4-5=medium, 6-7=medium_dark, 8-10=dark
-- ============================================================

INSERT INTO public.coffee_beans (
  name, origin, roast_point, roast_level, description, image_url,
  original_price, discount_price, discount_percent, weight, purchase_url,
  acidity, sweetness, bitterness, body, aroma,
  is_available, stock
) VALUES
-- coffee_001
('테라로사', ARRAY['Brazil','Honduras'], 8, 'dark', NULL, NULL,
 38400, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/6924474148',
 20, 40, 100, 100, 0, true, 0),
-- coffee_002
('르델', ARRAY['Brazil','India','Ethiopia'], 6, 'medium_dark', NULL, NULL,
 33990, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7972486309',
 40, 60, 80, 80, 0, true, 0),
-- coffee_003
('폴바셋 시그니처 블렌드', ARRAY['Brazil','Ethiopia'], 6, 'medium_dark', NULL, NULL,
 21350, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/2207425944',
 60, 80, 40, 60, 0, true, 0),
-- coffee_004
('할리데이 에디오피아 예가체프 G2', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 36500, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8371786081',
 70, 80, 40, 50, 0, true, 0),
-- coffee_005
('모모스 하우스 블렌드', ARRAY['Brazil','Ethiopia'], 7, 'medium_dark', NULL, NULL,
 36900, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/6698177963',
 40, 70, 80, 80, 0, true, 0),
-- coffee_006
('수미커피 에디오피아 예가체프 G1', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 25500, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/8933015438',
 70, 80, 40, 50, 0, true, 0),
-- coffee_007
('모모스 므쵸베리', ARRAY['Ethiopia','Colombia'], 4, 'medium', NULL, NULL,
 38900, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/8648382244',
 70, 80, 40, 50, 0, true, 0),
-- coffee_008
('수달리 고소한 너티초코', ARRAY['Brazil','Colombia','India'], 8, 'dark', NULL, NULL,
 29900, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7378868550',
 10, 50, 100, 100, 0, true, 0),
-- coffee_009
('수달리 에디오피아 예가체프 G2', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 29900, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/6949474397',
 50, 80, 40, 50, 0, true, 0),
-- coffee_010
('컬트 커피랩 과테말라', ARRAY['Guatemala'], 6, 'medium_dark', NULL, NULL,
 10409, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/8422726643',
 40, 60, 80, 90, 0, true, 0),
-- coffee_011
('벙커컴퍼니 #8.5', ARRAY['Ethiopia','Colombia','India'], NULL, NULL, NULL, NULL,
 53000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/5970976317',
 80, 60, 20, 40, 0, true, 0),
-- coffee_012
('라이언 바닐라 마카다미아', ARRAY[]::TEXT[], 3, 'light', NULL, NULL,
 36900, NULL, NULL, '680g', 'https://www.coupang.com/vp/products/166190069',
 80, 60, 20, 40, 0, true, 0),
-- coffee_013
('쿠키나인 과테말라', ARRAY['Guatemala'], 5, 'medium', NULL, NULL,
 19900, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/8702724297',
 60, 80, 40, 80, 0, true, 0),
-- coffee_014
('룰리커피 오리지널 블렌드', ARRAY['Brazil','Tanzania','Colombia','Costa Rica'], 7, 'medium_dark', NULL, NULL,
 36000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8702724297',
 40, 60, 80, 90, 0, true, 0),
-- coffee_015
('사운즈 커피 에디오피아 이디도', ARRAY['Ethiopia'], NULL, NULL, NULL, NULL,
 19500, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/9103262051',
 70, 80, 40, 50, 0, true, 0),
-- coffee_016
('오클락커피 에디오피아 아바야 게이샤', ARRAY['Ethiopia'], NULL, NULL, NULL, NULL,
 43810, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8200318470',
 70, 80, 40, 50, 0, true, 0),
-- coffee_017
('아눅커피 어썸블렌드', ARRAY['Brazil'], 8, 'dark', NULL, NULL,
 19900, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7634925632',
 20, 40, 100, 100, 0, true, 0),
-- coffee_018
('커피를 생각하다 블라썸', ARRAY[]::TEXT[], 7, 'medium_dark', NULL, NULL,
 30700, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8327469971',
 40, 60, 80, 80, 0, true, 0),
-- coffee_019
('가배인 에디오피아 예가체프', ARRAY['Ethiopia'], 7, 'medium_dark', NULL, NULL,
 94490, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7408911057',
 50, 60, 80, 70, 0, true, 0),
-- coffee_020
('JMD 커피 컴패니 에디오피아', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 26390, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/7821227314',
 70, 80, 40, 50, 0, true, 0),
-- coffee_021
('블랙빈스 케냐', ARRAY['Kenya'], 8, 'dark', NULL, NULL,
 30910, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8513943632',
 40, 40, 100, 90, 0, true, 0),
-- coffee_022
('빈오너스 딥초코', ARRAY['Brazil','Kenya','Colombia'], 7, 'medium_dark', NULL, NULL,
 30000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8864039850',
 30, 60, 80, 90, 0, true, 0),
-- coffee_023
('사운즈 라떼를위한 블렌드', ARRAY['Colombia'], 6, 'medium_dark', NULL, NULL,
 279000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/9063882311',
 40, 70, 80, 90, 0, true, 0),
-- coffee_024
('블루보틀 밸런스', ARRAY['Colombia'], 5, 'medium', NULL, NULL,
 17900, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/8987099930',
 60, 90, 40, 70, 0, true, 0),
-- coffee_025
('나무사이로 풍요로운 땅', ARRAY['Brazil','Colombia','Honduras'], 8, 'dark', NULL, NULL,
 43000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8003954388',
 20, 40, 100, 100, 0, true, 0),
-- coffee_026
('로우키 블렌드', ARRAY['Brazil','El Salvador','Colombia'], 7, 'medium_dark', NULL, NULL,
 59300, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8490886475',
 40, 60, 80, 80, 0, true, 0),
-- coffee_027
('델문도 에디오피아 케라모', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 60000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7865520586',
 70, 80, 40, 50, 0, true, 0),
-- coffee_028
('테라로사 과테말라 우에우에', ARRAY['Guatemala'], NULL, NULL, NULL, NULL,
 35000, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/7530712116',
 20, 40, 100, 100, 0, true, 0),
-- coffee_029
('로엘 켈리포니아 블렌드', ARRAY['Brazil','Colombia'], 7, 'medium_dark', NULL, NULL,
 16800, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/8451541322',
 30, 60, 80, 90, 0, true, 0),
-- coffee_030
('빈오너스 아란치오 블렌드', ARRAY['Ethiopia'], 6, 'medium_dark', NULL, NULL,
 17000, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/8666084243',
 70, 80, 40, 50, 0, true, 0),
-- coffee_031
('컬트 커피랩 브라질 스페셜티', ARRAY['Brazil'], 6, 'medium_dark', NULL, NULL,
 36990, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8416569978',
 30, 60, 80, 90, 0, true, 0),
-- coffee_032
('오클락커피 에디오피아 구지', ARRAY['Ethiopia'], 5, 'medium', NULL, NULL,
 26500, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/8289859523',
 70, 80, 40, 60, 0, true, 0),
-- coffee_033
('블루보틀 볼드', ARRAY['Colombia'], 9, 'dark', NULL, NULL,
 17120, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/7210186640',
 20, 50, 100, 100, 0, true, 0),
-- coffee_034
('커피의신 하와이안 코나', ARRAY['Hawaii'], 3, 'light', NULL, NULL,
 336000, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8288489915',
 80, 60, 20, 40, 0, true, 0),
-- coffee_036
('맥널티 하와이안 코나', ARRAY['Brazil','Kenya','Costa Rica','Hawaii'], 4, 'medium', NULL, NULL,
 28900, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7612947135',
 60, 80, 40, 60, 0, true, 0),
-- coffee_037
('맥널티 게이샤 블렌딩', ARRAY['Ethiopia','Colombia'], 4, 'medium', NULL, NULL,
 36280, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/7612947477',
 60, 80, 40, 60, 0, true, 0),
-- coffee_038
('위트러스트 콜롬비아 더블무산소', ARRAY['Colombia'], 7, 'medium_dark', NULL, NULL,
 22000, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/7826592925',
 40, 70, 80, 90, 0, true, 0),
-- coffee_039
('일킬로커피 에디오피아 무산소', ARRAY['Ethiopia'], 5, 'medium', NULL, NULL,
 52800, NULL, NULL, '400g', 'https://www.coupang.com/vp/products/5269870972',
 70, 80, 40, 50, 0, true, 0),
-- coffee_040
('JMD 에디오피아 첼바', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 25500, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/8844668574',
 70, 80, 40, 50, 0, true, 0),
-- coffee_041
('ACR 메리제인 블렌딩', ARRAY['Ethiopia','Colombia','Costa Rica'], 5, 'medium', NULL, NULL,
 22800, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/8813771332',
 70, 90, 40, 50, 0, true, 0),
-- coffee_042
('커피 리브레 배드블렌딩', ARRAY['Costa Rica','Ethiopia','Nicaragua'], 4, 'medium', NULL, NULL,
 17450, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/5387711962',
 60, 80, 40, 60, 0, true, 0),
-- coffee_043
('올인커피 케냐 포도봉봉 (가향)', ARRAY['Kenya'], 4, 'medium', NULL, NULL,
 10500, NULL, NULL, '100g', 'https://www.coupang.com/vp/products/8691036916',
 80, 80, 40, 50, 0, true, 0),
-- coffee_044
('훔볼트 피오네르 블렌드', ARRAY['Brazil','Ethiopia'], 7, 'medium_dark', NULL, NULL,
 27310, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/5453596114',
 40, 60, 80, 80, 0, true, 0),
-- coffee_045
('사운즈커피 복숭아 케냐 (가향)', ARRAY['Kenya','Colombia'], NULL, NULL, NULL, NULL,
 29500, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/9126230010',
 90, 70, 20, 40, 0, true, 0),
-- coffee_046
('사운즈커피 워터멜론 콜롬비아 (가향)', ARRAY['Colombia'], NULL, NULL, NULL, NULL,
 44000, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/9126258603',
 80, 70, 20, 50, 0, true, 0),
-- coffee_047
('블랙빈스 헤이즐넛향 커피', ARRAY[]::TEXT[], 8, 'dark', NULL, NULL,
 22850, NULL, NULL, '1kg', 'https://www.coupang.com/vp/products/8542724214',
 20, 80, 100, 100, 0, true, 0),
-- coffee_048
('SC컴퍼니 카라멜향 커피', ARRAY['Vietnam'], 6, 'medium_dark', NULL, NULL,
 13440, NULL, NULL, '500g', 'https://www.coupang.com/vp/products/8448740631',
 20, 80, 80, 100, 0, true, 0),
-- coffee_049
('프릳츠 올드독 블랜딩', ARRAY['Costa Rica','India','El Salvador'], NULL, NULL, NULL, NULL,
 16990, NULL, NULL, '200g', 'https://www.coupang.com/vp/products/8198344516',
 60, 80, 40, 60, 0, true, 0),
-- coffee_050
('온니컵 콜롬비아 칸도르 게이샤 워시드', ARRAY['Colombia'], 4, 'medium', NULL, NULL,
 24000, NULL, NULL, '100g', 'https://smartstore.naver.com/coffeecodij/products/10453860428',
 80, 90, 40, 70, 0, true, 0),
-- coffee_051
('온니컵 풀블랙 블렌딩', ARRAY['Brazil'], 7, 'medium_dark', NULL, NULL,
 33000, NULL, NULL, '850g', 'https://smartstore.naver.com/coffeecodij/products/7237278416',
 40, 60, 80, 80, 0, true, 0),
-- coffee_052
('딥블루레이크 온두라스 로스피노스', ARRAY[]::TEXT[], NULL, NULL, NULL, NULL,
 18000, NULL, NULL, '100g', 'https://dblcoffee.com/product/detail.html?product_no=453',
 40, 60, 80, 80, 0, true, 0),
-- coffee_053
('필아웃 엘살바도르 산안드레스', ARRAY['El Salvador'], 4, 'medium', NULL, NULL,
 22000, NULL, NULL, '200g', 'https://smartstore.naver.com/filloutcoffee/products/11637593798',
 70, 80, 40, 50, 0, true, 0),
-- coffee_054
('필아웃 시나몬게이트 (가향)', ARRAY['Colombia'], 4, 'medium', NULL, NULL,
 24000, NULL, NULL, '200g', 'https://smartstore.naver.com/filloutcoffee/products/8427587166',
 60, 90, 40, 70, 0, true, 0),
-- coffee_055
('필아웃 에디오피아 타미루 알로 무산소', ARRAY['Ethiopia'], 3, 'light', NULL, NULL,
 25000, NULL, NULL, '200g', 'https://smartstore.naver.com/filloutcoffee/products/11637556454',
 90, 60, 20, 30, 0, true, 0),
-- coffee_056
('필아웃 플로럴게이트 (가향)', ARRAY['Colombia'], 4, 'medium', NULL, NULL,
 24000, NULL, NULL, '200g', 'https://smartstore.naver.com/filloutcoffee/products/11637388217',
 60, 90, 40, 70, 0, true, 0),
-- coffee_057
('엘커피 코스타리카 엘사르 데 사르세로', ARRAY['Costa Rica'], NULL, NULL, NULL, NULL,
 17000, NULL, NULL, '200g', 'https://elcafe.co.kr/product/966',
 70, 90, 40, 60, 0, true, 0),
-- coffee_058
('엘커피 에디오피아 벤사 게메초 내추럴', ARRAY['Ethiopia'], 1, 'light', NULL, NULL,
 22000, NULL, NULL, '200g', 'https://elcafe.co.kr/product/961',
 90, 60, 20, 30, 0, true, 0),
-- coffee_059
('엘커피 온두라스 파카마라', ARRAY['Honduras'], 2, 'light', NULL, NULL,
 21000, NULL, NULL, '200g', 'https://elcafe.co.kr/product/970',
 80, 60, 20, 40, 0, true, 0),
-- coffee_060
('180로스터리 인도네시아 쁘가싱 (가향)', ARRAY[]::TEXT[], NULL, NULL, NULL, NULL,
 43200, NULL, NULL, '500g', 'https://smartstore.naver.com/180coffeeroasters/products/12600936166',
 60, 80, 40, 60, 0, true, 0),
-- coffee_061
('180로스터리 코스타리카 벨라비스타', ARRAY[]::TEXT[], NULL, NULL, NULL, NULL,
 46800, NULL, NULL, '1kg', 'https://smartstore.naver.com/180coffeeroasters/products/12518016405',
 60, 80, 40, 60, 0, true, 0),
-- coffee_063
('모모스 에콰도르 CVM', ARRAY['Ecuador'], 3, 'light', NULL, NULL,
 25000, NULL, NULL, '100g', 'https://momos.co.kr/product/2569',
 80, 60, 20, 40, 0, true, 0),
-- coffee_064
('모모스 에디오피아 게샤빌리지', ARRAY['Ethiopia'], 3, 'light', NULL, NULL,
 29000, NULL, NULL, '100g', 'https://momos.co.kr/product/2559',
 90, 60, 20, 30, 0, true, 0),
-- coffee_065
('모모스 코스타리카 수바마', ARRAY['Costa Rica'], NULL, NULL, NULL, NULL,
 16000, NULL, NULL, '200g', 'https://momos.co.kr/product/2527',
 70, 90, 40, 60, 0, true, 0),
-- coffee_066
('아이덴티티 에디오피아 바샤 베켈레', ARRAY['Ethiopia'], 2, 'light', NULL, NULL,
 17000, NULL, NULL, '150g', 'https://smartstore.naver.com/identity_coffeelab/products/12828340377',
 90, 60, 20, 30, 0, true, 0),
-- coffee_067
('아이덴티티 온두라스 엘라우렐', ARRAY['Honduras'], 2, 'light', NULL, NULL,
 14000, NULL, NULL, '150g', 'https://smartstore.naver.com/identity_coffeelab/products/12828265724',
 80, 60, 20, 40, 0, true, 0),
-- coffee_068
('레쉬커피 미드나잇 블렌드', ARRAY['Ethiopia','Colombia'], NULL, NULL, NULL, NULL,
 20900, NULL, NULL, '200g', 'https://smartstore.naver.com/leshycoffee/products/10913434128',
 80, 60, 20, 40, 0, true, 0),
-- coffee_069
('레쉬커피 체리밤 블렌드', ARRAY['Ethiopia','Colombia'], NULL, NULL, NULL, NULL,
 55900, NULL, NULL, '500g', 'https://smartstore.naver.com/leshycoffee/products/10315108104',
 80, 60, 20, 40, 0, true, 0),
-- coffee_070
('UFO 탄자니아 게이샤', ARRAY['Tanzania'], NULL, NULL, NULL, NULL,
 17000, NULL, NULL, '100g', 'https://ufocoffee.co.kr/shop/detail/69296290d8a929fa5573c06d',
 70, 60, 30, 50, 0, true, 0),
-- coffee_071
('UFO 브라질', ARRAY['Brazil'], NULL, NULL, NULL, NULL,
 13000, NULL, NULL, '100g', 'https://ufocoffee.co.kr/shop/detail/692960c5d8a929fa5573a1c4',
 50, 80, 40, 70, 0, true, 0),
-- coffee_072
('UFO 콜롬비아 게이샤', ARRAY['Colombia'], NULL, NULL, NULL, NULL,
 29000, NULL, NULL, '100g', 'https://ufocoffee.co.kr/shop/detail/6929611dd8a929fa5573a990',
 80, 70, 20, 50, 0, true, 0),
-- coffee_073
('1%커피 예가체프 아리차', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 10000, NULL, NULL, '200g', 'https://brand.naver.com/1procoffee/products/10012730604',
 70, 80, 40, 50, 0, true, 0),
-- coffee_074
('킨온커피 에디오피아 넨센보', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 12900, NULL, NULL, '200g', 'https://smartstore.naver.com/keenoncoffee/products/10461623255',
 70, 80, 40, 50, 0, true, 0),
-- coffee_075
('킨온커피 에디오피아 니구세 몰케', ARRAY['Ethiopia'], 4, 'medium', NULL, NULL,
 20900, NULL, NULL, '200g', 'https://smartstore.naver.com/keenoncoffee/products/12113064634',
 70, 80, 40, 50, 0, true, 0),
-- coffee_076
('언더빈 케냐 니에리 키와와무루루', ARRAY['Kenya'], 4, 'medium', NULL, NULL,
 10000, NULL, NULL, '150g', 'https://smartstore.naver.com/underbean/products/12776936977',
 80, 80, 40, 50, 0, true, 0),
-- coffee_077
('언더빈 엘살바도르 산타로사 파카마라허니', ARRAY['El Salvador'], 5, 'medium', NULL, NULL,
 14500, NULL, NULL, '150g', 'https://smartstore.naver.com/underbean/products/10933219955',
 60, 80, 40, 60, 0, true, 0),
-- coffee_078
('언더빈 온두라스 엘네그로 파라이네마', ARRAY['Honduras'], 7, 'medium_dark', NULL, NULL,
 10000, NULL, NULL, '150g', 'https://smartstore.naver.com/underbean/products/12744280943',
 40, 60, 80, 80, 0, true, 0),
-- coffee_079
('히치커피 엘파라이소 리치피치', ARRAY['Colombia'], NULL, NULL, NULL, NULL,
 12000, NULL, NULL, '100g', 'https://smartstore.naver.com/roastery_y/products/12074452844',
 60, 90, 40, 70, 0, true, 0),
-- coffee_080
('히치커피 에디오피아 벤치마지', ARRAY['Ethiopia'], NULL, NULL, NULL, NULL,
 8800, NULL, NULL, '100g', 'https://smartstore.naver.com/bibcoffee/products/12003550703',
 70, 80, 40, 50, 0, true, 0),
-- coffee_081
('빕커피 콜롬비아 세로아줄 게이샤', ARRAY['Colombia'], NULL, NULL, NULL, NULL,
 39000, NULL, NULL, '150g', 'https://smartstore.naver.com/bibcoffee/products/12003550703',
 60, 90, 40, 70, 0, true, 0),
-- coffee_082
('디포인트커피 코스타리카 돈마요엘 (가향)', ARRAY['Costa Rica'], NULL, NULL, NULL, NULL,
 17600, NULL, NULL, '200g', 'https://smartstore.naver.com/dpointcoffee/products/12366262184',
 70, 90, 40, 60, 0, true, 0),
-- coffee_083
('디포인트커피 과테말라 쿠프 아그리코라', ARRAY['Guatemala'], NULL, NULL, NULL, NULL,
 16000, NULL, NULL, '100g', 'https://smartstore.naver.com/dpointcoffee/products/11253612586',
 60, 90, 40, 70, 0, true, 0),
-- coffee_084
('디콰이엇 소프트엠버 블렌드', ARRAY['Brazil','India','Ethiopia','Guatemala'], 7, 'medium_dark', NULL, NULL,
 11900, NULL, NULL, '160g', 'https://smartstore.naver.com/dequiet/products/11843823163',
 40, 60, 80, 80, 0, true, 0),
-- coffee_085
('디콰이엇 문라이트 블렌드', ARRAY['Colombia','Brazil','Ethiopia','Honduras'], 5, 'medium', NULL, NULL,
 11900, NULL, NULL, '160g', 'https://smartstore.naver.com/dequiet/products/11844025691',
 60, 80, 40, 60, 0, true, 0),
-- coffee_086
('얼터커피 코스타리카 로스유칼립토스 게이샤', ARRAY['Costa Rica'], NULL, NULL, NULL, NULL,
 18000, NULL, NULL, '100g', 'https://smartstore.naver.com/altercoffee/products/11576422066',
 70, 90, 40, 60, 0, true, 0),
-- coffee_087
('얼터커피 시다모 벤사 코코세', ARRAY['Ethiopia'], NULL, NULL, NULL, NULL,
 14000, NULL, NULL, '100g', 'https://smartstore.naver.com/altercoffee/products/12090072771',
 70, 80, 40, 50, 0, true, 0),
-- coffee_088
('오멜라스 과테말라 알로테낭고 카우일', ARRAY['Guatemala'], NULL, NULL, NULL, NULL,
 14000, NULL, NULL, '200g', 'https://smartstore.naver.com/omelascoffee/products/12741734744',
 40, 60, 80, 80, 0, true, 0),
-- coffee_089
('오멜라스 브라질 세하도', ARRAY['Brazil'], NULL, NULL, NULL, NULL,
 12000, NULL, NULL, '200g', 'https://smartstore.naver.com/omelascoffee/products/12741703189',
 30, 60, 80, 90, 0, true, 0),
-- coffee_090
('몰리프 스트로베리 핑크 블렌드', ARRAY['Ethiopia'], 5, 'medium', NULL, NULL,
 16000, NULL, NULL, '250g', 'https://smartstore.naver.com/mollif/products/11075208477',
 70, 80, 40, 50, 0, true, 0),
-- coffee_091
('아우라 콜롬비아 레몬그라스 무산소', ARRAY['Colombia'], 4, 'medium', NULL, NULL,
 25000, NULL, NULL, '200g', 'https://smartstore.naver.com/auracoffee/products/12593600518',
 60, 90, 40, 70, 0, true, 0),
-- coffee_092
('아우라 케냐 록번 니에리', ARRAY['Kenya'], 4, 'medium', NULL, NULL,
 18000, NULL, NULL, '200g', 'https://smartstore.naver.com/auracoffee/products/12130037550',
 80, 80, 40, 50, 0, true, 0),
-- coffee_093
('원세컨즈 에디오피아 구지 사키소', ARRAY['Ethiopia'], NULL, NULL, NULL, NULL,
 9500, NULL, NULL, '200g', 'https://smartstore.naver.com/onesecondcoffee/products/11627875031',
 70, 80, 40, 50, 0, true, 0),
-- coffee_094
('커피멜로우 과테말라 엘인헤르또 게이샤', ARRAY['Guatemala'], NULL, NULL, NULL, NULL,
 36000, NULL, NULL, '100g', 'https://smartstore.naver.com/coffeemellow/products/10532999400',
 60, 90, 40, 70, 0, true, 0),
-- coffee_095
('커피멜로우 과테말라 엘 소코로', ARRAY['Guatemala'], NULL, NULL, NULL, NULL,
 11000, NULL, NULL, '100g', 'https://smartstore.naver.com/coffeemellow/products/9062015315',
 60, 90, 40, 70, 0, true, 0),
-- coffee_096
('JNBean 인도네시아 만델링', ARRAY['Indonesia'], 7, 'medium_dark', NULL, NULL,
 12000, NULL, NULL, '200g', 'https://smartstore.naver.com/jnbeanscoffee/products/11974858950',
 20, 60, 80, 100, 0, true, 0),
-- coffee_097
('러스브루어스 니카라과 핀카 리브레', ARRAY['Nicaragua'], NULL, NULL, NULL, NULL,
 13500, NULL, NULL, '100g', 'https://smartstore.naver.com/rus_brewers/products/12892109514',
 80, 60, 20, 40, 0, true, 0),
-- coffee_098
('러스브루어스 페루 로스 산토스', ARRAY['Peru'], NULL, NULL, NULL, NULL,
 20000, NULL, NULL, '100g', 'https://smartstore.naver.com/rus_brewers/products/12840780144',
 80, 60, 20, 40, 0, true, 0),
-- coffee_099
('러스브루어스 파나마 알토밤비토', ARRAY['Panama'], NULL, NULL, NULL, NULL,
 39000, NULL, NULL, '100g', 'https://smartstore.naver.com/rus_brewers/products/12864587770',
 100, 70, 20, 40, 0, true, 0)
ON CONFLICT DO NOTHING;


-- ============================================================
-- 2. bean_flavor_tags 테이블 INSERT
-- 허용 카테고리: Fruity, Floral, Nutty_Cocoa, Roasted
-- 제외 카테고리: Sweet, Sour/Fermented, Green/Vegetative, Spices
-- bean_id는 서브쿼리로 name 기반 참조
-- ============================================================

INSERT INTO public.bean_flavor_tags (bean_id, category, sub_category, descriptor, display_order) VALUES
-- coffee_001: 테라로사
((SELECT id FROM public.coffee_beans WHERE name = '테라로사'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 1),
-- coffee_003: 폴바셋 시그니처 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '폴바셋 시그니처 블렌드'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '폴바셋 시그니처 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 2),
-- coffee_004: 할리데이 에디오피아 예가체프 G2
((SELECT id FROM public.coffee_beans WHERE name = '할리데이 에디오피아 예가체프 G2'), 'Fruity', 'Other fruit', 'Lychee', 1),
-- coffee_005: 모모스 하우스 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '모모스 하우스 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 1),
-- coffee_006: 수미커피 에디오피아 예가체프 G1
((SELECT id FROM public.coffee_beans WHERE name = '수미커피 에디오피아 예가체프 G1'), 'Fruity', 'Other fruit', 'Pineapple', 1),
((SELECT id FROM public.coffee_beans WHERE name = '수미커피 에디오피아 예가체프 G1'), 'Fruity', 'Citrus fruit', 'Orange', 2),
((SELECT id FROM public.coffee_beans WHERE name = '수미커피 에디오피아 예가체프 G1'), 'Fruity', 'Berry', 'Blueberry', 3),
-- coffee_007: 모모스 므쵸베리
((SELECT id FROM public.coffee_beans WHERE name = '모모스 므쵸베리'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '모모스 므쵸베리'), 'Fruity', 'Other fruit', 'Cherry', 2),
-- coffee_008: 수달리 고소한 너티초코
((SELECT id FROM public.coffee_beans WHERE name = '수달리 고소한 너티초코'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 1),
((SELECT id FROM public.coffee_beans WHERE name = '수달리 고소한 너티초코'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 2),
-- coffee_009: 수달리 에디오피아 예가체프 G2
((SELECT id FROM public.coffee_beans WHERE name = '수달리 에디오피아 예가체프 G2'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = '수달리 에디오피아 예가체프 G2'), 'Fruity', 'Other fruit', 'Peach', 2),
((SELECT id FROM public.coffee_beans WHERE name = '수달리 에디오피아 예가체프 G2'), 'Fruity', 'Citrus fruit', 'Lemon', 3),
-- coffee_010: 컬트 커피랩 과테말라
((SELECT id FROM public.coffee_beans WHERE name = '컬트 커피랩 과테말라'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '컬트 커피랩 과테말라'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 2),
((SELECT id FROM public.coffee_beans WHERE name = '컬트 커피랩 과테말라'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 3),
-- coffee_012: 라이언 바닐라 마카다미아
((SELECT id FROM public.coffee_beans WHERE name = '라이언 바닐라 마카다미아'), 'Nutty_Cocoa', 'Nutty', 'Macadamia', 1),
-- coffee_013: 쿠키나인 과테말라
((SELECT id FROM public.coffee_beans WHERE name = '쿠키나인 과테말라'), 'Nutty_Cocoa', 'Nutty', 'Almond', 1),
((SELECT id FROM public.coffee_beans WHERE name = '쿠키나인 과테말라'), 'Nutty_Cocoa', 'Nutty', 'Walnut', 2),
((SELECT id FROM public.coffee_beans WHERE name = '쿠키나인 과테말라'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 3),
-- coffee_015: 사운즈 커피 에디오피아 이디도
((SELECT id FROM public.coffee_beans WHERE name = '사운즈 커피 에디오피아 이디도'), 'Fruity', 'Dried fruit', 'Prune', 1),
((SELECT id FROM public.coffee_beans WHERE name = '사운즈 커피 에디오피아 이디도'), 'Fruity', 'Berry', 'Berry', 2),
-- coffee_016: 오클락커피 에디오피아 아바야 게이샤
((SELECT id FROM public.coffee_beans WHERE name = '오클락커피 에디오피아 아바야 게이샤'), 'Fruity', 'Berry', 'Cranberry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '오클락커피 에디오피아 아바야 게이샤'), 'Fruity', 'Berry', 'Raspberry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '오클락커피 에디오피아 아바야 게이샤'), 'Fruity', 'Citrus fruit', 'Orange', 3),
((SELECT id FROM public.coffee_beans WHERE name = '오클락커피 에디오피아 아바야 게이샤'), 'Nutty_Cocoa', 'Nutty', 'Almond', 4),
-- coffee_017: 아눅커피 어썸블렌드
((SELECT id FROM public.coffee_beans WHERE name = '아눅커피 어썸블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 1),
((SELECT id FROM public.coffee_beans WHERE name = '아눅커피 어썸블렌드'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 2),
-- coffee_018: 커피를 생각하다 블라썸
((SELECT id FROM public.coffee_beans WHERE name = '커피를 생각하다 블라썸'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 1),
-- coffee_019: 가배인 에디오피아 예가체프
((SELECT id FROM public.coffee_beans WHERE name = '가배인 에디오피아 예가체프'), 'Fruity', 'Dried fruit', 'Prune', 1),
((SELECT id FROM public.coffee_beans WHERE name = '가배인 에디오피아 예가체프'), 'Fruity', 'Other fruit', 'Peach', 2),
((SELECT id FROM public.coffee_beans WHERE name = '가배인 에디오피아 예가체프'), 'Fruity', 'Berry', 'Blackberry', 3),
-- coffee_020: JMD 커피 컴패니 에디오피아
((SELECT id FROM public.coffee_beans WHERE name = 'JMD 커피 컴패니 에디오피아'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = 'JMD 커피 컴패니 에디오피아'), 'Fruity', 'Berry', 'Berry', 2),
((SELECT id FROM public.coffee_beans WHERE name = 'JMD 커피 컴패니 에디오피아'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 3),
-- coffee_021: 블랙빈스 케냐
((SELECT id FROM public.coffee_beans WHERE name = '블랙빈스 케냐'), 'Fruity', 'Citrus fruit', 'Grapefruit', 1),
((SELECT id FROM public.coffee_beans WHERE name = '블랙빈스 케냐'), 'Fruity', 'Berry', 'Black Currant', 2),
((SELECT id FROM public.coffee_beans WHERE name = '블랙빈스 케냐'), 'Fruity', 'Berry', 'Berry', 3),
-- coffee_022: 빈오너스 딥초코
((SELECT id FROM public.coffee_beans WHERE name = '빈오너스 딥초코'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 1),
((SELECT id FROM public.coffee_beans WHERE name = '빈오너스 딥초코'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 2),
-- coffee_023: 사운즈 라떼를위한 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '사운즈 라떼를위한 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 1),
-- coffee_024: 블루보틀 밸런스
((SELECT id FROM public.coffee_beans WHERE name = '블루보틀 밸런스'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 1),
((SELECT id FROM public.coffee_beans WHERE name = '블루보틀 밸런스'), 'Fruity', 'Citrus fruit', 'Lemon', 2),
-- coffee_025: 나무사이로 풍요로운 땅
((SELECT id FROM public.coffee_beans WHERE name = '나무사이로 풍요로운 땅'), 'Nutty_Cocoa', 'Nutty', 'Peanuts', 1),
((SELECT id FROM public.coffee_beans WHERE name = '나무사이로 풍요로운 땅'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 2),
((SELECT id FROM public.coffee_beans WHERE name = '나무사이로 풍요로운 땅'), 'Fruity', 'Citrus fruit', 'Lemon', 3),
-- coffee_026: 로우키 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '로우키 블렌드'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 1),
((SELECT id FROM public.coffee_beans WHERE name = '로우키 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 2),
-- coffee_027: 델문도 에디오피아 케라모
((SELECT id FROM public.coffee_beans WHERE name = '델문도 에디오피아 케라모'), 'Fruity', 'Berry', 'Berry', 1),
-- coffee_028: 테라로사 과테말라 우에우에
((SELECT id FROM public.coffee_beans WHERE name = '테라로사 과테말라 우에우에'), 'Fruity', 'Dried fruit', 'Prune', 1),
((SELECT id FROM public.coffee_beans WHERE name = '테라로사 과테말라 우에우에'), 'Nutty_Cocoa', 'Nutty', 'Pistachio', 2),
((SELECT id FROM public.coffee_beans WHERE name = '테라로사 과테말라 우에우에'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 3),
-- coffee_029: 로엘 켈리포니아 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '로엘 켈리포니아 블렌드'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '로엘 켈리포니아 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 2),
((SELECT id FROM public.coffee_beans WHERE name = '로엘 켈리포니아 블렌드'), 'Nutty_Cocoa', 'Nutty', 'Almond', 3),
-- coffee_030: 빈오너스 아란치오 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '빈오너스 아란치오 블렌드'), 'Fruity', 'Citrus fruit', 'Orange', 1),
((SELECT id FROM public.coffee_beans WHERE name = '빈오너스 아란치오 블렌드'), 'Fruity', 'Other fruit', 'Pineapple', 2),
-- coffee_031: 컬트 커피랩 브라질 스페셜티
((SELECT id FROM public.coffee_beans WHERE name = '컬트 커피랩 브라질 스페셜티'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 1),
((SELECT id FROM public.coffee_beans WHERE name = '컬트 커피랩 브라질 스페셜티'), 'Nutty_Cocoa', 'Nutty', 'Almond', 2),
((SELECT id FROM public.coffee_beans WHERE name = '컬트 커피랩 브라질 스페셜티'), 'Nutty_Cocoa', 'Nutty', 'Hazelnut', 3),
-- coffee_032: 오클락커피 에디오피아 구지
((SELECT id FROM public.coffee_beans WHERE name = '오클락커피 에디오피아 구지'), 'Fruity', 'Other fruit', 'Apple', 1),
-- coffee_033: 블루보틀 볼드
((SELECT id FROM public.coffee_beans WHERE name = '블루보틀 볼드'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 1),
((SELECT id FROM public.coffee_beans WHERE name = '블루보틀 볼드'), 'Nutty_Cocoa', 'Nutty', 'Hazelnut', 2),
-- coffee_034: 커피의신 하와이안 코나
((SELECT id FROM public.coffee_beans WHERE name = '커피의신 하와이안 코나'), 'Fruity', 'Citrus fruit', 'Orange', 1),
((SELECT id FROM public.coffee_beans WHERE name = '커피의신 하와이안 코나'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 2),
((SELECT id FROM public.coffee_beans WHERE name = '커피의신 하와이안 코나'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 3),
-- coffee_036: 맥널티 하와이안 코나
((SELECT id FROM public.coffee_beans WHERE name = '맥널티 하와이안 코나'), 'Fruity', 'Citrus fruit', 'Orange', 1),
((SELECT id FROM public.coffee_beans WHERE name = '맥널티 하와이안 코나'), 'Nutty_Cocoa', 'Nutty', 'Walnut', 2),
-- coffee_038: 위트러스트 콜롬비아 더블무산소
((SELECT id FROM public.coffee_beans WHERE name = '위트러스트 콜롬비아 더블무산소'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '위트러스트 콜롬비아 더블무산소'), 'Fruity', 'Berry', 'Strawberry', 2),
-- coffee_039: 일킬로커피 에디오피아 무산소
((SELECT id FROM public.coffee_beans WHERE name = '일킬로커피 에디오피아 무산소'), 'Floral', 'Black Tea', 'Black Tea', 1),
((SELECT id FROM public.coffee_beans WHERE name = '일킬로커피 에디오피아 무산소'), 'Floral', 'Floral', 'Floral', 2),
((SELECT id FROM public.coffee_beans WHERE name = '일킬로커피 에디오피아 무산소'), 'Fruity', 'Other fruit', 'Apple', 3),
((SELECT id FROM public.coffee_beans WHERE name = '일킬로커피 에디오피아 무산소'), 'Fruity', 'Citrus fruit', 'Lemon', 4),
-- coffee_040: JMD 에디오피아 첼바
((SELECT id FROM public.coffee_beans WHERE name = 'JMD 에디오피아 첼바'), 'Fruity', 'Other fruit', 'Grape', 1),
((SELECT id FROM public.coffee_beans WHERE name = 'JMD 에디오피아 첼바'), 'Fruity', 'Berry', 'Strawberry', 2),
((SELECT id FROM public.coffee_beans WHERE name = 'JMD 에디오피아 첼바'), 'Fruity', 'Other fruit', 'Apple', 3),
-- coffee_041: ACR 메리제인 블렌딩
((SELECT id FROM public.coffee_beans WHERE name = 'ACR 메리제인 블렌딩'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = 'ACR 메리제인 블렌딩'), 'Fruity', 'Dried fruit', 'Prune', 2),
-- coffee_043: 올인커피 케냐 포도봉봉 (가향)
((SELECT id FROM public.coffee_beans WHERE name = '올인커피 케냐 포도봉봉 (가향)'), 'Fruity', 'Citrus fruit', 'Grapefruit', 1),
-- coffee_044: 훔볼트 피오네르 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '훔볼트 피오네르 블렌드'), 'Floral', 'Black Tea', 'Black Tea', 1),
((SELECT id FROM public.coffee_beans WHERE name = '훔볼트 피오네르 블렌드'), 'Fruity', 'Other fruit', 'Peach', 2),
((SELECT id FROM public.coffee_beans WHERE name = '훔볼트 피오네르 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 3),
-- coffee_045: 사운즈커피 복숭아 케냐 (가향)
((SELECT id FROM public.coffee_beans WHERE name = '사운즈커피 복숭아 케냐 (가향)'), 'Fruity', 'Other fruit', 'Peach', 1),
-- coffee_047: 블랙빈스 헤이즐넛향 커피
((SELECT id FROM public.coffee_beans WHERE name = '블랙빈스 헤이즐넛향 커피'), 'Nutty_Cocoa', 'Nutty', 'Hazelnut', 1),
((SELECT id FROM public.coffee_beans WHERE name = '블랙빈스 헤이즐넛향 커피'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 2),
-- coffee_049: 프릳츠 올드독 블랜딩
((SELECT id FROM public.coffee_beans WHERE name = '프릳츠 올드독 블랜딩'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 1),
-- coffee_051: 온니컵 풀블랙 블렌딩
((SELECT id FROM public.coffee_beans WHERE name = '온니컵 풀블랙 블렌딩'), 'Nutty_Cocoa', 'Nutty', 'Nutty', 1),
-- coffee_052: 딥블루레이크 온두라스 로스피노스
((SELECT id FROM public.coffee_beans WHERE name = '딥블루레이크 온두라스 로스피노스'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '딥블루레이크 온두라스 로스피노스'), 'Fruity', 'Other fruit', 'Lychee', 2),
-- coffee_053: 필아웃 엘살바도르 산안드레스
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 엘살바도르 산안드레스'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 엘살바도르 산안드레스'), 'Fruity', 'Dried fruit', 'Prune', 2),
-- coffee_054: 필아웃 시나몬게이트 (가향)
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 시나몬게이트 (가향)'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 1),
-- coffee_055: 필아웃 에디오피아 타미루 알로 무산소
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 에디오피아 타미루 알로 무산소'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 에디오피아 타미루 알로 무산소'), 'Fruity', 'Berry', 'Berry', 2),
-- coffee_056: 필아웃 플로럴게이트 (가향)
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 플로럴게이트 (가향)'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = '필아웃 플로럴게이트 (가향)'), 'Fruity', 'Citrus fruit', 'Lemon', 2),
-- coffee_057: 엘커피 코스타리카 엘사르 데 사르세로
((SELECT id FROM public.coffee_beans WHERE name = '엘커피 코스타리카 엘사르 데 사르세로'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '엘커피 코스타리카 엘사르 데 사르세로'), 'Fruity', 'Citrus fruit', 'Orange', 2),
-- coffee_058: 엘커피 에디오피아 벤사 게메초 내추럴
((SELECT id FROM public.coffee_beans WHERE name = '엘커피 에디오피아 벤사 게메초 내추럴'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '엘커피 에디오피아 벤사 게메초 내추럴'), 'Fruity', 'Other fruit', 'Peach', 2),
-- coffee_059: 엘커피 온두라스 파카마라
((SELECT id FROM public.coffee_beans WHERE name = '엘커피 온두라스 파카마라'), 'Fruity', 'Dried fruit', 'Prune', 1),
-- coffee_060: 180로스터리 인도네시아 쁘가싱 (가향)
((SELECT id FROM public.coffee_beans WHERE name = '180로스터리 인도네시아 쁘가싱 (가향)'), 'Fruity', 'Citrus fruit', 'Orange', 1),
((SELECT id FROM public.coffee_beans WHERE name = '180로스터리 인도네시아 쁘가싱 (가향)'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 2),
-- coffee_061: 180로스터리 코스타리카 벨라비스타
((SELECT id FROM public.coffee_beans WHERE name = '180로스터리 코스타리카 벨라비스타'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '180로스터리 코스타리카 벨라비스타'), 'Fruity', 'Berry', 'Strawberry', 2),
-- coffee_063: 모모스 에콰도르 CVM
((SELECT id FROM public.coffee_beans WHERE name = '모모스 에콰도르 CVM'), 'Fruity', 'Citrus fruit', 'Orange', 1),
-- coffee_065: 모모스 코스타리카 수바마
((SELECT id FROM public.coffee_beans WHERE name = '모모스 코스타리카 수바마'), 'Nutty_Cocoa', 'Nutty', 'Hazelnut', 1),
-- coffee_066: 아이덴티티 에디오피아 바샤 베켈레
((SELECT id FROM public.coffee_beans WHERE name = '아이덴티티 에디오피아 바샤 베켈레'), 'Floral', 'Floral', 'Lavender', 1),
((SELECT id FROM public.coffee_beans WHERE name = '아이덴티티 에디오피아 바샤 베켈레'), 'Fruity', 'Other fruit', 'Peach', 2),
((SELECT id FROM public.coffee_beans WHERE name = '아이덴티티 에디오피아 바샤 베켈레'), 'Fruity', 'Berry', 'Strawberry', 3),
-- coffee_067: 아이덴티티 온두라스 엘라우렐
((SELECT id FROM public.coffee_beans WHERE name = '아이덴티티 온두라스 엘라우렐'), 'Nutty_Cocoa', 'Nutty', 'Walnut', 1),
-- coffee_068: 레쉬커피 미드나잇 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '레쉬커피 미드나잇 블렌드'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '레쉬커피 미드나잇 블렌드'), 'Fruity', 'Other fruit', 'Peach', 2),
-- coffee_069: 레쉬커피 체리밤 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '레쉬커피 체리밤 블렌드'), 'Floral', 'Floral', 'Cherry Blossom', 1),
((SELECT id FROM public.coffee_beans WHERE name = '레쉬커피 체리밤 블렌드'), 'Fruity', 'Berry', 'Strawberry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '레쉬커피 체리밤 블렌드'), 'Fruity', 'Other fruit', 'Cherry', 3),
-- coffee_071: UFO 브라질
((SELECT id FROM public.coffee_beans WHERE name = 'UFO 브라질'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = 'UFO 브라질'), 'Fruity', 'Other fruit', 'Cherry', 2),
-- coffee_072: UFO 콜롬비아 게이샤
((SELECT id FROM public.coffee_beans WHERE name = 'UFO 콜롬비아 게이샤'), 'Fruity', 'Other fruit', 'Grape', 1),
((SELECT id FROM public.coffee_beans WHERE name = 'UFO 콜롬비아 게이샤'), 'Fruity', 'Citrus fruit', 'Lemon', 2),
-- coffee_073: 1%커피 예가체프 아리차
((SELECT id FROM public.coffee_beans WHERE name = '1%커피 예가체프 아리차'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '1%커피 예가체프 아리차'), 'Fruity', 'Berry', 'Strawberry', 2),
-- coffee_074: 킨온커피 에디오피아 넨센보
((SELECT id FROM public.coffee_beans WHERE name = '킨온커피 에디오피아 넨센보'), 'Floral', 'Black Tea', 'Earl Grey', 1),
-- coffee_075: 킨온커피 에디오피아 니구세 몰케
((SELECT id FROM public.coffee_beans WHERE name = '킨온커피 에디오피아 니구세 몰케'), 'Fruity', 'Citrus fruit', 'Lemon', 1),
((SELECT id FROM public.coffee_beans WHERE name = '킨온커피 에디오피아 니구세 몰케'), 'Fruity', 'Dried fruit', 'Prune', 2),
-- coffee_076: 언더빈 케냐 니에리 키와와무루루
((SELECT id FROM public.coffee_beans WHERE name = '언더빈 케냐 니에리 키와와무루루'), 'Fruity', 'Berry', 'Berry', 1),
-- coffee_077: 언더빈 엘살바도르 산타로사 파카마라허니
((SELECT id FROM public.coffee_beans WHERE name = '언더빈 엘살바도르 산타로사 파카마라허니'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = '언더빈 엘살바도르 산타로사 파카마라허니'), 'Fruity', 'Other fruit', 'Peach', 2),
-- coffee_078: 언더빈 온두라스 엘네그로 파라이네마
((SELECT id FROM public.coffee_beans WHERE name = '언더빈 온두라스 엘네그로 파라이네마'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '언더빈 온두라스 엘네그로 파라이네마'), 'Fruity', 'Berry', 'Strawberry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '언더빈 온두라스 엘네그로 파라이네마'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 3),
-- coffee_079: 히치커피 엘파라이소 리치피치
((SELECT id FROM public.coffee_beans WHERE name = '히치커피 엘파라이소 리치피치'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '히치커피 엘파라이소 리치피치'), 'Fruity', 'Other fruit', 'Lychee', 2),
((SELECT id FROM public.coffee_beans WHERE name = '히치커피 엘파라이소 리치피치'), 'Fruity', 'Other fruit', 'Pineapple', 3),
-- coffee_081: 빕커피 콜롬비아 세로아줄 게이샤
((SELECT id FROM public.coffee_beans WHERE name = '빕커피 콜롬비아 세로아줄 게이샤'), 'Fruity', 'Berry', 'Strawberry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '빕커피 콜롬비아 세로아줄 게이샤'), 'Fruity', 'Other fruit', 'Cherry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '빕커피 콜롬비아 세로아줄 게이샤'), 'Fruity', 'Other fruit', 'Mango', 3),
-- coffee_082: 디포인트커피 코스타리카 돈마요엘 (가향)
((SELECT id FROM public.coffee_beans WHERE name = '디포인트커피 코스타리카 돈마요엘 (가향)'), 'Fruity', 'Other fruit', 'Apple', 1),
((SELECT id FROM public.coffee_beans WHERE name = '디포인트커피 코스타리카 돈마요엘 (가향)'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 2),
-- coffee_083: 디포인트커피 과테말라 쿠프 아그리코라
((SELECT id FROM public.coffee_beans WHERE name = '디포인트커피 과테말라 쿠프 아그리코라'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '디포인트커피 과테말라 쿠프 아그리코라'), 'Fruity', 'Dried fruit', 'Prune', 2),
((SELECT id FROM public.coffee_beans WHERE name = '디포인트커피 과테말라 쿠프 아그리코라'), 'Fruity', 'Other fruit', 'Cherry', 3),
((SELECT id FROM public.coffee_beans WHERE name = '디포인트커피 과테말라 쿠프 아그리코라'), 'Fruity', 'Berry', 'Cranberry', 4),
-- coffee_084: 디콰이엇 소프트엠버 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '디콰이엇 소프트엠버 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 1),
((SELECT id FROM public.coffee_beans WHERE name = '디콰이엇 소프트엠버 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 2),
-- coffee_085: 디콰이엇 문라이트 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '디콰이엇 문라이트 블렌드'), 'Floral', 'Floral', 'Lavender', 1),
((SELECT id FROM public.coffee_beans WHERE name = '디콰이엇 문라이트 블렌드'), 'Fruity', 'Berry', 'Berry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '디콰이엇 문라이트 블렌드'), 'Fruity', 'Citrus fruit', 'Orange', 3),
((SELECT id FROM public.coffee_beans WHERE name = '디콰이엇 문라이트 블렌드'), 'Nutty_Cocoa', 'Cocoa', 'Chocolate', 4),
-- coffee_086: 얼터커피 코스타리카 로스유칼립토스 게이샤
((SELECT id FROM public.coffee_beans WHERE name = '얼터커피 코스타리카 로스유칼립토스 게이샤'), 'Fruity', 'Citrus fruit', 'Orange', 1),
-- coffee_087: 얼터커피 시다모 벤사 코코세
((SELECT id FROM public.coffee_beans WHERE name = '얼터커피 시다모 벤사 코코세'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = '얼터커피 시다모 벤사 코코세'), 'Fruity', 'Berry', 'Strawberry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '얼터커피 시다모 벤사 코코세'), 'Fruity', 'Other fruit', 'Pineapple', 3),
((SELECT id FROM public.coffee_beans WHERE name = '얼터커피 시다모 벤사 코코세'), 'Fruity', 'Citrus fruit', 'Orange', 4),
-- coffee_088: 오멜라스 과테말라 알로테낭고 카우일
((SELECT id FROM public.coffee_beans WHERE name = '오멜라스 과테말라 알로테낭고 카우일'), 'Fruity', 'Berry', 'Berry', 1),
((SELECT id FROM public.coffee_beans WHERE name = '오멜라스 과테말라 알로테낭고 카우일'), 'Fruity', 'Dried fruit', 'Prune', 2),
-- coffee_089: 오멜라스 브라질 세하도
((SELECT id FROM public.coffee_beans WHERE name = '오멜라스 브라질 세하도'), 'Nutty_Cocoa', 'Nutty', 'Almond', 1),
((SELECT id FROM public.coffee_beans WHERE name = '오멜라스 브라질 세하도'), 'Nutty_Cocoa', 'Cocoa', 'Cocoa', 2),
-- coffee_090: 몰리프 스트로베리 핑크 블렌드
((SELECT id FROM public.coffee_beans WHERE name = '몰리프 스트로베리 핑크 블렌드'), 'Fruity', 'Other fruit', 'Peach', 1),
((SELECT id FROM public.coffee_beans WHERE name = '몰리프 스트로베리 핑크 블렌드'), 'Fruity', 'Berry', 'Strawberry', 2),
-- coffee_091: 아우라 콜롬비아 레몬그라스 무산소
((SELECT id FROM public.coffee_beans WHERE name = '아우라 콜롬비아 레몬그라스 무산소'), 'Fruity', 'Citrus fruit', 'Lemon', 1),
((SELECT id FROM public.coffee_beans WHERE name = '아우라 콜롬비아 레몬그라스 무산소'), 'Fruity', 'Other fruit', 'Lychee', 2),
-- coffee_092: 아우라 케냐 록번 니에리
((SELECT id FROM public.coffee_beans WHERE name = '아우라 케냐 록번 니에리'), 'Fruity', 'Dried fruit', 'Prune', 1),
-- coffee_093: 원세컨즈 에디오피아 구지 사키소
((SELECT id FROM public.coffee_beans WHERE name = '원세컨즈 에디오피아 구지 사키소'), 'Floral', 'Floral', 'Rose', 1),
((SELECT id FROM public.coffee_beans WHERE name = '원세컨즈 에디오피아 구지 사키소'), 'Fruity', 'Berry', 'Strawberry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '원세컨즈 에디오피아 구지 사키소'), 'Fruity', 'Other fruit', 'Cherry', 3),
-- coffee_094: 커피멜로우 과테말라 엘인헤르또 게이샤
((SELECT id FROM public.coffee_beans WHERE name = '커피멜로우 과테말라 엘인헤르또 게이샤'), 'Floral', 'Floral', 'Floral', 1),
((SELECT id FROM public.coffee_beans WHERE name = '커피멜로우 과테말라 엘인헤르또 게이샤'), 'Fruity', 'Citrus fruit', 'Orange', 2),
((SELECT id FROM public.coffee_beans WHERE name = '커피멜로우 과테말라 엘인헤르또 게이샤'), 'Fruity', 'Citrus fruit', 'Lemon', 3),
-- coffee_095: 커피멜로우 과테말라 엘 소코로
((SELECT id FROM public.coffee_beans WHERE name = '커피멜로우 과테말라 엘 소코로'), 'Fruity', 'Citrus fruit', 'Orange', 1),
((SELECT id FROM public.coffee_beans WHERE name = '커피멜로우 과테말라 엘 소코로'), 'Nutty_Cocoa', 'Nutty', 'Hazelnut', 2),
-- coffee_096: JNBean 인도네시아 만델링
((SELECT id FROM public.coffee_beans WHERE name = 'JNBean 인도네시아 만델링'), 'Nutty_Cocoa', 'Cocoa', 'Dark chocolate', 1),
((SELECT id FROM public.coffee_beans WHERE name = 'JNBean 인도네시아 만델링'), 'Nutty_Cocoa', 'Nutty', 'Cashew', 2),
((SELECT id FROM public.coffee_beans WHERE name = 'JNBean 인도네시아 만델링'), 'Nutty_Cocoa', 'Nutty', 'Almond', 3),
-- coffee_097: 러스브루어스 니카라과 핀카 리브레
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 니카라과 핀카 리브레'), 'Floral', 'Floral', 'Jasmine', 1),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 니카라과 핀카 리브레'), 'Floral', 'Black Tea', 'Earl Grey', 2),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 니카라과 핀카 리브레'), 'Fruity', 'Other fruit', 'Grape', 3),
-- coffee_098: 러스브루어스 페루 로스 산토스
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 페루 로스 산토스'), 'Floral', 'Floral', 'Rose', 1),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 페루 로스 산토스'), 'Fruity', 'Berry', 'Berry', 2),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 페루 로스 산토스'), 'Fruity', 'Other fruit', 'Pineapple', 3),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 페루 로스 산토스'), 'Fruity', 'Berry', 'Cranberry', 4),
-- coffee_099: 러스브루어스 파나마 알토밤비토
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 파나마 알토밤비토'), 'Fruity', 'Other fruit', 'Grape', 1),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 파나마 알토밤비토'), 'Fruity', 'Other fruit', 'Mango', 2),
((SELECT id FROM public.coffee_beans WHERE name = '러스브루어스 파나마 알토밤비토'), 'Fruity', 'Dried fruit', 'Raisin', 3)
ON CONFLICT DO NOTHING;
