import 'dart:math';
import 'package:flutter/material.dart';

/// 3D Flip animation using Matrix4 rotations.
/// Used for Flashcards in Spaced Repetition.
class Flip3D extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool showFrontSide;

  const Flip3D({
    super.key,
    required this.front,
    required this.back,
    required this.showFrontSide,
  });

  @override
  State<Flip3D> createState() => _Flip3DState();
}

class _Flip3DState extends State<Flip3D> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: widget.showFrontSide ? 0 : 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack, // Spring physics feel
      builder: (context, double value, child) {
        bool isFrontVisible = value < 0.5;
        double tilt = ((value - 0.5).abs() - 0.5) * 0.003;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, tilt) // Depth effect
            ..rotateY(value * pi),
          child: isFrontVisible
              ? widget.front
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: widget.back,
                ),
        );
      },
    );
  }
}
