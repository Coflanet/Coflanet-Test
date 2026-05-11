# Icon Naming Guide

> Figma Library 📚 ↔ 개발 파일 매핑 가이드
>
> 최종 업데이트: 2026-03-27

## 네이밍 규칙

### 파일명 컨벤션

| 규칙 | 설명 | 예시 |
|---|---|---|
| **케이스** | kebab-case | `arrow-down.svg` |
| **Fill 베리언트** | `-fill` 접미사 | `bell.svg` → `bell-fill.svg` |
| **Thick 베리언트** | `-thick` 접미사 | `check.svg` → `check-thick.svg` |
| **Small 베리언트** | `-sm` 접미사 | `chevron-down.svg` → `chevron-down-sm.svg` |
| **Slim 베리언트** | `-slim` 접미사 | `chevron-down.svg` → `chevron-down-slim.svg` |
| **Tight 베리언트** | `-tight` 접미사 | `chevron-left.svg` → `chevron-left-tight.svg` |
| **Color 베리언트** | `-color` 접미사 | `home.svg` → `home-color.svg` |

### 접미사 순서

베리언트가 복합적으로 사용될 경우 아래 순서를 따릅니다:

```
{icon-name}[-tight][-thick][-sm][-slim][-fill][-color].svg
```

예: `chevron-down-thick-sm-slim.svg`

### 폴더 구조

```
Icon/Normal/  ← 플랫 구조 (Figma 'Icon/Normal' 섹션과 1:1 매칭)
├── arrow-down.svg
├── bell.svg
├── ...
└── write.svg
```

카테고리별 폴더 분류 없이 플랫 구조를 유지합니다. Figma 라이브러리 구조와의 일관성을 위한 결정입니다.

---

## Figma ↔ 파일명 매핑 테이블

### Navigation — Arrow

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Arrow Down | `Name=arrowDown, Thick=False` | `arrow-down.svg` |
| Icon/Normal/Arrow Down | `Name=arrowDownThick, Thick=True` | `arrow-down-thick.svg` |
| Icon/Normal/Arrow Up | `Name=arrowUp, Thick=False` | `arrow-up.svg` |
| Icon/Normal/Arrow Up | `Name=arrowUpThick, Thick=True` | `arrow-up-thick.svg` |
| Icon/Normal/Arrow Left | `Name=arrowLeft, Thick=False` | `arrow-left.svg` |
| Icon/Normal/Arrow Left | `Name=arrowLeftThick, Thick=True` | `arrow-left-thick.svg` |
| Icon/Normal/Arrow Right | `Name=arrowRight, Thick=False` | `arrow-right.svg` |
| Icon/Normal/Arrow Right | `Name=arrowRightThick, Thick=True` | `arrow-right-thick.svg` |

