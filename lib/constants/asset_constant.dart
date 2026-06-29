/// Asset path constants for the Coflanet app
class AssetPath {
  AssetPath._();

  // Base paths
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';

  // === Logo ===
  static const String logoMain = '$_images/logo_main.png';
  static const String logoSplash = '$_images/logo_splash.png';

  // === Signup Completion ===
  static const String completionClappingHands = '$_images/clapping_hands.png';

  // === Character Illustrations ===
  static const String charFront = '$_images/char_front.png';
  static const String charSitting = '$_images/char_sitting.png';
  static const String charGift = '$_images/char_gift.png';
  static const String charDrinkCoffee = '$_images/char_drink_coffee.png';

  // === Aroma/Flavor Icons ===
  static const String aromaFruit = '$_images/aroma_fruit.png';
  static const String aromaFlower = '$_images/aroma_flower.png';
  static const String aromaNutChoco = '$_images/aroma_nut_choco.png';
  static const String aromaRoasting = '$_images/aroma_roasting.png';

  // === Coffee ===
  static const String coffeeHandDrip = '$_images/coffee_hand_drip.png';
  static const String coffeeEspresso = '$_images/coffee_espresso.png';

  // === Survey Intro Icons ===
  static const String emojiCoffee = '$_images/emoji_coffee.png';
  static const String emojiBeach = '$_images/emoji_beach.png';

  // === Timer Step Illustrations ===
  static const String timerStepGrinder = '$_images/timer_step01_grinder.png';
  static const String timerStepPourover = '$_images/timer_step02_pourover.png';
  static const String timerStepBloom = '$_images/timer_step03_bloom.png';
  static const String timerStepPour1 = '$_images/timer_step04_pour1.png';
  // 주: timer_step05_pour2(2차 추출)는 이미지 미확보 — 이모지 폴백 유지.
  static const String timerStepDrawdown = '$_images/timer_step06_drawdown.png';
  static const String timerStepEspressoShot =
      '$_images/timer_step_espresso_shot.png';

  // === 추출 기구(설문) ===
  static const String equipEspressoMachine =
      '$_images/equip_espresso_machine.png';
  static const String equipAutoMachine = '$_images/equip_auto_machine.png';
  static const String equipHandDrip = '$_images/equip_handdrip.png';
  // 주: equip_capsule(캡슐 머신)은 이미지 미확보 — 아이콘 폴백 유지.
  static const String equipColdBrew = '$_images/equip_coldbrew.png';

  // === 기본/폴백 · 빈 상태 ===
  static const String beanDefault = '$_images/bean_default.png';
  static const String bannerDefault = '$_images/banner_default.png';
  static const String emptyBeans = '$_images/empty_beans.png';
  static const String emptyRecommend = '$_images/empty_recommend.png';
  static const String emptyRecords = '$_images/empty_records.png';
  // 주: empty_search(검색 결과 없음)는 이미지 미확보 — 아이콘 폴백 유지.

  // === Icons ===
  static const String iconArrowBack = '$_icons/ic_arrow_back.svg';
  static const String iconArrowForward = '$_icons/ic_arrow_forward.svg';
  static const String iconClose = '$_icons/ic_close.svg';
  static const String iconCheck = '$_icons/ic_check.svg';
  static const String iconSettings = '$_icons/ic_settings.svg';

  // === Social Login Icons ===
  static const String iconKakao = '$_icons/ic_kakao.svg';
  static const String iconNaver = '$_icons/ic_naver.svg';
  static const String iconApple = '$_icons/ic_apple.svg';
}
