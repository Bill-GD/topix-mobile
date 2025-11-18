import 'package:flutter/foundation.dart';

enum FontSize {
  xl(48),
  large(32),
  medium(24),
  mediumSmall(20),
  small(16),
  xs(12);

  final double size;

  const FontSize(this.size);

  double call() => size;
}

class Constants {
  static final emailVerificationEnabled = ValueNotifier(false);
}