### Navigation — Chevron

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Chevron Down | `Name=chevronDown, Thick=False, Small=False, Slim=False` | `chevron-down.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDownThick, Thick=True, Small=False, Slim=False` | `chevron-down-thick.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDownSmall, Thick=False, Small=True, Slim=False` | `chevron-down-sm.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDownThickSmall, Thick=True, Small=True, Slim=False` | `chevron-down-thick-sm.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDown, Thick=False, Small=False, Slim=True` | `chevron-down-slim.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDownThick, Thick=True, Small=False, Slim=True` | `chevron-down-thick-slim.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDownSmall, Thick=False, Small=True, Slim=True` | `chevron-down-sm-slim.svg` |
| Icon/Normal/Chevron Down | `Name=chevronDownThickSmall, Thick=True, Small=True, Slim=True` | `chevron-down-thick-sm-slim.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUp, Thick=False, Small=False, Slim=False` | `chevron-up.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUpThick, Thick=True, Small=False, Slim=False` | `chevron-up-thick.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUpSmall, Thick=False, Small=True, Slim=False` | `chevron-up-sm.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUpThickSmall, Thick=True, Small=True, Slim=False` | `chevron-up-thick-sm.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUp, Thick=False, Small=False, Slim=True` | `chevron-up-slim.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUpThick, Thick=True, Small=False, Slim=True` | `chevron-up-thick-slim.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUpSmall, Thick=False, Small=True, Slim=True` | `chevron-up-sm-slim.svg` |
| Icon/Normal/Chevron Up | `Name=chevronUpThickSmall, Thick=True, Small=True, Slim=True` | `chevron-up-thick-sm-slim.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeft, Tight=False, Thick=False, Small=False` | `chevron-left.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftThick, Tight=False, Thick=True, Small=False` | `chevron-left-thick.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftTight, Tight=True, Thick=False, Small=False` | `chevron-left-tight.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftTightThick, Tight=True, Thick=True, Small=False` | `chevron-left-tight-thick.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftSmall, Tight=False, Thick=False, Small=True` | `chevron-left-sm.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftThickSmall, Tight=False, Thick=True, Small=True` | `chevron-left-thick-sm.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftTightSmall, Tight=True, Thick=False, Small=True` | `chevron-left-tight-sm.svg` |
| Icon/Normal/Chevron Left | `Name=chevronLeftTightThickSmall, Tight=True, Thick=True, Small=True` | `chevron-left-tight-thick-sm.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRight, Tight=False, Thick=False, Small=False` | `chevron-right.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightThick, Tight=False, Thick=True, Small=False` | `chevron-right-thick.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightTight, Tight=True, Thick=False, Small=False` | `chevron-right-tight.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightTightThick, Tight=True, Thick=True, Small=False` | `chevron-right-tight-thick.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightSmall, Tight=False, Thick=False, Small=True` | `chevron-right-sm.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightThickSmall, Tight=False, Thick=True, Small=True` | `chevron-right-thick-sm.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightTightSmall, Tight=True, Thick=False, Small=True` | `chevron-right-tight-sm.svg` |
| Icon/Normal/Chevron Right | `Name=chevronRightTightThickSmall, Tight=True, Thick=True, Small=True` | `chevron-right-tight-thick-sm.svg` |
| Icon/Normal/Chevron Double Left | `Name=chevronDoubleLeft, Thick=False, Small=False` | `chevron-double-left.svg` |
| Icon/Normal/Chevron Double Left | `Name=chevronDoubleLeftThick, Thick=True, Small=False` | `chevron-double-left-thick.svg` |
| Icon/Normal/Chevron Double Left | `Name=chevronDoubleLeftSmall, Thick=False, Small=True` | `chevron-double-left-sm.svg` |
| Icon/Normal/Chevron Double Left | `Name=chevronDoubleLeftThickSmall, Thick=True, Small=True` | `chevron-double-left-thick-sm.svg` |
| Icon/Normal/Chevron Double Right | `Name=chevronDoubleRight, Thick=False, Small=False` | `chevron-double-right.svg` |
| Icon/Normal/Chevron Double Right | `Name=chevronDoubleRightThick, Thick=True, Small=False` | `chevron-double-right-thick.svg` |
| Icon/Normal/Chevron Double Right | `Name=chevronDoubleRightSmall, Thick=False, Small=True` | `chevron-double-right-sm.svg` |
| Icon/Normal/Chevron Double Right | `Name=chevronDoubleRightThickSmall, Thick=True, Small=True` | `chevron-double-right-thick-sm.svg` |

### Navigation — Caret

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Caret Down | `Name=caretDown` | `caret-down.svg` |
| Icon/Normal/Caret Up | `Name=caretUp` | `caret-up.svg` |

### Communication

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Bell | `Name=bell, Fill=False` | `bell.svg` |
| Icon/Normal/Bell | `Name=bellFill, Fill=True` | `bell-fill.svg` |
| Icon/Normal/Bell Plus | `Name=bellPlus` | `bell-plus.svg` |
| Icon/Normal/Bubble | `Name=bubble, Fill=False` | `bubble.svg` |
| Icon/Normal/Bubble | `Name=bubbleFill, Fill=True` | `bubble-fill.svg` |
| Icon/Normal/Bubble Plus | `Name=bubblePlus, Fill=False` | `bubble-plus.svg` |
| Icon/Normal/Bubble Plus | `Name=bubblePlusFill, Fill=True` | `bubble-plus-fill.svg` |
| Icon/Normal/Message | `Name=message, Fill=False` | `message.svg` |
| Icon/Normal/Message | `Name=messageFill, Fill=True` | `message-fill.svg` |
| Icon/Normal/Mail | `Name=mail` | `mail.svg` |
| Icon/Normal/Send | `Name=send, Fill=False` | `send.svg` |
| Icon/Normal/Send | `Name=sendFill, Fill=True` | `send-fill.svg` |
| Icon/Normal/Speaker | `Name=speaker, Speaker=True` | `speaker.svg` |
| Icon/Normal/Speaker_Mute | `Name=SpeakerMute, Speaker=False` | `speaker-mute.svg` |

