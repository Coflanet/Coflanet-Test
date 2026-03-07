import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// Data model for flavor profile values.
class FlavorProfile {
  /// 산미 (Acidity) - 0 to 100
  final double acidity;

  /// 바디감 (Body) - 0 to 100
  final double body;

  /// 단맛 (Sweetness) - 0 to 100
  final double sweetness;

  /// 쓴맛 (Bitterness) - 0 to 100
  final double bitterness;

  /// 밸런스 (Balance) - 0 to 100
  final double balance;

  const FlavorProfile({
    this.acidity = 0.0,
    this.body = 0.0,
    this.sweetness = 0.0,
    this.bitterness = 0.0,
    this.balance = 0.0,
  });

  /// Get value by index (0-4)
  double getValueAt(int index) {
    switch (index) {
      case 0:
        return acidity;
      case 1:
        return body;
      case 2:
        return sweetness;
      case 3:
        return bitterness;
      case 4:
        return balance;
      default:
        return 0.0;
    }
  }

  /// Get label by index
  static String getLabelAt(int index) {
    switch (index) {
      case 0:
        return '산미';
      case 1:
        return '바디감';
      case 2:
        return '단맛';
      case 3:
        return '쓴맛';
      case 4:
        return '밸런스';
      default:
        return '';
    }
  }

  /// Create from map
  factory FlavorProfile.fromMap(Map<String, double> map) {
    return FlavorProfile(
      acidity: map['acidity'] ?? map['산미'] ?? 0.0,
      body: map['body'] ?? map['바디감'] ?? 0.0,
      sweetness: map['sweetness'] ?? map['단맛'] ?? 0.0,
      bitterness: map['bitterness'] ?? map['쓴맛'] ?? 0.0,
      balance: map['balance'] ?? map['밸런스'] ?? 0.0,
    );
  }

  /// Convert to map
  Map<String, double> toMap() {
    return {
      'acidity': acidity,
      'body': body,
      'sweetness': sweetness,
      'bitterness': bitterness,
      'balance': balance,
    };
  }

  /// Copy with new values
  FlavorProfile copyWith({
    double? acidity,
    double? body,
    double? sweetness,
    double? bitterness,
    double? balance,
  }) {
    return FlavorProfile(
      acidity: acidity ?? this.acidity,
      body: body ?? this.body,
      sweetness: sweetness ?? this.sweetness,
      bitterness: bitterness ?? this.bitterness,
      balance: balance ?? this.balance,
    );
  }
}

/// A radar chart widget for displaying coffee flavor profiles.
///
/// Figma: 원두 상세 - 향미 레이더 차트
///
/// Usage:
/// ```dart
/// FlavorRadarChart(
///   profile: FlavorProfile(
///     acidity: 4.5,
///     body: 3.5,
///     sweetness: 2.5,
///     bitterness: 1.5,
///     balance: 4.0,
///   ),
///   size: 200,
/// )
/// ```
class FlavorRadarChart extends StatefulWidget {
  /// The flavor profile data to display
  final FlavorProfile profile;

  /// Size of the chart (width and height)
  final double size;

  /// Maximum value for each axis (default: 5.0)
  final double maxValue;

  /// Number of grid levels to draw
  final int gridLevels;

  /// Whether to show axis labels
  final bool showLabels;

  /// Whether to show axis values
  final bool showValues;

  /// Whether to animate the chart
  final bool animate;

  /// Animation duration
  final Duration animationDuration;

  /// Custom fill color (defaults to primary with opacity)
  final Color? fillColor;

  /// Custom stroke color (defaults to primary)
  final Color? strokeColor;

  /// Custom grid color
  final Color? gridColor;

  /// Custom label color
  final Color? labelColor;

  const FlavorRadarChart({
    super.key,
    required this.profile,
    this.size = 200,
    this.maxValue = 100.0,
    this.gridLevels = 5,
    this.showLabels = true,
    this.showValues = true,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.fillColor,
    this.strokeColor,
    this.gridColor,
    this.labelColor,
  });

  @override
  State<FlavorRadarChart> createState() => _FlavorRadarChartState();
}

class _FlavorRadarChartState extends State<FlavorRadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlavorRadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile && widget.animate) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _FlavorRadarChartPainter(
              profile: widget.profile,
              animationValue: _animation.value,
              maxValue: widget.maxValue,
              gridLevels: widget.gridLevels,
              showLabels: widget.showLabels,
              showValues: widget.showValues,
              fillColor:
                  widget.fillColor ?? AppColor.primaryNormal.withOpacity(0.2),
              strokeColor: widget.strokeColor ?? AppColor.primaryNormal,
              gridColor: widget.gridColor ?? AppColor.lineNormalNormal,
              labelColor: widget.labelColor ?? AppColor.labelNormal,
            ),
          );
        },
      ),
    );
  }
}

