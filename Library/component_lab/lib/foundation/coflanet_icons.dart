import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Coflanet 아이콘 토큰 — Figma 🔘 Icon 페이지 기준.
///
/// 사이즈 체계 (Figma Component variant):
/// - **Normal**: 24px (기본)
/// - **Large**: 32px
/// - **Medium**: 20px
/// - **Small**: 16px
/// - **Tiny**: 12px
///
/// 사용 예시:
/// ```dart
/// CoflanetIcon(CoflanetIcons.home, size: CoflanetIconSize.normal)
/// // 또는 직접:
/// SvgPicture.asset(CoflanetIcons.home, width: 24, height: 24)
/// ```
class CoflanetIcons {
  CoflanetIcons._();

  // ═══════════════════════════════════════════════════════════════
  // ASSET PATHS
  // ═══════════════════════════════════════════════════════════════

  static const String android = 'assets/icons/android.svg';
  static const String apps = 'assets/icons/apps.svg';
  static const String arrowDownThick = 'assets/icons/arrow-down-thick.svg';
  static const String arrowDown = 'assets/icons/arrow-down.svg';
  static const String arrowLeftThick = 'assets/icons/arrow-left-thick.svg';
  static const String arrowLeft = 'assets/icons/arrow-left.svg';
  static const String arrowRightThick = 'assets/icons/arrow-right-thick.svg';
  static const String arrowRight = 'assets/icons/arrow-right.svg';
  static const String arrowUpThick = 'assets/icons/arrow-up-thick.svg';
  static const String arrowUp = 'assets/icons/arrow-up.svg';
  static const String bellFill = 'assets/icons/bell-fill.svg';
  static const String bellPlus = 'assets/icons/bell-plus.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String bookFill = 'assets/icons/book-fill.svg';
  static const String book = 'assets/icons/book.svg';
  static const String bookmarkFill = 'assets/icons/bookmark-fill.svg';
  static const String bookmark = 'assets/icons/bookmark.svg';
  static const String bubbleFill = 'assets/icons/bubble-fill.svg';
  static const String bubblePlusFill = 'assets/icons/bubble-plus-fill.svg';
  static const String bubblePlus = 'assets/icons/bubble-plus.svg';
  static const String bubble = 'assets/icons/bubble.svg';
  static const String businessBagFill = 'assets/icons/business-bag-fill.svg';
  static const String businessBag = 'assets/icons/business-bag.svg';
  static const String calendar = 'assets/icons/calendar.svg';
  static const String cameraFill = 'assets/icons/camera-fill.svg';
  static const String camera = 'assets/icons/camera.svg';
  static const String caretDown = 'assets/icons/caret-down.svg';
  static const String caretUp = 'assets/icons/caret-up.svg';
  static const String cart = 'assets/icons/cart.svg';
  static const String change = 'assets/icons/change.svg';
  static const String checkThick = 'assets/icons/check-thick.svg';
  static const String check = 'assets/icons/check.svg';
  static const String chevronDoubleLeftSm = 'assets/icons/chevron-double-left-sm.svg';
  static const String chevronDoubleLeftThickSm = 'assets/icons/chevron-double-left-thick-sm.svg';
  static const String chevronDoubleLeftThick = 'assets/icons/chevron-double-left-thick.svg';
  static const String chevronDoubleLeft = 'assets/icons/chevron-double-left.svg';
  static const String chevronDoubleRightSm = 'assets/icons/chevron-double-right-sm.svg';
  static const String chevronDoubleRightThickSm = 'assets/icons/chevron-double-right-thick-sm.svg';
  static const String chevronDoubleRightThick = 'assets/icons/chevron-double-right-thick.svg';
  static const String chevronDoubleRight = 'assets/icons/chevron-double-right.svg';
  static const String chevronDownSlim = 'assets/icons/chevron-down-slim.svg';
  static const String chevronDownSmSlim = 'assets/icons/chevron-down-sm-slim.svg';
  static const String chevronDownSm = 'assets/icons/chevron-down-sm.svg';
  static const String chevronDownThickSlim = 'assets/icons/chevron-down-thick-slim.svg';
  static const String chevronDownThickSmSlim = 'assets/icons/chevron-down-thick-sm-slim.svg';
  static const String chevronDownThickSm = 'assets/icons/chevron-down-thick-sm.svg';
  static const String chevronDownThick = 'assets/icons/chevron-down-thick.svg';
  static const String chevronDown = 'assets/icons/chevron-down.svg';
  static const String chevronLeftSm = 'assets/icons/chevron-left-sm.svg';
  static const String chevronLeftThickSm = 'assets/icons/chevron-left-thick-sm.svg';
  static const String chevronLeftThick = 'assets/icons/chevron-left-thick.svg';
  static const String chevronLeftTightSm = 'assets/icons/chevron-left-tight-sm.svg';
  static const String chevronLeftTightThickSm = 'assets/icons/chevron-left-tight-thick-sm.svg';
  static const String chevronLeftTightThick = 'assets/icons/chevron-left-tight-thick.svg';
  static const String chevronLeftTight = 'assets/icons/chevron-left-tight.svg';
  static const String chevronLeft = 'assets/icons/chevron-left.svg';
  static const String chevronRightSm = 'assets/icons/chevron-right-sm.svg';
  static const String chevronRightThickSm = 'assets/icons/chevron-right-thick-sm.svg';
  static const String chevronRightThick = 'assets/icons/chevron-right-thick.svg';
  static const String chevronRightTightSm = 'assets/icons/chevron-right-tight-sm.svg';
  static const String chevronRightTightThickSm = 'assets/icons/chevron-right-tight-thick-sm.svg';
  static const String chevronRightTightThick = 'assets/icons/chevron-right-tight-thick.svg';
  static const String chevronRightTight = 'assets/icons/chevron-right-tight.svg';
  static const String chevronRight = 'assets/icons/chevron-right.svg';
  static const String chevronUpSlim = 'assets/icons/chevron-up-slim.svg';
  static const String chevronUpSmSlim = 'assets/icons/chevron-up-sm-slim.svg';
  static const String chevronUpSm = 'assets/icons/chevron-up-sm.svg';
  static const String chevronUpThickSlim = 'assets/icons/chevron-up-thick-slim.svg';
  static const String chevronUpThickSmSlim = 'assets/icons/chevron-up-thick-sm-slim.svg';
  static const String chevronUpThickSm = 'assets/icons/chevron-up-thick-sm.svg';
  static const String chevronUpThick = 'assets/icons/chevron-up-thick.svg';
  static const String chevronUp = 'assets/icons/chevron-up.svg';
  static const String circleBlock = 'assets/icons/circle-block.svg';
  static const String circleCheckFill = 'assets/icons/circle-check-fill.svg';
  static const String circleCheck = 'assets/icons/circle-check.svg';
  static const String circleClose = 'assets/icons/circle-close.svg';
  static const String circleExclamationFill = 'assets/icons/circle-exclamation-fill.svg';
  static const String circleExclamation = 'assets/icons/circle-exclamation.svg';
  static const String circleFill = 'assets/icons/circle-fill.svg';
  static const String circleInfoFill = 'assets/icons/circle-info-fill.svg';
  static const String circleInfo = 'assets/icons/circle-info.svg';
  static const String circlePlusFill = 'assets/icons/circle-plus-fill.svg';
  static const String circlePlus = 'assets/icons/circle-plus.svg';
  static const String circlePoint = 'assets/icons/circle-point.svg';
  static const String circleQuestionFill = 'assets/icons/circle-question-fill.svg';
  static const String circleQuestion = 'assets/icons/circle-question.svg';
  static const String circle = 'assets/icons/circle.svg';
  static const String clock = 'assets/icons/clock.svg';
  static const String closeThick = 'assets/icons/close-thick.svg';
  static const String close = 'assets/icons/close.svg';
  static const String coffeeFill = 'assets/icons/coffee-fill.svg';
  static const String coffee = 'assets/icons/coffee.svg';
  static const String coinsFill = 'assets/icons/coins-fill.svg';
  static const String coins = 'assets/icons/coins.svg';
  static const String companyCheckFill = 'assets/icons/company-check-fill.svg';
  static const String companyCheck = 'assets/icons/company-check.svg';
  static const String companyColor = 'assets/icons/company-color.svg';
  static const String companyFill = 'assets/icons/company-fill.svg';
  static const String companyPlusFill = 'assets/icons/company-plus-fill.svg';
  static const String companyPlus = 'assets/icons/company-plus.svg';
  static const String company = 'assets/icons/company.svg';
  static const String compassFill = 'assets/icons/compass-fill.svg';
  static const String compass = 'assets/icons/compass.svg';
  static const String copy = 'assets/icons/copy.svg';
  static const String crownFill = 'assets/icons/crown-fill.svg';
  static const String crown = 'assets/icons/crown.svg';
  static const String desktopFill = 'assets/icons/desktop-fill.svg';
  static const String desktop = 'assets/icons/desktop.svg';
  static const String documentFill = 'assets/icons/document-fill.svg';
  static const String documentPersonFill = 'assets/icons/document-person-fill.svg';
  static const String documentPerson = 'assets/icons/document-person.svg';
  static const String documentTextFill = 'assets/icons/document-text-fill.svg';
  static const String documentText = 'assets/icons/document-text.svg';
  static const String document = 'assets/icons/document.svg';
  static const String dot = 'assets/icons/dot.svg';
  static const String download = 'assets/icons/download.svg';
  static const String exclamation = 'assets/icons/exclamation.svg';
  static const String externalLink = 'assets/icons/external-link.svg';
  static const String faceSmileFill = 'assets/icons/face-smile-fill.svg';
  static const String faceSmile = 'assets/icons/face-smile.svg';
  static const String filterFill = 'assets/icons/filter-fill.svg';
  static const String filter = 'assets/icons/filter.svg';
  static const String folderFill = 'assets/icons/folder-fill.svg';
  static const String folderJobFill = 'assets/icons/folder-job-fill.svg';
  static const String folderJob = 'assets/icons/folder-job.svg';
  static const String folderStarFill = 'assets/icons/folder-star-fill.svg';
  static const String folderStar = 'assets/icons/folder-star.svg';
  static const String folder = 'assets/icons/folder.svg';
  static const String full = 'assets/icons/full.svg';
  static const String globe = 'assets/icons/globe.svg';
  static const String graduation = 'assets/icons/graduation.svg';
  static const String handle = 'assets/icons/handle.svg';
  static const String heartFill = 'assets/icons/heart-fill.svg';
  static const String heart = 'assets/icons/heart.svg';
  static const String history = 'assets/icons/history.svg';
  static const String homeColor = 'assets/icons/home-color.svg';
  static const String homeFill = 'assets/icons/home-fill.svg';
  static const String home = 'assets/icons/home.svg';
  static const String image = 'assets/icons/image.svg';
  static const String keyboard = 'assets/icons/keyboard.svg';
  static const String likeFill = 'assets/icons/like-fill.svg';
  static const String like = 'assets/icons/like.svg';
  static const String lineHorizontalThick = 'assets/icons/line-horizontal-thick.svg';
  static const String lineHorizontal = 'assets/icons/line-horizontal.svg';
  static const String link = 'assets/icons/link.svg';
  static const String listCategory = 'assets/icons/list-category.svg';
  static const String list = 'assets/icons/list.svg';
  static const String locationFill = 'assets/icons/location-fill.svg';
  static const String location = 'assets/icons/location.svg';
  static const String lockFill = 'assets/icons/lock-fill.svg';
  static const String lockOpenFill = 'assets/icons/lock-open-fill.svg';
  static const String lockOpen = 'assets/icons/lock-open.svg';
  static const String lock = 'assets/icons/lock.svg';
  static const String logoApple = 'assets/icons/logo-apple.svg';
  static const String logoFacebook = 'assets/icons/logo-facebook.svg';
  static const String logoGooglePlay = 'assets/icons/logo-google-play.svg';
  static const String logoInstagram = 'assets/icons/logo-instagram.svg';
  static const String logoKakao = 'assets/icons/logo-kakao.svg';
  static const String logoLinkedin = 'assets/icons/logo-linkedin.svg';
  static const String logoNaverBlog = 'assets/icons/logo-naver-blog.svg';
  static const String logoNaver = 'assets/icons/logo-naver.svg';
  static const String logoYoutube = 'assets/icons/logo-youtube.svg';
  static const String magicWand = 'assets/icons/magic-wand.svg';
  static const String mail = 'assets/icons/mail.svg';
  static const String menuThick = 'assets/icons/menu-thick.svg';
  static const String menu = 'assets/icons/menu.svg';
  static const String messageFill = 'assets/icons/message-fill.svg';
  static const String message = 'assets/icons/message.svg';
  static const String minusThick = 'assets/icons/minus-thick.svg';
  static const String minus = 'assets/icons/minus.svg';
  static const String mobileFill = 'assets/icons/mobile-fill.svg';
  static const String mobile = 'assets/icons/mobile.svg';
  static const String moreHorizontal = 'assets/icons/more-horizontal.svg';
  static const String moreVerticalTight = 'assets/icons/more-vertical-tight.svg';
  static const String moreVertical = 'assets/icons/more-vertical.svg';
  static const String newIcon = 'assets/icons/new.svg';
  static const String pause = 'assets/icons/pause.svg';
  static const String pencilFill = 'assets/icons/pencil-fill.svg';
  static const String pencil = 'assets/icons/pencil.svg';
  static const String personFill = 'assets/icons/person-fill.svg';
  static const String personPlusFill = 'assets/icons/person-plus-fill.svg';
  static const String personPlus = 'assets/icons/person-plus.svg';
  static const String person = 'assets/icons/person.svg';
  static const String personsFill = 'assets/icons/persons-fill.svg';
  static const String persons = 'assets/icons/persons.svg';
  static const String pinFill = 'assets/icons/pin-fill.svg';
  static const String pin = 'assets/icons/pin.svg';
  static const String play = 'assets/icons/play.svg';
  static const String plusThick = 'assets/icons/plus-thick.svg';
  static const String plus = 'assets/icons/plus.svg';
  static const String question = 'assets/icons/question.svg';
  static const String refresh = 'assets/icons/refresh.svg';
  static const String searchThick = 'assets/icons/search-thick.svg';
  static const String search = 'assets/icons/search.svg';
  static const String sendFill = 'assets/icons/send-fill.svg';
  static const String send = 'assets/icons/send.svg';
  static const String setting = 'assets/icons/setting.svg';
  static const String shareIos = 'assets/icons/share-ios.svg';
  static const String share = 'assets/icons/share.svg';
  static const String shoppingFill = 'assets/icons/shopping-fill.svg';
  static const String shopping = 'assets/icons/shopping.svg';
  static const String speakerMute = 'assets/icons/speaker-mute.svg';
  static const String speaker = 'assets/icons/speaker.svg';
  static const String squareFill = 'assets/icons/square-fill.svg';
  static const String squareMore = 'assets/icons/square-more.svg';
  static const String squarePlusFill = 'assets/icons/square-plus-fill.svg';
  static const String squarePlus = 'assets/icons/square-plus.svg';
  static const String square = 'assets/icons/square.svg';
  static const String starFill = 'assets/icons/star-fill.svg';
  static const String star = 'assets/icons/star.svg';
  static const String templateFill = 'assets/icons/template-fill.svg';
  static const String template = 'assets/icons/template.svg';
  static const String thumbnail = 'assets/icons/thumbnail.svg';
  static const String thunderFill = 'assets/icons/thunder-fill.svg';
  static const String thunder = 'assets/icons/thunder.svg';
  static const String trash = 'assets/icons/trash.svg';
  static const String triangleExclamationFill = 'assets/icons/triangle-exclamation-fill.svg';
  static const String triangleExclamation = 'assets/icons/triangle-exclamation.svg';
  static const String triangleFill = 'assets/icons/triangle-fill.svg';
  static const String triangle = 'assets/icons/triangle.svg';
  static const String trophyFill = 'assets/icons/trophy-fill.svg';
  static const String trophy = 'assets/icons/trophy.svg';
  static const String tune = 'assets/icons/tune.svg';
  static const String upload = 'assets/icons/upload.svg';
  static const String verifiedCheckFill = 'assets/icons/verified-check-fill.svg';
  static const String verifiedCheck = 'assets/icons/verified-check.svg';
  static const String verifiedStarFill = 'assets/icons/verified-star-fill.svg';
  static const String verifiedStar = 'assets/icons/verified-star.svg';
  static const String viewFill = 'assets/icons/view-fill.svg';
  static const String viewSlashFill = 'assets/icons/view-slash-fill.svg';
  static const String viewSlash = 'assets/icons/view-slash.svg';
  static const String view = 'assets/icons/view.svg';
  static const String write = 'assets/icons/write.svg';
}

