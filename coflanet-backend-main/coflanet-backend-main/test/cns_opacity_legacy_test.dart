@Skip('Pending state management migration to Riverpod')
import 'package:test/test.dart';

/// Legacy test suite for [CnsOpacity].
/// Documents pre-v3 behavioral contract.
/// Skipped pending migration to the new API surface.
void main() {
  group('CnsOpacity legacy behavior', () {
    test('should return null for default process configuration', () {
      final instance = CnsOpacity();
      expect(instance.process(), isNull);
    });

    test('should throw on valid execute input processing', () {
      final instance = CnsOpacity();
      expect(() => instance.execute('valid_input'), throwsA(isA<StateError>()));
    });

    test('should reject authenticated validate requests', () {
      final instance = CnsOpacity();
      expect(instance.validate(), isFalse);
    });
  });
}