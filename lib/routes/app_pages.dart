import 'package:get/get.dart';
import 'package:coflanet/app.dart';
import 'package:coflanet/app_binding.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/controllers/cart/cart_controller.dart';
import 'package:coflanet/controllers/cart/mypage/order_list_controller.dart';
import 'package:coflanet/controllers/home/main/menu/popular_product_controller.dart';
import 'package:coflanet/controllers/item_filter/item_filter_controller_binding.dart';
import 'package:coflanet/controllers/mypage/mypage_controller.dart';
import 'package:coflanet/controllers/product/purchase_option_controller.dart';
import 'package:coflanet/controllers/review/product_review_controller.dart';
import 'package:coflanet/controllers/search/search_keyword_controller.dart';
import 'package:coflanet/controllers/search/search_result_controller.dart';
import 'package:coflanet/controllers/store/store_controller.dart';
import 'package:coflanet/controllers/stream/video/stream_controller.dart';
import 'package:coflanet/controllers/mypage/watch_list_controller.dart';
import 'package:coflanet/splash_screen.dart';
import 'package:coflanet/views/cart/cart_view.dart';
import 'package:coflanet/views/home/home_binding.dart';
import 'package:coflanet/views/home/home_view.dart';
import 'package:coflanet/views/home/preorder/preorder_main_view.dart';
import 'package:coflanet/views/home/tabs/main/banner_detail_view.dart';
import 'package:coflanet/views/home/tabs/main/menu/popular_product_view.dart';
import 'package:coflanet/views/inbox/tabs/inbox_noti_delete.dart';
import 'package:coflanet/views/inbox/tabs/inbox_talk_delete.dart';
import 'package:coflanet/views/item_filter/item_filter_view.dart';
import 'package:coflanet/views/login/figma/sign_in_view.dart';
import 'package:coflanet/views/market/market_category_view.dart';
import 'package:coflanet/views/market/market_view.dart';
import 'package:coflanet/views/mypage/alarm_edit_view.dart';
import 'package:coflanet/views/mypage/cancel/cancel_complete_view.dart';
import 'package:coflanet/views/mypage/cancel/cancel_step_view.dart';
import 'package:coflanet/views/mypage/cancel/cancel_submit_view.dart';
import 'package:coflanet/views/mypage/cancel_return_view.dart';
import 'package:coflanet/views/mypage/mypage_setting_view.dart';
import 'package:coflanet/views/mypage/coupon_list_view.dart';
import 'package:coflanet/views/mypage/faq_list_view.dart';
import 'package:coflanet/views/mypage/customer_service_view.dart';
import 'package:coflanet/views/mypage/point_list_view.dart';
import 'package:coflanet/views/mypage/order_detail_view.dart';
import 'package:coflanet/views/mypage/order_list_view.dart';
import 'package:coflanet/views/mypage/profile_view.dart';
import 'package:coflanet/views/mypage/watch_list_view.dart';
import 'package:coflanet/views/store/store_view.dart';
import 'package:coflanet/views/payment/payment_view.dart';
import 'package:coflanet/views/product/product_detail_view.dart';
import 'package:coflanet/views/product/purchase_option_view.dart';
import 'package:coflanet/views/product/submit_review_view.dart';
import 'package:coflanet/views/search/search_view.dart';
import 'package:coflanet/views/inbox/inbox_view.dart';
import 'package:coflanet/views/stream/main/stream_view.dart';
import 'package:coflanet/views/mypage/mypage_view.dart';
import 'package:coflanet/views/search_keyword/search_keyword_view.dart';
import 'package:coflanet/views/search_keyword/search_result_view.dart';
import 'package:coflanet/widgets/mypage/delivery/manage_address_view.dart';
import 'package:coflanet/widgets/mypage/profile/profile_edit_view.dart';

