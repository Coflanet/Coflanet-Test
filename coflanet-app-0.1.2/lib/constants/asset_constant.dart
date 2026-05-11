/// Asset path constants for the Coflanet app
class AssetPath {
  AssetPath._();

  // Base paths
  static const String _images = 'assets/images';

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

  // === Icons ===
  // 아이콘은 모두 component_lab 디자인 시스템 패키지로 마이그레이션 완료.
  // `import 'package:component_lab/component_lab.dart';` 후
  // `SvgPicture.asset(CoflanetIcons.arrowLeft, package: 'component_lab')` 형태로 사용.
}
