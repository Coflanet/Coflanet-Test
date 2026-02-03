/// Asset path constants for the Coflanet app
class AssetPath {
  AssetPath._();

  // Base paths
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';

  // === Logo ===
  static const String logoMain = '$_images/logo_main.png';
  static const String logoWhite = '$_images/logo_white.png';
  static const String logoSplash = '$_images/logo_splash.png';

  // === Onboarding ===
  static const String onboardingWelcome = '$_images/onboarding_welcome.png';
  static const String onboardingComplete = '$_images/onboarding_complete.png';
  static const String onboardingAnalyzing = '$_images/onboarding_analyzing.png';

  // === Survey Result ===
  static const String surveyResultBg = '$_images/survey_result_bg.png';
  static const String coffeeTypeAcidic = '$_images/coffee_type_acidic.png';
  static const String coffeeTypeBalance = '$_images/coffee_type_balance.png';
  static const String coffeeTypeBitter = '$_images/coffee_type_bitter.png';
  static const String coffeeTypeSweet = '$_images/coffee_type_sweet.png';

  // === Coffee ===
  static const String coffeeHandDrip = '$_images/coffee_hand_drip.png';
  static const String coffeeEspresso = '$_images/coffee_espresso.png';
  static const String coffeeMokapot = '$_images/coffee_mokapot.png';

  // === Icons ===
  static const String iconArrowBack = '$_icons/ic_arrow_back.svg';
  static const String iconArrowForward = '$_icons/ic_arrow_forward.svg';
  static const String iconClose = '$_icons/ic_close.svg';
  static const String iconCheck = '$_icons/ic_check.svg';
  static const String iconCheckCircle = '$_icons/ic_check_circle.svg';
  static const String iconHome = '$_icons/ic_home.svg';
  static const String iconCoffee = '$_icons/ic_coffee.svg';
  static const String iconProfile = '$_icons/ic_profile.svg';
  static const String iconSettings = '$_icons/ic_settings.svg';
  static const String iconTimer = '$_icons/ic_timer.svg';

  // === Social Login Icons ===
  static const String iconKakao = '$_icons/ic_kakao.svg';
  static const String iconNaver = '$_icons/ic_naver.svg';
  static const String iconApple = '$_icons/ic_apple.svg';

  // === Collection Images (Legacy) ===
  static const String imgCollectionBuyAgain = '$_images/collection_buy_again.png';
}

// Legacy export for backward compatibility
const String imgCollectionBuyAgain = AssetPath.imgCollectionBuyAgain;
