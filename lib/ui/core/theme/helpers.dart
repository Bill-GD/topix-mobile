import 'package:flutter/material.dart' show BuildContext;

import 'package:theme_provider/theme_provider.dart' show ThemeProvider;

bool isDarkMode(BuildContext context) {
  return ThemeProvider.themeOf(context).id.contains('dark');
}