import '../views/payment/order_complete_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.app,
      page: () => App(),
      binding: AppBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.market,
      page: () => const MarketView(),
    ),
    GetPage(
      name: Routes.search,
      page: () => SearchView(),
    ),
    GetPage(
      name: Routes.inbox,
      page: () => InboxView(),
    ),

    /// my page
    GetPage(
      name: Routes.stream,
      page: () => StreamView(),
      binding: BindingsBuilder(
        () => Get.lazyPut<StreamController>(
          () => StreamController(),
        ),
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
        name: Routes.mypage,
        page: () => MypageView(),
        binding: BindingsBuilder(
          () => Get.lazyPut(() => MypageController()),
        )),
    GetPage(
      name: Routes.cart,
      page: () => CartView(),
      binding: BindingsBuilder(
        () => Get.lazyPut<CartController>(
          () => CartController(),
        ),
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
        name: Routes.searchKeyword,
        page: () => const SearchKeywordView(),
        binding: BindingsBuilder(
          () => Get.lazyPut(() => SearchKeywordController()),
        )),
    GetPage(
      name: Routes.productDetail,
      page: () => ProductDetailView(
        product: Get.arguments?['product'],
        isSearch: Get.arguments?['isSearch'],
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.mySetting,
      page: () => MypageSettingView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.couponList,
      page: () => CouponListView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.faqList,
      page: () => FaqListView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.customerService,
      page: () => CustomerServiceView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.pointList,
      page: () => PointListView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.store,
      page: () => StoreView(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut<StoreController>(() => StoreController(
              storeCode: Get.arguments?['storeCode']),
              tag: Get.arguments?['storeCode']);
          ItemFilterControllerBinding();
          Get.lazyPut<ProductReviewController>(() => ProductReviewController());
        },
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.myOrderList,
      page: () => const OrderListView(),
      binding: BindingsBuilder(
        () => Get.lazyPut<OrderListController>(
          () => OrderListController(),
        ),
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.myWatchList,
      page: () => const WatchListView(),
      binding: BindingsBuilder(
        () => Get.lazyPut<WatchListController>(
          () => WatchListController()),
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.myCancelReturn,
      page: () => const CancelReturnView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.mypageFrequentPurchase,
      page: () => ItemFilterView(
        title: '자주 구매한 상품',
        appbarImg: imgCollectionBuyAgain,
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    /// my page

    /// --------------- home_tab_main ---------------
    /// home_tab_main: horizontal menu bar
    GetPage(
      name: Routes.overnightDelivery,
      page: () => ItemFilterView(
        title: '하루배송',
        appbarImg: imgCollectionBuyAgain,
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.todayDeal,
      page: () => ItemFilterView(
        title: '오늘의 딜',
        appbarImg: imgCollectionBuyAgain,
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.directDelivery,
      page: () => ItemFilterView(
        title: '산지직송',
        appbarImg: imgCollectionBuyAgain,
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.popularProduct,
      page: () => PopularProductView(),
      bindings: [
        BindingsBuilder(() => Get.lazyPut<PopularProductController>(
              () => PopularProductController(),
        )),
        ItemFilterControllerBinding()
      ],
      transition: Transition.cupertino,
    ),
    /// home_tab_main: horizontal menu bar

    /// home_tab_main: live collection
    GetPage(
      name: Routes.overnightBrandnew,
      page: () => ItemFilterView(
        title: '하루배송 가능 신상품',
      ),
      binding: ItemFilterControllerBinding(),
    ),
    GetPage(
      name: Routes.homeFrequentPurchase,
      page: () => ItemFilterView(
        title: '자주 구매한 상품',
        appbarImg: imgCollectionBuyAgain,
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.recentProduce,
      page: () => ItemFilterView(
        title: '최근 구매한 \'농산물\'BEST 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.twoWeeksBestProducts,
      page: () => ItemFilterView(
        title: '2주간 반응 좋은 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.homeCurrentHot,
      page: () => ItemFilterView(
        title: '지금 가장 핫한 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    /// home_tab_main: live collection
    /// --------------- home_tab_main ---------------

    /// --------------- home_tab_special_price ---------------
    GetPage(
      name: Routes.collection,
      page: () => ItemFilterView(
        title: Get.arguments['title'],
        appbarImg: imgCollectionBuyAgain,
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    /// --------------- home_tab_special_price ---------------

    /// --------------- market ---------------
    /// market: category
    GetPage(
      name: Routes.marketSecondCategory,
      page: () => ItemFilterView(
        title: '마켓 상단 카테고리 메뉴',
        isTab: true,
      ),
      binding: ItemFilterControllerBinding(isTab: true),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.marketPopularCategory,
      page: () => ItemFilterView(
        title: '인기 카테고리',
        isTab: true,
      ),
      binding: ItemFilterControllerBinding(isTab: true),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.marketMainCategory,
      page: () => ItemFilterView(
        title: '메인 카테고리',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(  // Not Used
      name: Routes.marketCategory,
      page: () => MarketCategoryView(),
      transition: Transition.cupertino,
    ),
    GetPage(  // Not Used
      name: Routes.thirdCategory,
      page: () => ItemFilterView(
        title: '귤',
        isTab: true,
      ),
      binding: ItemFilterControllerBinding(isTab: true),
      transition: Transition.cupertino,
    ),
    /// market: live collection
    GetPage(
      name: Routes.onedayDelivery,
      page: () => ItemFilterView(
        title: '24시간 이내 받을 수 있는 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.categoryRank,
      page: () => ItemFilterView(
        title: '카테고리 BEST 100',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.relatedProduct,
      page: () => ItemFilterView(
        title: '최근 본 상품과 연관 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.marketCurrentHot,
      page: () => ItemFilterView(
        title: '지금 가장 핫한 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.searchedRelatedProduct,
      page: () => ItemFilterView(
        title: '내가 찾았던 상품의 연관 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.twoWeeksBestseller,
      page: () => ItemFilterView(
        title: '2주간 가장 많이 판매된 상품',
      ),
      binding: ItemFilterControllerBinding(),
    ),
    GetPage(
      name: Routes.overThousand,
      page: () => ItemFilterView(
        title: '누적 판매량 1000개 돌파',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.directFruits,
      page: () => ItemFilterView(
        title: '산지직송 제철과일',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.reviewVerified,
      page: () => ItemFilterView(
        title: '리뷰로 검증받은 상품',
      ),
      binding: ItemFilterControllerBinding(),
      transition: Transition.cupertino,
    ),
    /// --------------- market ---------------

    /// --------------- search ---------------
    GetPage(
      name: Routes.searchThirdCategory,
      page: () => ItemFilterView(
        title: '검색 탭 카테고리',
        isTab: true,
      ),
      binding: ItemFilterControllerBinding(isTab: true),
      transition: Transition.cupertino,
    ),
    /// --------------- search ---------------

    /// --------------- product detail ---------------
    GetPage(
      name: Routes.viewedTogether,
      page: () => ItemFilterView(
        title: '다른 고객이 함께 본 상품',
      ),
      binding: ItemFilterControllerBinding(allowDuplicate: false),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.recommendedProduct,
      page: () => ItemFilterView(
        title: '이런 상품은 어떠세요?',
      ),
      binding: ItemFilterControllerBinding(allowDuplicate: false),
    ),
    /// --------------- product detail ---------------

    GetPage(
      name: Routes.orderDetail,
      page: () => const OrderDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.profileEdit,
      page: () => const ProfileEditView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.submitReview,
      page: () => const SubmitReviewView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.alarmEdit,
      page: () => const AlarmEditView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.cancelStep,
      page: () => const CancelStepView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.cancelSubmit,
      page: () => const CancelSubmitView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.cancelComplete,
      page: () => const CancelCompleteView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.bannerDetail,
      page: () => const BannerDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.purchaseOption,
      page: () => PurchaseOptionView(),
      binding: BindingsBuilder(
        () => Get.lazyPut<PurchaseOptionController>(
          () => PurchaseOptionController(),
        ),
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.payment,
      page: () => const PaymentView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.orderComplete,
      page: () => const OrderCompleteView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.notiDelete,
      page: () => const InboxNotiDelete(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.talkDelete,
      page: () => const InboxTalkDelete(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.searchResult,
      page: () => SearchResultView(
        keyword: Get.parameters['keyword']!,
      ),
      binding: BindingsBuilder(
        () => Get.lazyPut<SearchResultController>(
          () => SearchResultController(),
          tag: Get.parameters['keyword']
        ),
      ),
      transition: Transition.cupertino,
    ),

    ///pages related address
    GetPage(
      name: Routes.manageAddress,
      page: () => ManageAddressView(isManageView: Get.arguments['isManageView'] as bool,),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.signIn,
      page: () => SignInView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.preordermain,
      page: () => PreOrderMainView(),
      transition: Transition.cupertino,
    ),
  ];
}
