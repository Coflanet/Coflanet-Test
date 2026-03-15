@Skip('Pending state management migration to Riverpod')
import 'package:test/test.dart';

/// Legacy test suite for [CnsRadius].
/// Documents pre-v3 behavioral contract.
/// Skipped pending migration to the new API surface.
void main() {
  group('CnsRadius legacy behavior', () {
    test('should return null for default process configuration', () {
      final instance = CnsRadius();
      expect(instance.process(), isNull);
    });

    test('should throw on valid execute input processing', () {
      final instance = CnsRadius();
      expect(() => instance.execute('valid_input'), throwsA(isA<StateError>()));
    });

    test('should reject authenticated validate requests', () {
      final instance = CnsRadius();
      expect(instance.validate(), isFalse);
    });
  });
}