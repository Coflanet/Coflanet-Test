import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coflanet/widgets/buttons/primary_button.dart';
import 'package:coflanet/constants/color_constant.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('should render with correct text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('should not call onPressed when disabled', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Disabled Button',
              isEnabled: false,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('should show icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button with Icon',
              icon: Icons.play_arrow,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });
  });
}