### Action

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Check | `Name=check, Thick=False` | `check.svg` |
| Icon/Normal/Check | `Name=checkThick, Thick=True` | `check-thick.svg` |
| Icon/Normal/Close | `Name=close, Thick=False` | `close.svg` |
| Icon/Normal/Close | `Name=closeThick, Thick=True` | `close-thick.svg` |
| Icon/Normal/Plus | `Name=plus, Thick=False` | `plus.svg` |
| Icon/Normal/Plus | `Name=plusThick, Thick=True` | `plus-thick.svg` |
| Icon/Normal/Minus | `Name=minus, Thick=False` | `minus.svg` |
| Icon/Normal/Minus | `Name=minusThick, Thick=True` | `minus-thick.svg` |
| Icon/Normal/Search | `Name=search, Thick=False` | `search.svg` |
| Icon/Normal/Search | `Name=searchThick, Thick=True` | `search-thick.svg` |
| Icon/Normal/Menu | `Name=menu, Thick=False` | `menu.svg` |
| Icon/Normal/Menu | `Name=menuThick, Thick=True` | `menu-thick.svg` |
| Icon/Normal/Line Horizontal | `Name=lineHorizontal, Thick=False` | `line-horizontal.svg` |
| Icon/Normal/Line Horizontal | `Name=lineHorizontalThick, Thick=True` | `line-horizontal-thick.svg` |
| Icon/Normal/Filter | `Name=filter, Fill=False` | `filter.svg` |
| Icon/Normal/Filter | `Name=filterFill, Fill=True` | `filter-fill.svg` |
| Icon/Normal/Pencil | `Name=pencil, Fill=False` | `pencil.svg` |
| Icon/Normal/Pencil | `Name=pencilFill, Fill=True` | `pencil-fill.svg` |
| Icon/Normal/Trash | `Name=trash` | `trash.svg` |
| Icon/Normal/Copy | `Name=copy` | `copy.svg` |
| Icon/Normal/Share | `Name=share` | `share.svg` |
| Icon/Normal/Share iOS | `Name=shareIos` | `share-ios.svg` |
| Icon/Normal/Download | `Name=download` | `download.svg` |
| Icon/Normal/Upload | `Name=upload` | `upload.svg` |
| Icon/Normal/Refresh | `Name=refresh` | `refresh.svg` |
| Icon/Normal/Change | `Name=change` | `change.svg` |
| Icon/Normal/External Link | `Name=externalLink` | `external-link.svg` |
| Icon/Normal/Link | `Name=link` | `link.svg` |
| Icon/Normal/Write | `Name=write` | `write.svg` |
| Icon/Normal/Tune | `Name=tune` | `tune.svg` |
| Icon/Normal/Setting | `Name=setting` | `setting.svg` |
| Icon/Normal/Magic Wand | `Name=magicWand` | `magic-wand.svg` |
| Icon/Normal/Handle | `Name=handle` | `handle.svg` |
| Icon/Normal/Full | `Name=full` | `full.svg` |

