import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FireParticlesBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final bool intense;

  const FireParticlesBackground({
    super.key,
    required this.child,
    this.particleCount = 28,
    this.intense = false,
  });

  @override
  State<FireParticlesBackground> createState() => _FireParticlesBackgroundState();
}

class _FireParticlesBackgroundState extends State<FireParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_EmberParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_generateParticle(randomY: true));
    }
  }

  _EmberParticle _generateParticle({bool randomY = false}) {
    return _EmberParticle(
      x: _random.nextDouble(),
      y: randomY ? _random.nextDouble() : 1.05 + (_random.nextDouble() * 0.1),
      size: 2.0 + _random.nextDouble() * (widget.intense ? 4.5 : 3.0),
      speed: 0.05 + _random.nextDouble() * (widget.intense ? 0.12 : 0.08),
      drift: (_random.nextDouble() - 0.5) * 0.04,
      opacity: 0.2 + _random.nextDouble() * 0.6,
      color: _random.nextBool()
          ? (_random.nextBool() ? AppColors.fireOrange : AppColors.fireAmber)
          : AppColors.fireRed,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: AppColors.background,
          ),
        ),
        // Ambient heat glow in top and bottom corners
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.fireOrange.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -200,
          left: -100,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.fireRed.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Particle canvas
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              for (final p in _particles) {
                p.y -= p.speed * 0.016;
                p.x += sin(p.y * 10) * 0.001 + p.drift * 0.01;
                if (p.y < -0.05) {
                  p.y = 1.05;
                  p.x = _random.nextDouble();
                }
              }
              return CustomPaint(
                painter: _FirePainter(particles: _particles),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _EmberParticle {
  double x;
  double y;
  double size;
  double speed;
  double drift;
  double opacity;
  Color color;

  _EmberParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.drift,
    required this.opacity,
    required this.color,
  });
}

class _FirePainter extends CustomPainter {
  final List<_EmberParticle> particles;

  _FirePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      final center = Offset(p.x * size.width, p.y * size.height);
      canvas.drawCircle(center, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FirePainter oldDelegate) => true;
}
