part of 'app_pages.dart';

/// App route constants
abstract class Routes {
  Routes._();

  // === Core Routes ===
  static const splash = '/';

  // === Auth Routes ===
  static const signIn = '/login/sign-in';
  static const profileSetup = '/login/profile-setup';

  // === Onboarding Routes ===
  static const surveyReason = '/onboarding/survey-reason';
  static const surveyIndex = '/onboarding/survey-index';
  static const surveyIntro = '/onboarding/survey-intro';
  static const surveySectionIntro =
      '/onboarding/survey-section'; // With :section parameter
  static const survey = '/onboarding/survey'; // With :step parameter
  static const surveyAnalyzing = '/onboarding/survey-analyzing';
  static const surveyComplete = '/onboarding/survey-complete';
  static const surveyResult = '/onboarding/survey-result';

  // === Matching Routes ===
  static const matchingResult = '/matching/result';

  // === Profile Routes (New) ===
  static const myTaste = '/profile/my-taste';

  // === Planet Routes ===
  static const myPlanet = '/my-planet';

  // === Shell Routes ===
  static const mainShell = '/main-shell';

  // === Coffee Routes ===
  static const coffeeMain = '/coffee';
  static const handDrip = '/coffee/hand-drip';
  static const espresso = '/coffee/espresso';
  static const espressoSettings = '/coffee/espresso/settings';
  static const coffeeSettings = '/coffee/settings';
  static const coffeeSettingDetail = '/coffee/settings/detail';
  static const selectCoffee = '/coffee/select';
  static const timerActive = '/coffee/timer';
  static const timerComplete = '/coffee/timer/complete';

  // === Bean Routes ===
  static const beanDetail = '/coffee/bean/detail';
  static const beanEdit = '/coffee/bean/edit';

  // === Recipe Routes ===
  static const recipeEdit = '/coffee/recipe/edit';
  static const recipeAdd = '/coffee/recipe/add';

  // === Auth (Additional) ===
  static const emailLogin = '/login/email-login';
  static const emailSignUp = '/login/email-sign-up';
  static const signUpComplete = '/login/sign-up-complete';
  static const accountLink = '/login/account-link';
}
