import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/widgets/cards/screen_scaffold.dart';

/// 독립 마이(My Planet) 화면 — [ScreenScaffold](Static/Black 캔버스 + 통일
/// 헤더 title2Bold + 자동 back)로 틀을 잡고 본문은 [MyPlanetContent] 재사용.
///
/// 헤더 타이틀(userName, Rx)은 [Obx] 로 감싸 갱신을 구독한다. 본문은 자체
/// 스크롤(MyPlanetContent 의 SingleChildScrollView + bottomScrollInset)을
/// 가지므로 [ScreenScaffold.scrollable]=false.
class MyPlanetView extends GetView<MyPlanetController> {
  const MyPlanetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ScreenScaffold(
        title: controller.userName,
        scrollable: false,
        child: const MyPlanetContent(),
      ),
    );
  }
}
