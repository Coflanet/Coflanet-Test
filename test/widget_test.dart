// Basic Flutter widget test for Coflanet app

import 'package:flutter_test/flutter_test.dart';
import 'package:coflanet/main.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CoflanetApp());

    // Verify app renders (splash screen should show)
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}
