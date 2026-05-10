import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'app_color.dart';

import '_swatch.dart';

/// Palette (원시 컬러) 카탈로그 — Figma `tokens/Palette/Mode 1.json` 기준 13그룹 142색.
final List<WidgetbookComponent> paletteUseCases = [
  WidgetbookComponent(
    name: 'Common',
    useCases: [
      WidgetbookUseCase(
        name: 'Black & White',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Common 0', AppColor.colorGlobalCommon0),
            ('Common 100', AppColor.colorGlobalCommon100),
          ], crossAxisCount: 2),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Neutral',
    useCases: [
      WidgetbookUseCase(
        name: '14단계 그레이 스케일',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Neutral 99', AppColor.colorGlobalNeutral99),
            ('Neutral 95', AppColor.colorGlobalNeutral95),
            ('Neutral 90', AppColor.colorGlobalNeutral90),
            ('Neutral 80', AppColor.colorGlobalNeutral80),
            ('Neutral 70', AppColor.colorGlobalNeutral70),
            ('Neutral 60', AppColor.colorGlobalNeutral60),
            ('Neutral 50', AppColor.colorGlobalNeutral50),
            ('Neutral 40', AppColor.colorGlobalNeutral40),
            ('Neutral 30', AppColor.colorGlobalNeutral30),
            ('Neutral 22', AppColor.colorGlobalNeutral22),
            ('Neutral 20', AppColor.colorGlobalNeutral20),
            ('Neutral 15', AppColor.colorGlobalNeutral15),
            ('Neutral 10', AppColor.colorGlobalNeutral10),
            ('Neutral 5', AppColor.colorGlobalNeutral5),
          ]),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Cool Neutral',
    useCases: [
      WidgetbookUseCase(
        name: '21단계 — Semantic Background에 주로 사용',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('CoolNeutral 99', AppColor.colorGlobalCoolNeutral99),
            ('CoolNeutral 98', AppColor.colorGlobalCoolNeutral98),
            ('CoolNeutral 97', AppColor.colorGlobalCoolNeutral97),
            ('CoolNeutral 96', AppColor.colorGlobalCoolNeutral96),
            ('CoolNeutral 95', AppColor.colorGlobalCoolNeutral95),
            ('CoolNeutral 90', AppColor.colorGlobalCoolNeutral90),
            ('CoolNeutral 80', AppColor.colorGlobalCoolNeutral80),
            ('CoolNeutral 70', AppColor.colorGlobalCoolNeutral70),
            ('CoolNeutral 60', AppColor.colorGlobalCoolNeutral60),
            ('CoolNeutral 50', AppColor.colorGlobalCoolNeutral50),
            ('CoolNeutral 40', AppColor.colorGlobalCoolNeutral40),
            ('CoolNeutral 30', AppColor.colorGlobalCoolNeutral30),
            ('CoolNeutral 25', AppColor.colorGlobalCoolNeutral25),
            ('CoolNeutral 23', AppColor.colorGlobalCoolNeutral23),
            ('CoolNeutral 22', AppColor.colorGlobalCoolNeutral22),
            ('CoolNeutral 20', AppColor.colorGlobalCoolNeutral20),
            ('CoolNeutral 17', AppColor.colorGlobalCoolNeutral17),
            ('CoolNeutral 15', AppColor.colorGlobalCoolNeutral15),
            ('CoolNeutral 10', AppColor.colorGlobalCoolNeutral10),
            ('CoolNeutral 7', AppColor.colorGlobalCoolNeutral7),
            ('CoolNeutral 5', AppColor.colorGlobalCoolNeutral5),
          ]),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Brand & Status',
    useCases: [
      WidgetbookUseCase(
        name: 'Violet (브랜드 Primary 13단계)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Violet 99', AppColor.colorGlobalViolet99),
            ('Violet 95', AppColor.colorGlobalViolet95),
            ('Violet 90', AppColor.colorGlobalViolet90),
            ('Violet 80', AppColor.colorGlobalViolet80),
            ('Violet 70', AppColor.colorGlobalViolet70),
            ('Violet 60', AppColor.colorGlobalViolet60),
            ('Violet 55', AppColor.colorGlobalViolet55),
            ('Violet 50', AppColor.colorGlobalViolet50),
            ('Violet 45', AppColor.colorGlobalViolet45),
            ('Violet 40', AppColor.colorGlobalViolet40),
            ('Violet 30', AppColor.colorGlobalViolet30),
            ('Violet 20', AppColor.colorGlobalViolet20),
            ('Violet 10', AppColor.colorGlobalViolet10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Red (Status Negative)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Red 99', AppColor.colorGlobalRed99),
            ('Red 95', AppColor.colorGlobalRed95),
            ('Red 90', AppColor.colorGlobalRed90),
            ('Red 80', AppColor.colorGlobalRed80),
            ('Red 70', AppColor.colorGlobalRed70),
            ('Red 60', AppColor.colorGlobalRed60),
            ('Red 50', AppColor.colorGlobalRed50),
            ('Red 40', AppColor.colorGlobalRed40),
            ('Red 30', AppColor.colorGlobalRed30),
            ('Red 20', AppColor.colorGlobalRed20),
            ('Red 10', AppColor.colorGlobalRed10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Green (Status Positive)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Green 99', AppColor.colorGlobalGreen99),
            ('Green 95', AppColor.colorGlobalGreen95),
            ('Green 90', AppColor.colorGlobalGreen90),
            ('Green 80', AppColor.colorGlobalGreen80),
            ('Green 70', AppColor.colorGlobalGreen70),
            ('Green 60', AppColor.colorGlobalGreen60),
            ('Green 50', AppColor.colorGlobalGreen50),
            ('Green 40', AppColor.colorGlobalGreen40),
            ('Green 30', AppColor.colorGlobalGreen30),
            ('Green 20', AppColor.colorGlobalGreen20),
            ('Green 10', AppColor.colorGlobalGreen10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Orange (Status Cautionary, 39 hidden 포함)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Orange 99', AppColor.colorGlobalOrange99),
            ('Orange 95', AppColor.colorGlobalOrange95),
            ('Orange 90', AppColor.colorGlobalOrange90),
            ('Orange 80', AppColor.colorGlobalOrange80),
            ('Orange 70', AppColor.colorGlobalOrange70),
            ('Orange 60', AppColor.colorGlobalOrange60),
            ('Orange 50', AppColor.colorGlobalOrange50),
            ('Orange 40', AppColor.colorGlobalOrange40),
            ('Orange 39 *', AppColor.colorGlobalOrange39),
            ('Orange 30', AppColor.colorGlobalOrange30),
            ('Orange 20', AppColor.colorGlobalOrange20),
            ('Orange 10', AppColor.colorGlobalOrange10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Blue (Status Positive Blue)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Blue 99', AppColor.colorGlobalBlue99),
            ('Blue 95', AppColor.colorGlobalBlue95),
            ('Blue 90', AppColor.colorGlobalBlue90),
            ('Blue 80', AppColor.colorGlobalBlue80),
            ('Blue 70', AppColor.colorGlobalBlue70),
            ('Blue 60', AppColor.colorGlobalBlue60),
            ('Blue 55', AppColor.colorGlobalBlue55),
            ('Blue 50', AppColor.colorGlobalBlue50),
            ('Blue 45', AppColor.colorGlobalBlue45),
            ('Blue 40', AppColor.colorGlobalBlue40),
            ('Blue 30', AppColor.colorGlobalBlue30),
            ('Blue 20', AppColor.colorGlobalBlue20),
            ('Blue 10', AppColor.colorGlobalBlue10),
          ]),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Accent Colors',
    useCases: [
      WidgetbookUseCase(
        name: 'Yellow',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Yellow 99', AppColor.colorGlobalYellow99),
            ('Yellow 95', AppColor.colorGlobalYellow95),
            ('Yellow 90', AppColor.colorGlobalYellow90),
            ('Yellow 80', AppColor.colorGlobalYellow80),
            ('Yellow 70', AppColor.colorGlobalYellow70),
            ('Yellow 60', AppColor.colorGlobalYellow60),
            ('Yellow 50', AppColor.colorGlobalYellow50),
            ('Yellow 40', AppColor.colorGlobalYellow40),
            ('Yellow 30', AppColor.colorGlobalYellow30),
            ('Yellow 20', AppColor.colorGlobalYellow20),
            ('Yellow 10', AppColor.colorGlobalYellow10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Lime (37 hidden 포함)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Lime 99', AppColor.colorGlobalLime99),
            ('Lime 95', AppColor.colorGlobalLime95),
            ('Lime 90', AppColor.colorGlobalLime90),
            ('Lime 80', AppColor.colorGlobalLime80),
            ('Lime 70', AppColor.colorGlobalLime70),
            ('Lime 60', AppColor.colorGlobalLime60),
            ('Lime 50', AppColor.colorGlobalLime50),
            ('Lime 40', AppColor.colorGlobalLime40),
            ('Lime 37 *', AppColor.colorGlobalLime37),
            ('Lime 30', AppColor.colorGlobalLime30),
            ('Lime 20', AppColor.colorGlobalLime20),
            ('Lime 10', AppColor.colorGlobalLime10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Cyan',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Cyan 99', AppColor.colorGlobalCyan99),
            ('Cyan 95', AppColor.colorGlobalCyan95),
            ('Cyan 90', AppColor.colorGlobalCyan90),
            ('Cyan 80', AppColor.colorGlobalCyan80),
            ('Cyan 70', AppColor.colorGlobalCyan70),
            ('Cyan 60', AppColor.colorGlobalCyan60),
            ('Cyan 50', AppColor.colorGlobalCyan50),
            ('Cyan 40', AppColor.colorGlobalCyan40),
            ('Cyan 30', AppColor.colorGlobalCyan30),
            ('Cyan 20', AppColor.colorGlobalCyan20),
            ('Cyan 10', AppColor.colorGlobalCyan10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Light Blue',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('LightBlue 99', AppColor.colorGlobalLightBlue99),
            ('LightBlue 95', AppColor.colorGlobalLightBlue95),
            ('LightBlue 90', AppColor.colorGlobalLightBlue90),
            ('LightBlue 80', AppColor.colorGlobalLightBlue80),
            ('LightBlue 70', AppColor.colorGlobalLightBlue70),
            ('LightBlue 60', AppColor.colorGlobalLightBlue60),
            ('LightBlue 50', AppColor.colorGlobalLightBlue50),
            ('LightBlue 40', AppColor.colorGlobalLightBlue40),
            ('LightBlue 30', AppColor.colorGlobalLightBlue30),
            ('LightBlue 20', AppColor.colorGlobalLightBlue20),
            ('LightBlue 10', AppColor.colorGlobalLightBlue10),
          ]),
        ),
      ),
      WidgetbookUseCase(
        name: 'Pink (46 hidden 포함)',
        builder: (context) => SingleChildScrollView(
          child: swatchGrid([
            ('Pink 99', AppColor.colorGlobalPink99),
            ('Pink 95', AppColor.colorGlobalPink95),
            ('Pink 90', AppColor.colorGlobalPink90),
            ('Pink 80', AppColor.colorGlobalPink80),
            ('Pink 70', AppColor.colorGlobalPink70),
            ('Pink 60', AppColor.colorGlobalPink60),
            ('Pink 50', AppColor.colorGlobalPink50),
            ('Pink 46 *', AppColor.colorGlobalPink46),
            ('Pink 40', AppColor.colorGlobalPink40),
            ('Pink 30', AppColor.colorGlobalPink30),
            ('Pink 20', AppColor.colorGlobalPink20),
            ('Pink 10', AppColor.colorGlobalPink10),
          ]),
        ),
      ),
    ],
  ),
];
