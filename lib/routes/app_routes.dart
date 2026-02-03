part of 'app_pages.dart';

/// App route constants
abstract class Routes {
  Routes._();

  // === Core Routes ===
  static const splash = '/';
  static const home = '/home';

  // === Auth Routes ===
  static const signIn = '/login/sign-in';

  // === Onboarding Routes ===
  static const surveyIntro = '/onboarding/survey-intro';
  static const survey = '/onboarding/survey';  // With :step parameter
  static const surveyAnalyzing = '/onboarding/survey-analyzing';
  static const surveyComplete = '/onboarding/survey-complete';
  static const surveyResult = '/onboarding/survey-result';
  static const onboardingComplete = '/onboarding/complete';

  // === Coffee Routes ===
  static const coffeeMain = '/coffee';
  static const handDrip = '/coffee/hand-drip';
  static const espresso = '/coffee/espresso';
  static const coffeeSettings = '/coffee/settings';

  // === Other Routes (Legacy - kept for compatibility) ===
  static const app = '/app';
  static const market = '/market';
  static const search = '/search';
  static const inbox = '/inbox';
  static const stream = '/stream';
  static const mypage = '/mypage';
  static const store = '/store';
  static const cart = '/cart';
  static const searchKeyword = '/search-keyword';
  static const profile = '/profile';
  static const profileEdit = '/profile/profile-edit';

  // Product related
  static const product = '/product';
  static const productDetail = '/product/product-detail';
  static const submitReview = '/product/submit-review';
  static const viewedTogether = '/product/viewed-together';
  static const recommendedProduct = '/product/recommend-product';

  // Home tabs
  static const homeMain = '/home/main';
  static const homeSecond = '/home/special-price';
  static const collection = '/home/special-price/collection';
  static const homeThird = '/home/best';
  static const homefourth = '/home/new';

  // Home menu items
  static const homeFrequentPurchase = '/home/main/frequent-purchase';
  static const overnightDelivery = '/home/main/overnight-delivery';
  static const popularProduct = '/home/main/popular-product';
  static const todayDeal = '/home/main/today-deal';
  static const directDelivery = '/home/main/direct-delivery';
  static const overnightBrandnew = '/home/main/overnight-brandnew';
  static const twoWeeksBestProducts = '/home/main/two-weeks-bestseller';
  static const homeCurrentHot = '/home/main/current-hot';
  static const recentProduce = '/home/main/recent-produce';
  static const bannerDetail = '/home/main/banner-detail';
  static const preordermain = '/home/main/preorder-main';

  // Market
  static const marketCategory = '/market/market-category';
  static const thirdCategory = '/market/third-category';
  static const marketSecondCategory = '/market/second-category';
  static const marketPopularCategory = '/market/market-popular_category';
  static const marketMainCategory = '/market/market-main-category';
  static const onedayDelivery = '/market/oneday-delivery';
  static const categoryRank = '/market/category-rank';
  static const relatedProduct = '/market/related-product';
  static const marketCurrentHot = '/market/current-hot';
  static const searchedRelatedProduct = '/market/searched-related-product';
  static const twoWeeksBestseller = '/market/two-weeks-bestseller';
  static const overThousand = '/market/over-thousand';
  static const directFruits = '/market/direct-fruits';
  static const reviewVerified = '/market/review-verified';

  // Search
  static const searchThirdCategory = '/search/third-category';

  // Inbox
  static const notiDelete = '/inbox/noti-delete';
  static const talkDelete = '/inbox/talk-delete';

  // MyPage
  static const mySetting = '/mypage/setting';
  static const couponList = '/mypage/coupon-list';
  static const faqList = '/mypage/faq-list';
  static const customerService = '/mypage/customer-service';
  static const pointList = '/mypage/point-list';
  static const myOrderList = '/mypage/order-list';
  static const myCancelReturn = '/mypage/cancel-return';
  static const myWatchList = '/mypage/watch-list';
  static const orderDetail = '/mypage/order-detail';
  static const mypageFrequentPurchase = '/mypage/frequent-purchase';
  static const alarmEdit = '/mypage/setting/alarm-edit';
  static const passwordChange = '/mypage/setting/password-change';

  // Order
  static const cancelStep = '/order/cancel/cancel-step';
  static const cancelSubmit = '/order/cancel/cancel-submit';
  static const cancelComplete = '/order/cancel/cancel-complete';
  static const purchaseOption = '/order/purchase-option';
  static const payment = '/order/payment';
  static const orderComplete = '/order/order-complete';

  // Search keyword
  static const searchResult = '/search-keyword/search-result';

  // Address
  static const manageAddress = '/address/manage-address';
  static const addAddress = '/address/add-address';

  // Login
  static const emailSignUp = '/login/email-sign-up';
  static const emailSignIn = '/login/email-sign-in';
  static const chagePwd = '/login/change-password';

  // Toss payments
  static const paymentSuccess = '/toss/success';
  static const paymentFail = '/toss/fail';
}
