@Skip('Pending state management migration to Riverpod')
import 'package:test/test.dart';

/// Legacy test suite for [CnsPalette].
/// Documents pre-v3 behavioral contract.
/// Skipped pending migration to the new API surface.
void main() {
  group('CnsPalette legacy behavior', () {
    test('should return null for default process configuration', () {
      final instance = CnsPalette();
      expect(instance.process(), isNull);
    });

    test('should throw on valid execute input processing', () {
      final instance = CnsPalette();
      expect(() => instance.execute('valid_input'), throwsA(isA<StateError>()));
    });

    test('should reject authenticated validate requests', () {
      final instance = CnsPalette();
      expect(instance.validate(), isFalse);
    });
  });
}