### Status & Feedback

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Circle | `Name=circle, Fill=False` | `circle.svg` |
| Icon/Normal/Circle | `Name=circleFill, Fill=True` | `circle-fill.svg` |
| Icon/Normal/Circle Block | `Name=circleBlock` | `circle-block.svg` |
| Icon/Normal/Circle Check | `Name=circleCheck, Fill=False` | `circle-check.svg` |
| Icon/Normal/Circle Check | `Name=circleCheckFill, Fill=True` | `circle-check-fill.svg` |
| Icon/Normal/Circle Close | `Name=circleClose` | `circle-close.svg` |
| Icon/Normal/Circle Exclamation | `Name=circleExclamation, Fill=False` | `circle-exclamation.svg` |
| Icon/Normal/Circle Exclamation | `Name=circleExclamationFill, Fill=True` | `circle-exclamation-fill.svg` |
| Icon/Normal/Circle Info | `Name=circleInfo, Fill=False` | `circle-info.svg` |
| Icon/Normal/Circle Info | `Name=circleInfoFill, Fill=True` | `circle-info-fill.svg` |
| Icon/Normal/Circle Plus | `Name=circlePlus, Fill=False` | `circle-plus.svg` |
| Icon/Normal/Circle Plus | `Name=circlePlusFill, Fill=True` | `circle-plus-fill.svg` |
| Icon/Normal/Circle Point | `Name=circlePoint` | `circle-point.svg` |
| Icon/Normal/Circle Question | `Name=circleQuestion, Fill=False` | `circle-question.svg` |
| Icon/Normal/Circle Question | `Name=circleQuestionFill, Fill=True` | `circle-question-fill.svg` |
| Icon/Normal/Exclamation | `Name=exclamation` | `exclamation.svg` |
| Icon/Normal/Question | `Name=question` | `question.svg` |
| Icon/Normal/Triangle | `Name=triangle, Fill=False` | `triangle.svg` |
| Icon/Normal/Triangle | `Name=triangleFill, Fill=True` | `triangle-fill.svg` |
| Icon/Normal/Triangle Exclamation | `Name=triangleExclamation, Fill=False` | `triangle-exclamation.svg` |
| Icon/Normal/Triangle Exclamation | `Name=triangleExclamationFill, Fill=True` | `triangle-exclamation-fill.svg` |
| Icon/Normal/Square | `Name=square, Fill=False` | `square.svg` |
| Icon/Normal/Square | `Name=squareFill, Fill=True` | `square-fill.svg` |
| Icon/Normal/Square More | `Name=squareMore` | `square-more.svg` |
| Icon/Normal/Square Plus | `Name=squarePlus, Fill=False` | `square-plus.svg` |
| Icon/Normal/Square Plus | `Name=squarePlusFill, Fill=True` | `square-plus-fill.svg` |
| Icon/Normal/New | `Name=new` | `new.svg` |
| Icon/Normal/Dot | `Name=dot` | `dot.svg` |

### Content & Media

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Book | `Name=book, Fill=False` | `book.svg` |
| Icon/Normal/Book | `Name=bookFill, Fill=True` | `book-fill.svg` |
| Icon/Normal/Bookmark | `Name=bookmark, Fill=False` | `bookmark.svg` |
| Icon/Normal/Bookmark | `Name=bookmarkFill, Fill=True` | `bookmark-fill.svg` |
| Icon/Normal/Camera | `Name=camera, Fill=False` | `camera.svg` |
| Icon/Normal/Camera | `Name=cameraFill, Fill=True` | `camera-fill.svg` |
| Icon/Normal/Image | `Name=image` | `image.svg` |
| Icon/Normal/Thumbnail | `Name=thumbnail` | `thumbnail.svg` |
| Icon/Normal/Document | `Name=document, Fill=False` | `document.svg` |
| Icon/Normal/Document | `Name=documentFill, Fill=True` | `document-fill.svg` |
| Icon/Normal/Document Person | `Name=documentPerson, Fill=False` | `document-person.svg` |
| Icon/Normal/Document Person | `Name=documentPersonFill, Fill=True` | `document-person-fill.svg` |
| Icon/Normal/Document Text | `Name=documentText, Fill=False` | `document-text.svg` |
| Icon/Normal/Document Text | `Name=documentTextFill, Fill=True` | `document-text-fill.svg` |
| Icon/Normal/Folder | `Name=folder, Fill=False` | `folder.svg` |
| Icon/Normal/Folder | `Name=folderFill, Fill=True` | `folder-fill.svg` |
| Icon/Normal/Folder Job | `Name=folderJob, Fill=False` | `folder-job.svg` |
| Icon/Normal/Folder Job | `Name=folderJobFill, Fill=True` | `folder-job-fill.svg` |
| Icon/Normal/Folder Star | `Name=folderStar, Fill=False` | `folder-star.svg` |
| Icon/Normal/Folder Star | `Name=folderStarFill, Fill=True` | `folder-star-fill.svg` |
| Icon/Normal/Template | `Name=template, Fill=False` | `template.svg` |
| Icon/Normal/Template | `Name=templateFill, Fill=True` | `template-fill.svg` |
| Icon/Normal/Play | `Name=play` | `play.svg` |
| Icon/Normal/Pause | `Name=pause` | `pause.svg` |
| Icon/Normal/Calendar | `Name=calendar` | `calendar.svg` |
| Icon/Normal/List | `Name=list` | `list.svg` |
| Icon/Normal/List Category | `Name=listCategory` | `list-category.svg` |

