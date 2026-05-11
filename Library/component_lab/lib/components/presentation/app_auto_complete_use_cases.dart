import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_auto_complete.dart';

const _countries = [
  '대한민국',
  '미국',
  '미얀마',
  '베트남',
  '브라질',
  '스페인',
  '싱가포르',
  '영국',
  '오스트리아',
  '이탈리아',
  '일본',
  '중국',
  '캐나다',
  '태국',
  '터키',
  '프랑스',
  '필리핀',
  '호주',
  '독일',
  '네덜란드',
];

List<String> _syncFilter(String q) {
  final query = q.toLowerCase();
  return _countries.where((c) => c.toLowerCase().contains(query)).toList();
}

Future<List<String>> _asyncFilter(String q) async {
  await Future.delayed(const Duration(milliseconds: 350));
  return _syncFilter(q);
}

final List<WidgetbookComponent> autoCompleteUseCases = [
  WidgetbookComponent(
    name: 'AppAutoComplete',
    useCases: [
      WidgetbookUseCase(
        name: 'Sync filter — countries',
        builder: (context) => _bg(
          context,
          AppAutoComplete<String>(
            label: '국가',
            hintText: '국가명을 입력하세요',
            fetch: _syncFilter,
            itemLabel: (s) => s,
            onSelected: (s) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('선택: $s')),
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Async fetch (350ms latency)',
        builder: (context) => _bg(
          context,
          AppAutoComplete<String>(
            label: '국가 (비동기)',
            hintText: '입력 후 잠시 기다리세요',
            fetch: _asyncFilter,
            itemLabel: (s) => s,
            debounce: const Duration(milliseconds: 300),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Min length 2',
        builder: (context) => _bg(
          context,
          AppAutoComplete<String>(
            label: '국가 (2글자 이상)',
            hintText: '2글자 이상 입력',
            minLength: 2,
            fetch: _syncFilter,
            itemLabel: (s) => s,
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: AppColor.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.space16),
    child: child,
  );
}
