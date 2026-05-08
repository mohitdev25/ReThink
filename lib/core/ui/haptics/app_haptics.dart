import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppHaptics {
  /// Light tap, used for navigation and minor interactions.
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium tap, used for confirming a selection or state change.
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy tap, used for major completions (e.g., finishing a habit).
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Used when something snaps into place or a gesture completes.
  static void selection() {
    HapticFeedback.selectionClick();
  }
}
