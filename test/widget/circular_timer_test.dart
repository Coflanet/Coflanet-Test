import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coflanet/widgets/timer/circular_timer.dart';

void main() {
  group('CircularTimer', () {
    testWidgets('should render correctly with 0 progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularTimer(
                progress: 0.0,
                size: 200,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularTimer), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should render correctly with 50% progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularTimer(
                progress: 0.5,
                size: 200,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularTimer), findsOneWidget);
    });

    testWidgets('should render correctly with 100% progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularTimer(
                progress: 1.0,
                size: 200,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularTimer), findsOneWidget);
    });

    testWidgets('should render with custom color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularTimer(
                progress: 0.5,
                progressColor: Colors.red,
                size: 200,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularTimer), findsOneWidget);
    });

    testWidgets('should render child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularTimer(
                progress: 0.5,
                size: 200,
                child: Text('01:30'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('01:30'), findsOneWidget);
    });

    testWidgets('should render with phase markers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularTimer(
                progress: 0.5,
                size: 200,
                phaseMarkers: [0.25, 0.5, 0.75],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularTimer), findsOneWidget);
    });
  });

  group('PhaseIndicator', () {
    testWidgets('should render correct number of phase dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PhaseIndicator(
                currentPhase: 0,
                totalPhases: 4,
                phaseNames: ['Phase 1', 'Phase 2', 'Phase 3', 'Phase 4'],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(4));
    });

    testWidgets('should highlight current phase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PhaseIndicator(
                currentPhase: 1,
                totalPhases: 4,
                phaseNames: ['Phase 1', 'Phase 2', 'Phase 3', 'Phase 4'],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(PhaseIndicator), findsOneWidget);
    });
  });
}
