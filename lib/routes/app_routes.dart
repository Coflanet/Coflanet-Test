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
  static const survey = '/onboarding/survey'; // With :step parameter
  static const surveyAnalyzing = '/onboarding/survey-analyzing';
  static const surveyComplete = '/onboarding/survey-complete';
  static const surveyResult = '/onboarding/survey-result';
  static const onboardingComplete = '/onboarding/complete';

  // === Matching Routes ===
  static const matchingResult = '/matching/result';

  // === Profile Routes (New) ===
  static const myTaste = '/profile/my-taste';

  // === Planet Routes ===
  static const myPlanet = '/my-planet';

  // === Coffee Routes ===
  static const coffeeMain = '/coffee';
  static const handDrip = '/coffee/hand-drip';
  static const espresso = '/coffee/espresso';
  static const coffeeSettings = '/coffee/settings';
  static const coffeeSettingDetail = '/coffee/settings/detail';
  static const timerActive = '/coffee/timer';
  static const timerComplete = '/coffee/timer/complete';

  // === Auth (Additional) ===
  static const emailSignUp = '/login/email-sign-up';
}
