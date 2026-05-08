import 'package:flutter/material.dart';
import 'package:rethink_app/core/ui/glass/base_glass.dart';
import 'package:rethink_app/core/ui/motion/scale_tap.dart';

/// Interactive glass widget that shrinks when tapped.
class InteractiveGlass extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;

  const InteractiveGlass({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.blur = 20.0,
    this.opacity = 0.1,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onTap: onTap,
      onLongPress: onLongPress,
      child: BaseGlass(
        blur: blur,
        opacity: opacity,
        padding: padding,
        child: child,
      ),
    );
  }
}
