import 'package:get/get.dart';

// Modules - Splash
import 'package:coflanet/modules/splash/splash_view.dart';
import 'package:coflanet/modules/splash/splash_binding.dart';

// Modules - Auth
import 'package:coflanet/modules/auth/signin/signin_view.dart';
import 'package:coflanet/modules/auth/signin/signin_binding.dart';
import 'package:coflanet/modules/auth/signup/signup_view.dart';
import 'package:coflanet/modules/auth/signup/signup_binding.dart';
import 'package:coflanet/modules/auth/signup/signup_complete_view.dart';
import 'package:coflanet/modules/auth/email_login/email_login_view.dart';
import 'package:coflanet/modules/auth/email_login/email_login_binding.dart';
import 'package:coflanet/modules/auth/profile_setup/profile_setup_view.dart';
import 'package:coflanet/modules/auth/profile_setup/profile_setup_binding.dart';
import 'package:coflanet/modules/auth/account_link/account_link_view.dart';
import 'package:coflanet/modules/auth/account_link/account_link_binding.dart';

// Modules - Onboarding
import 'package:coflanet/modules/onboarding/survey_binding.dart';
import 'package:coflanet/modules/onboarding/reason/survey_reason_view.dart';
import 'package:coflanet/modules/onboarding/reason/survey_reason_binding.dart';
import 'package:coflanet/modules/onboarding/index/survey_index_view.dart';
import 'package:coflanet/modules/onboarding/intro/survey_intro_view.dart';
import 'package:coflanet/modules/onboarding/section_intro/survey_section_intro_view.dart';
import 'package:coflanet/modules/onboarding/question/survey_question_view.dart';
import 'package:coflanet/modules/onboarding/analyzing/survey_analyzing_view.dart';
import 'package:coflanet/modules/onboarding/complete/survey_complete_view.dart';
import 'package:coflanet/modules/onboarding/result/survey_result_view.dart';

// Modules - Coffee
import 'package:coflanet/modules/coffee/coffee_binding.dart';
import 'package:coflanet/modules/coffee/main/coffee_main_view.dart';
import 'package:coflanet/modules/coffee/hand_drip/hand_drip_view.dart';
import 'package:coflanet/modules/coffee/espresso/espresso_view.dart';
import 'package:coflanet/modules/coffee/espresso/espresso_settings_view.dart';
import 'package:coflanet/modules/coffee/espresso/espresso_settings_binding.dart';
import 'package:coflanet/modules/coffee/settings/coffee_settings_view.dart';
import 'package:coflanet/modules/coffee/settings/coffee_setting_detail_view.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_binding.dart';
import 'package:coflanet/modules/coffee/timer/coffee_timer_view.dart';
import 'package:coflanet/modules/coffee/timer/timer_complete_view.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_view.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_binding.dart';
import 'package:coflanet/modules/coffee/bean/bean_detail_view.dart';
import 'package:coflanet/modules/coffee/bean/bean_edit_view.dart';
import 'package:coflanet/modules/coffee/settings/recipe_form_view.dart';

// Modules - Matching
import 'package:coflanet/modules/matching/matching_binding.dart';
import 'package:coflanet/modules/matching/matching_result_view.dart';

// Modules - Profile
import 'package:coflanet/modules/profile/my_taste_binding.dart';
import 'package:coflanet/modules/profile/my_taste_view.dart';

// Modules - Planet
import 'package:coflanet/modules/planet/my_planet_binding.dart';
import 'package:coflanet/modules/planet/my_planet_view.dart';

// Modules - Shell
import 'package:coflanet/modules/shell/main_shell_binding.dart';
import 'package:coflanet/modules/shell/main_shell_view.dart';

part 'app_routes.dart';

/// App routing configuration
class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    // === Splash ===
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    // === Auth ===
    GetPage(
      name: Routes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.profileSetup,
      page: () => const ProfileSetupView(),
      binding: ProfileSetupBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.emailLogin,
      page: () => const EmailLoginView(),
      binding: EmailLoginBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.emailSignUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.signUpComplete,
      page: () => const SignUpCompleteView(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.accountLink,
      page: () => const AccountLinkView(),
      binding: AccountLinkBinding(),
      transition: Transition.cupertino,
    ),

    // === Onboarding ===
    GetPage(
      name: Routes.surveyReason,
      page: () => const SurveyReasonView(),
      binding: SurveyReasonBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.surveyIndex,
      page: () => const SurveyIndexView(),
      binding: SurveyBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.surveyIntro,
      page: () => const SurveyIntroView(),
      binding: SurveyBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '${Routes.surveySectionIntro}/:section',
      page: () => const SurveySectionIntroView(),
      binding: SurveyBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '${Routes.survey}/:step',
      page: () => const SurveyQuestionView(),
      binding: SurveyBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.surveyAnalyzing,
      page: () => const SurveyAnalyzingView(),
      binding: SurveyBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.surveyComplete,
      page: () => const SurveyCompleteView(),
      binding: SurveyBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.surveyResult,
      page: () => const SurveyResultView(),
      binding: SurveyBinding(),
      transition: Transition.cupertino,
    ),

    // === Coffee ===
    GetPage(
      name: Routes.coffeeMain,
      page: () => const CoffeeMainView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.handDrip,
      page: () => const HandDripView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.espresso,
      page: () => const EspressoView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.espressoSettings,
      page: () => const EspressoSettingsView(),
      binding: EspressoSettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.coffeeSettings,
      page: () => const CoffeeSettingsView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.coffeeSettingDetail,
      page: () => const CoffeeSettingDetailView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.selectCoffee,
      page: () => const SelectCoffeeView(),
      binding: SelectCoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.beanDetail,
      page: () => const BeanDetailView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.beanEdit,
      page: () => const BeanEditView(),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.recipeEdit,
      page: () => const RecipeFormView(isEditMode: true),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.recipeAdd,
      page: () => const RecipeFormView(isEditMode: false),
      binding: CoffeeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.timerActive,
      page: () => const CoffeeTimerView(),
      binding: CoffeeTimerBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.timerComplete,
      page: () => const TimerCompleteView(),
      binding: CoffeeTimerBinding(),
      transition: Transition.fade,
    ),

    // === Matching ===
    GetPage(
      name: Routes.matchingResult,
      page: () => const MatchingResultView(),
      binding: MatchingBinding(),
      transition: Transition.cupertino,
    ),

    // === Profile ===
    GetPage(
      name: Routes.myTaste,
      page: () => const MyTasteView(),
      binding: MyTasteBinding(),
      transition: Transition.cupertino,
    ),

    // === Planet ===
    GetPage(
      name: Routes.myPlanet,
      page: () => const MyPlanetView(),
      binding: MyPlanetBinding(),
      transition: Transition.cupertino,
    ),

    // === Shell ===
    GetPage(
      name: Routes.mainShell,
      page: () => const MainShellView(),
      binding: MainShellBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