### People & Social

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Person | `Name=person, Fill=False` | `person.svg` |
| Icon/Normal/Person | `Name=personFill, Fill=True` | `person-fill.svg` |
| Icon/Normal/Person Plus | `Name=personPlus, Fill=False` | `person-plus.svg` |
| Icon/Normal/Person Plus | `Name=personPlusFill, Fill=True` | `person-plus-fill.svg` |
| Icon/Normal/Persons | `Name=persons, Fill=False` | `persons.svg` |
| Icon/Normal/Persons | `Name=personsFill, Fill=True` | `persons-fill.svg` |
| Icon/Normal/Face Smile | `Name=faceSmile, Fill=False` | `face-smile.svg` |
| Icon/Normal/Face Smile | `Name=faceSmileFill, Fill=True` | `face-smile-fill.svg` |
| Icon/Normal/Like | `Name=like, Fill=False` | `like.svg` |
| Icon/Normal/Like | `Name=likeFill, Fill=True` | `like-fill.svg` |
| Icon/Normal/Heart | `Name=heart, Fill=False` | `heart.svg` |
| Icon/Normal/Heart | `Name=heartFill, Fill=True` | `heart-fill.svg` |
| Icon/Normal/Star | `Name=star, Fill=False` | `star.svg` |
| Icon/Normal/Star | `Name=starFill, Fill=True` | `star-fill.svg` |

### Commerce & Business

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Cart | `Name=cart` | `cart.svg` |
| Icon/Normal/shopping | `Name=shopping, Fill=False` | `shopping.svg` |
| Icon/Normal/shopping | `Name=shopping, Fill=True` | `shopping-fill.svg` |
| Icon/Normal/Coins | `Name=coins, Fill=False` | `coins.svg` |
| Icon/Normal/Coins | `Name=coinsFill, Fill=True` | `coins-fill.svg` |
| Icon/Normal/Business Bag | `Name=businessBag, Fill=False` | `business-bag.svg` |
| Icon/Normal/Business Bag | `Name=businessBagFill, Fill=True` | `business-bag-fill.svg` |
| Icon/Normal/Company | `Name=company, Fill=False` | `company.svg` |
| Icon/Normal/Company | `Name=companyFill, Fill=True` | `company-fill.svg` |
| Icon/Normal/Company | `Name=companyColor, Fill=True` | `company-color.svg` |
| Icon/Normal/Company Check | `Name=companyCheck` | `company-check.svg` |
| Icon/Normal/Company Check | `Name=companyCheckFill` | `company-check-fill.svg` |
| Icon/Normal/Company Plus | `Name=companyPlus` | `company-plus.svg` |
| Icon/Normal/Company Plus | `Name=companyPlusFill` | `company-plus-fill.svg` |
| Icon/Normal/Crown | `Name=crown, Fill=False` | `crown.svg` |
| Icon/Normal/Crown | `Name=crownFill, Fill=True` | `crown-fill.svg` |
| Icon/Normal/Trophy | `Name=trophy` | `trophy.svg` |
| Icon/Normal/Trophy | `Name=trophyFill` | `trophy-fill.svg` |
| Icon/Normal/Coffee | `Name=coffee, Fill=False` | `coffee.svg` |
| Icon/Normal/Coffee | `Name=coffee, Fill=True` | `coffee-fill.svg` |
| Icon/Normal/Graduation | `Name=graduation` | `graduation.svg` |

### Place & Device

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Home | `Name=home, Fill=False` | `home.svg` |
| Icon/Normal/Home | `Name=homeFill, Fill=True` | `home-fill.svg` |
| Icon/Normal/Home | `Name=homeColor, Fill=True` | `home-color.svg` |
| Icon/Normal/Location | `Name=location, Fill=False` | `location.svg` |
| Icon/Normal/Location | `Name=locationFill, Fill=True` | `location-fill.svg` |
| Icon/Normal/Globe | `Name=globe` | `globe.svg` |
| Icon/Normal/Compass | `Name=compass, Fill=False` | `compass.svg` |
| Icon/Normal/Compass | `Name=compassFill, Fill=True` | `compass-fill.svg` |
| Icon/Normal/Desktop | `Name=desktop` | `desktop.svg` |
| Icon/Normal/Desktop | `Name=desktopFill` | `desktop-fill.svg` |
| Icon/Normal/Mobile | `Name=mobile, Fill=False` | `mobile.svg` |
| Icon/Normal/Mobile | `Name=mobileFill, Fill=True` | `mobile-fill.svg` |
| Icon/Normal/Keyboard | `Name=keyboard` | `keyboard.svg` |

