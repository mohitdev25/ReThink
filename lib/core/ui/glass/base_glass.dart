import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';

/// The foundation of the Glassmorphism Engine.
/// Uses BackdropFilter for blur and gradients for depth.
class BaseGlass extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const BaseGlass({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.opacity = 0.1, // AppColors.glassWhite opacity
    this.borderRadius,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(24.0);

    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: br,
            color: Colors.white.withOpacity(opacity),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.0,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(opacity + 0.05),
                Colors.white.withOpacity(opacity),
              ],
            ),
            boxShadow: [
              // Subtle inner glow simulation
              BoxShadow(
                color: AppColors.glassInnerGlow,
                offset: const Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
