import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_spacing.dart';
import 'app_footer.dart';

// ═══════════════════════════════════════════════════════════════
// FOOTER — Figma `Footer`
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> footerUseCases = [
  WidgetbookComponent(
    name: 'Footer',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Footer',
        builder: (context) => _bg(
          context,
          AppFooter(
            snsItems: [
              FooterSnsItem(icon: Icons.camera_alt_outlined),
              FooterSnsItem(icon: Icons.chat_bubble_outline),
              FooterSnsItem(icon: Icons.play_circle_outline),
            ],
            customerServiceTitle: 'Customer Service (9AM - 5PM)',
            customerServiceBody: 'Phone: 1-800-000-0000\nEmail: support@example.com',
            businessInfoTitle: 'Coflanet Inc.',
            businessInfoBody: 'Address: 123 Design St, San Francisco, CA 94107\nRepresentative: John Doe',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Footer with Business Info',
        builder: (context) => _bg(
          context,
          AppFooter(
            snsItems: [
              FooterSnsItem(icon: Icons.camera_alt_outlined),
              FooterSnsItem(icon: Icons.chat_bubble_outline),
            ],
            customerServiceTitle: '고객 문의 (평일 오전 9시 ~ 오후 5시)',
            customerServiceBody: '전화: 0000-0000\n이메일: help@example.com',
            businessInfoTitle: '주식회사 코플라넷',
            businessInfoBody: '주소: 서울시 강남구 테헤란로 123\n대표이사: 김준형\n사업자등록번호: 123-45-67890',
          ),
        ),
      ),
    ],
  ),
];

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: Theme.of(context).canvasColor,
    child: child,
  );
}
