import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../services/scoring/cooked_models.dart';

class RadialScoreGauge extends StatefulWidget {
  final int targetScore;
  final CookedTier tier;
  final double size;

  const RadialScoreGauge({
    super.key,
    required this.targetScore,
    required this.tier,
    this.size = 280,
  });

  @override
  State<RadialScoreGauge> createState() => _RadialScoreGaugeState();
}

class _RadialScoreGaugeState extends State<RadialScoreGauge>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _scoreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.targetScore.toDouble(),
    ).animate(
      CurvedAnimation(
        parent: _scoreAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );

    if (widget.targetScore >= 85) {
      _shakeController.repeat(reverse: true);
    }

    _scoreAnimationController.forward();
  }

  @override
  void didUpdateWidget(covariant RadialScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetScore != widget.targetScore) {
      _scoreAnimation = Tween<double>(
        begin: _scoreAnimation.value,
        end: widget.targetScore.toDouble(),
      ).animate(
        CurvedAnimation(
          parent: _scoreAnimationController,
          curve: Curves.easeOutCubic,
        ),
      );
      _scoreAnimationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = AppColors.getTierColor(widget.targetScore);
    final isCritical = widget.targetScore >= 85;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _scoreAnimationController,
        _pulseController,
        if (isCritical) _shakeController,
      ]),
      builder: (context, child) {
        final currentScore = _scoreAnimation.value.round();
        final progress = (_scoreAnimation.value / 100.0).clamp(0.0, 1.0);

        // Shake offset for critical scores
        final shakeOffset = isCritical
            ? Offset((_shakeController.value - 0.5) * 3, (_shakeController.value - 0.5) * 2)
            : Offset.zero;

        return Transform.translate(
          offset: shakeOffset,
          child: ScaleTransition(
            scale: isCritical ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer heat glow
                  Container(
                    width: widget.size * 0.9,
                    height: widget.size * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: tierColor.withValues(
                            alpha: isCritical ? 0.35 * _pulseAnimation.value : 0.2,
                          ),
                          blurRadius: isCritical ? 45 : 30,
                          spreadRadius: isCritical ? 10 : 2,
                        ),
                      ],
                    ),
                  ),

                  // Custom arc gauge
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _RadialGaugePainter(
                      progress: progress,
                      trackColor: const Color(0xFF1E1E28),
                      fillColor: tierColor,
                      strokeWidth: 18,
                    ),
                  ),

                  // Center content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'YOU ARE',
                        style: AppTypography.mono(
                          fontSize: 13,
                          weight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$currentScore',
                            style: AppTypography.scoreDisplay(
                              fontSize: widget.size * 0.28,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '%',
                            style: AppTypography.headingLarge(
                              fontSize: widget.size * 0.14,
                              color: tierColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: tierColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: tierColor.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.tier.emoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.tier.title,
                              style: AppTypography.label(
                                fontSize: 13,
                                weight: FontWeight.w800,
                                color: tierColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;

  _RadialGaugePainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // We do a 270 degree open gauge or full 360 ring
    const startAngle = -pi / 2; // top
    final sweepAngle = 2 * pi * progress;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Fill arc with gradient glow
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepGradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + 2 * pi,
      colors: [
        AppColors.fireYellow,
        AppColors.fireOrange,
        fillColor,
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: const GradientRotation(-pi / 2),
    );

    final fillPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      fillPaint,
    );

    // Glowing spark head at current progress
    final sparkAngle = startAngle + sweepAngle;
    final sparkX = center.dx + radius * cos(sparkAngle);
    final sparkY = center.dy + radius * sin(sparkAngle);

    final glowPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(Offset(sparkX, sparkY), strokeWidth / 2.2, glowPaint);

    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(sparkX, sparkY), strokeWidth / 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fillColor != fillColor;
  }
}
