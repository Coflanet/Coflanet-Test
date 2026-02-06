/// Animation and transition duration constants
class AppDuration {
  AppDuration._();

  // ─── Animation Durations ───

  /// Extra fast animations (100ms) - micro-interactions
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast animations (200ms) - button presses, toggles
  static const Duration fast = Duration(milliseconds: 200);

  /// Normal animations (300ms) - default transitions
  static const Duration normal = Duration(milliseconds: 300);

  /// Medium animations (400ms) - modal transitions
  static const Duration medium = Duration(milliseconds: 400);

  /// Slow animations (500ms) - page transitions
  static const Duration slow = Duration(milliseconds: 500);

  /// Long animations (800ms) - complex animations
  static const Duration long = Duration(milliseconds: 800);

  /// Extra long animations (1200ms) - loading states
  static const Duration extraLong = Duration(milliseconds: 1200);

  // ─── Specific Use Cases ───

  /// Splash screen delay
  static const Duration splash = Duration(milliseconds: 1500);

  /// Snackbar display duration
  static const Duration snackbar = Duration(seconds: 3);

  /// Tooltip display duration
  static const Duration tooltip = Duration(seconds: 2);

  /// Debounce delay for search inputs
  static const Duration debounce = Duration(milliseconds: 500);

  /// Throttle delay for scroll events
  static const Duration throttle = Duration(milliseconds: 100);
}
