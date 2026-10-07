import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ShinyButtonVariant {
  primary,
  secondary,
  outline,
}

class ShinyButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final ShinyButtonVariant variant;
  final double? width;
  final double height;
  final double fontSize;
  final bool isLoading;

  const ShinyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = ShinyButtonVariant.primary,
    this.width,
    this.height = 56,
    this.fontSize = 16,
    this.isLoading = false,
  });

  @override
  State<ShinyButton> createState() => _ShinyButtonState();
}

class _ShinyButtonState extends State<ShinyButton> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.variant == ShinyButtonVariant.primary;
    final isOutline = widget.variant == ShinyButtonVariant.outline;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? AppColors.fireGradient
                  : (isOutline ? null : const LinearGradient(
                      colors: [Color(0xFF262630), Color(0xFF1E1E26)],
                    )),
              color: isOutline ? Colors.transparent : null,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isOutline
                    ? (_isHovered ? AppColors.fireOrange : AppColors.border)
                    : (isPrimary ? Colors.white.withValues(alpha: 0.2) : AppColors.border),
                width: isOutline ? 1.5 : 1.0,
              ),
              boxShadow: [
                if (isPrimary || _isHovered)
                  BoxShadow(
                    color: AppColors.fireOrange.withValues(alpha: isPrimary ? (_isHovered ? 0.45 : 0.3) : 0.2),
                    blurRadius: _isHovered ? 24 : 16,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Stack(
              children: [
                // Shimmer sweep across primary button
                if (isPrimary)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, _) {
                          return FractionalTranslation(
                            translation: Offset(_shimmerController.value * 3 - 1.5, 0),
                            child: Transform.rotate(
                              angle: 0.4,
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.28),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                // Content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) ...[
                                widget.icon!,
                                const SizedBox(width: 10),
                              ],
                              Text(
                                widget.text,
                                style: AppTypography.label(
                                  fontSize: widget.fontSize,
                                  weight: FontWeight.w800,
                                  color: isOutline
                                      ? (_isHovered ? AppColors.fireOrange : AppColors.textPrimary)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
