import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isSelected;
  final bool glowOnHover;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.isSelected = false,
    this.glowOnHover = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.isSelected
        ? AppColors.fireOrange
        : (_isHovered && widget.glowOnHover
            ? AppColors.fireOrange.withValues(alpha: 0.6)
            : (widget.borderColor ?? AppColors.border));

    final effectiveBgColor = widget.backgroundColor ??
        (widget.isSelected
            ? AppColors.surfaceElevated.withValues(alpha: 0.95)
            : (_isHovered
                ? AppColors.surfaceElevated.withValues(alpha: 0.85)
                : AppColors.surface.withValues(alpha: 0.7)));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: effectiveBorderColor,
            width: widget.isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            if (widget.isSelected || (_isHovered && widget.glowOnHover))
              BoxShadow(
                color: AppColors.fireOrange.withValues(alpha: widget.isSelected ? 0.25 : 0.15),
                blurRadius: widget.isSelected ? 24 : 16,
                spreadRadius: widget.isSelected ? 1 : 0,
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: AppColors.fireOrange.withValues(alpha: 0.1),
            highlightColor: AppColors.fireOrange.withValues(alpha: 0.05),
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
