part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = '/';
  static const app = '/app';
  static const home = '/home';
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

  //product related
  static const product = '/product';
  static const productDetail = '/product/product-detail';
  static const submitReview = '/product/submit-review';
  static const viewedTogether = '/product/viewed-together';
  static const recommendedProduct = '/product/recommend-product';

  ///home tabs first
  static const homeMain = '/home/main';

  ///home tabs second
  static const homeSecond = '/home/special-price';
  static const collection = '/home/special-price/collection';

  ///home tabs third
  static const homeThird = '/home/best';

  ///home tabs fourth
  static const homefourth = '/home/new';

  ///pages in home tab main
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

  ///pages in market tab
  static const marketCategory = '/market/market-category';  // Not Used
  static const thirdCategory = '/market/third-category';    // Not Used

  static const marketSecondCategory = '/market/second-category';  // 마켓 상단 카테고리 메뉴
  static const marketPopularCategory = '/market/market-popular_category';   // third-category
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

  ///pages in search tab
  static const searchThirdCategory = '/search/third-category';  // 검색 카테고리

  //pages in inbox
  static const notiDelete = '/inbox/noti-delete';
  static const talkDelete = '/inbox/talk-delete';

  ///pages in mypage
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

  ///pages related order
  static const cancelStep = '/order/cancel/cancel-step';
  static const cancelSubmit = '/order/cancel/cancel-submit';
  static const cancelComplete = '/order/cancel/cancel-complete';
  static const purchaseOption = '/order/purchase-option';
  static const payment = '/order/payment';
  static const orderComplete = '/order/order-complete';

  ///pages related search-keyword
  static const searchResult = '/search-keyword/search-result';

  ///pages related address
  static const manageAddress = '/address/manage-address';
  static const addAddress = '/address/add-address';

  // tae: COMP_로그인
  ///pages related login
  static const signIn = '/login/sign-in';
  static const emailSignUp = '/login/email-sign-up';
  static const emailSignIn = '/login/email-sign-in';
  static const chagePwd = '/login/change-password';

  ///pages related toss payments api
  static const payment_success = '/toss/success';
  static const payment_fail = '/toss/fail';
}