/// Figma Icon 사이즈 체계
enum CoflanetIconSize {
  /// 12px
  tiny(12),

  /// 16px
  small(16),

  /// 20px
  medium(20),

  /// 24px (기본)
  normal(24),

  /// 32px
  large(32);

  const CoflanetIconSize(this.value);
  final double value;
}

/// Coflanet 아이콘 위젯 — SVG를 렌더링합니다.
///
/// ```dart
/// CoflanetIcon(
///   CoflanetIcons.home,
///   size: CoflanetIconSize.normal,
///   color: AppColor.colorGlobalCoolNeutral10,
/// )
/// ```
class CoflanetIcon extends StatelessWidget {
  const CoflanetIcon(
    this.assetPath, {
    super.key,
    this.size = CoflanetIconSize.normal,
    this.color,
    this.package,
    this.semanticLabel,
  });

  /// SVG 에셋 경로 (CoflanetIcons의 상수 사용)
  final String assetPath;

  /// 아이콘 사이즈
  final CoflanetIconSize size;

  /// 아이콘 색상 (null이면 SVG 원본 색상 사용)
  final Color? color;

  /// 패키지 이름 (외부 패키지에서 사용 시)
  final String? package;

  /// 접근성 — 스크린 리더가 읽을 라벨. null이면 장식 아이콘으로 처리(읽지 않음).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size.value,
      height: size.value,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      package: package,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