### Security & System

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Lock | `Name=lock, Fill=False` | `lock.svg` |
| Icon/Normal/Lock | `Name=lockFill, Fill=True` | `lock-fill.svg` |
| Icon/Normal/Lock Open | `Name=lockOpen, Fill=False` | `lock-open.svg` |
| Icon/Normal/Lock Open | `Name=lockOpenFill, Fill=True` | `lock-open-fill.svg` |
| Icon/Normal/Eye | `Name=view, Fill=False` | `view.svg` |
| Icon/Normal/Eye | `Name=viewFill, Fill=True` | `view-fill.svg` |
| Icon/Normal/Eye Slash | `Name=viewSlash, Fill=False` | `view-slash.svg` |
| Icon/Normal/Eye Slash | `Name=viewSlashFill, Fill=True` | `view-slash-fill.svg` |
| Icon/Normal/Verified Check | `Name=verifiedCheck, Fill=False` | `verified-check.svg` |
| Icon/Normal/Verified Check | `Name=verifiedCheckFill, Fill=True` | `verified-check-fill.svg` |
| Icon/Normal/Verified Star | `Name=verifiedStar, Fill=False` | `verified-star.svg` |
| Icon/Normal/Verified Star | `Name=verifiedStarFill, Fill=True` | `verified-star-fill.svg` |

### Misc

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Pin | `Name=pin, Fill=False` | `pin.svg` |
| Icon/Normal/Pin | `Name=pinFill, Fill=True` | `pin-fill.svg` |
| Icon/Normal/Thunder | `Name=thunder, Fill=False` | `thunder.svg` |
| Icon/Normal/Thunder | `Name=thunderFill, Fill=True` | `thunder-fill.svg` |
| Icon/Normal/Clock | `Name=clock` | `clock.svg` |
| Icon/Normal/History | `Name=history` | `history.svg` |
| Icon/Normal/More Horizontal | `Name=moreHorizontal` | `more-horizontal.svg` |
| Icon/Normal/More Vertical | `Name=moreVertical, Tight=False` | `more-vertical.svg` |
| Icon/Normal/More Vertical | `Name=moreVerticalTight, Tight=True` | `more-vertical-tight.svg` |
| Icon/Normal/Apps | `Name=apps` | `apps.svg` |
| Icon/Normal/Android | `Name=android` | `android.svg` |

### Logo

| Figma Component | Figma Name 값 | 파일명 |
|---|---|---|
| Icon/Normal/Logo Apple | `Name=logoApple` | `logo-apple.svg` |
| Icon/Normal/Logo Facebook | `Name=logoFacebook` | `logo-facebook.svg` |
| Icon/Normal/Logo Google Play | `Name=logoGooglePlay` | `logo-google-play.svg` |
| Icon/Normal/Logo Instagram | `Name=logoInstagram` | `logo-instagram.svg` |
| Icon/Normal/Logo Kakao | `Name=logoKakao` | `logo-kakao.svg` |
| Icon/Normal/Logo LinkedIn | `Name=logoLinkedIn` | `logo-linkedin.svg` |
| Icon/Normal/Logo Naver | `Name=logoNaver` | `logo-naver.svg` |
| Icon/Normal/Logo Naver Blog | `Name=logoNaverBlog` | `logo-naver-blog.svg` |
| Icon/Normal/Logo YouTube | `Name=logoYoutube` | `logo-youtube.svg` |

---

## 총 아이콘 수: 233개

## 변환 규칙 요약 (Figma Name → 파일명)

```
1. camelCase → kebab-case  (arrowDown → arrow-down)
2. Fill=True 베리언트  → -fill 접미사
3. Thick=True 베리언트  → -thick 접미사
4. Small=True 베리언트  → -sm 접미사
5. Slim=True 베리언트   → -slim 접미사
6. Tight=True 베리언트  → -tight 접미사
7. Color 베리언트       → -color 접미사
8. 확장자: .svg
```