class _FlavorRadarChartPainter extends CustomPainter {
  final FlavorProfile profile;
  final double animationValue;
  final double maxValue;
  final int gridLevels;
  final bool showLabels;
  final bool showValues;
  final Color fillColor;
  final Color strokeColor;
  final Color gridColor;
  final Color labelColor;

  static const int axisCount = 5;
  static const double labelPadding = 30.0;

  _FlavorRadarChartPainter({
    required this.profile,
    required this.animationValue,
    required this.maxValue,
    required this.gridLevels,
    required this.showLabels,
    required this.showValues,
    required this.fillColor,
    required this.strokeColor,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (showLabels ? labelPadding : 8);
    final angleStep = (2 * math.pi) / axisCount;
    // Start from top (12 o'clock position)
    final startAngle = -math.pi / 2;

    // Draw grid
    _drawGrid(canvas, center, radius, angleStep, startAngle);

    // Draw axes
    _drawAxes(canvas, center, radius, angleStep, startAngle);

    // Draw data polygon
    _drawDataPolygon(canvas, center, radius, angleStep, startAngle);

    // Draw labels and values
    if (showLabels) {
      _drawLabels(canvas, center, radius, angleStep, startAngle, size);
    }
  }

  void _drawGrid(
    Canvas canvas,
    Offset center,
    double radius,
    double angleStep,
    double startAngle,
  ) {
    final gridPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric polygons
    for (int level = 1; level <= gridLevels; level++) {
      final levelRadius = (radius / gridLevels) * level;
      final path = Path();

      for (int i = 0; i < axisCount; i++) {
        final angle = startAngle + (i * angleStep);
        final x = center.dx + levelRadius * math.cos(angle);
        final y = center.dy + levelRadius * math.sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }
  }

  void _drawAxes(
    Canvas canvas,
    Offset center,
    double radius,
    double angleStep,
    double startAngle,
  ) {
    final axisPaint = Paint()
      ..color = gridColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < axisCount; i++) {
      final angle = startAngle + (i * angleStep);
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(endX, endY), axisPaint);
    }
  }

  void _drawDataPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    double angleStep,
    double startAngle,
  ) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < axisCount; i++) {
      final value = profile.getValueAt(i).clamp(0.0, maxValue);
      final normalizedValue = (value / maxValue) * animationValue;
      final angle = startAngle + (i * angleStep);
      final x = center.dx + (radius * normalizedValue) * math.cos(angle);
      final y = center.dy + (radius * normalizedValue) * math.sin(angle);

      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  void _drawLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double angleStep,
    double startAngle,
    Size size,
  ) {
    for (int i = 0; i < axisCount; i++) {
      final angle = startAngle + (i * angleStep);
      final labelRadius = radius + 20;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      final label = FlavorProfile.getLabelAt(i);
      final value = profile.getValueAt(i);

      // Draw label
      final labelSpan = TextSpan(
        text: label,
        style: AppTextStyles.caption1Medium.copyWith(color: labelColor),
      );
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      labelPainter.layout();

      // Adjust position based on angle
      double labelX = x - labelPainter.width / 2;
      double labelY = y - labelPainter.height / 2;

      // Fine-tune positioning for each axis
      if (angle == startAngle) {
        // Top (산미)
        labelY -= 8;
      } else if (angle > startAngle && angle < startAngle + math.pi) {
        // Right side
        labelX += 4;
      } else {
        // Left side
        labelX -= 4;
      }

      labelPainter.paint(canvas, Offset(labelX, labelY));

      // Draw value if enabled
      if (showValues) {
        final valueSpan = TextSpan(
          text: value.round().toString(),
          style: AppTextStyles.caption1Regular.copyWith(color: strokeColor),
        );
        final valuePainter = TextPainter(
          text: valueSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        valuePainter.layout();

        double valueX = x - valuePainter.width / 2;
        double valueY = y + labelPainter.height / 2;

        if (angle == startAngle) {
          valueY = labelY - valuePainter.height - 2;
        }

        valuePainter.paint(canvas, Offset(valueX, valueY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FlavorRadarChartPainter oldDelegate) {
    return oldDelegate.profile != profile ||
        oldDelegate.animationValue != animationValue;
  }
}

/// A compact version of the radar chart for list items.
class FlavorRadarChartCompact extends StatelessWidget {
  final FlavorProfile profile;
  final double size;

  const FlavorRadarChartCompact({
    super.key,
    required this.profile,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return FlavorRadarChart(
      profile: profile,
      size: size,
      showLabels: false,
      showValues: false,
      animate: false,
      gridLevels: 3,
    );
  }
}
