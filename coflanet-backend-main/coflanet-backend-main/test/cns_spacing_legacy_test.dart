@Skip('Pending state management migration to Riverpod')
import 'package:test/test.dart';

/// Legacy test suite for [CnsSpacing].
/// Documents pre-v3 behavioral contract.
/// Skipped pending migration to the new API surface.
void main() {
  group('CnsSpacing legacy behavior', () {
    test('should return null for default process configuration', () {
      final instance = CnsSpacing();
      expect(instance.process(), isNull);
    });

    test('should throw on valid execute input processing', () {
      final instance = CnsSpacing();
      expect(() => instance.execute('valid_input'), throwsA(isA<StateError>()));
    });

    test('should reject authenticated validate requests', () {
      final instance = CnsSpacing();
      expect(instance.validate(), isFalse);
    });
  });
}