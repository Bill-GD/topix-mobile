import 'package:flutter/material.dart' show BuildContext, ColorScheme, Theme;

import 'package:dio/dio.dart';
import 'package:theme_provider/theme_provider.dart' show ThemeProvider;

import 'package:topix/data/models/api_response.dart';

extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());

  Duration get ms => Duration(milliseconds: round());

  Duration get milliseconds => ms;

  Duration get seconds => Duration(seconds: round());

  Duration get minutes => Duration(minutes: round());

  Duration get hours => Duration(hours: round());

  Duration get days => Duration(days: round());
}

extension ParseApiResponse on Response {
  ApiResponse toApiResponse() {
    final apiResponse = data as Map<String, dynamic>;

    return ApiResponse(
      headers: headers,
      success: apiResponse['success'] as bool,
      message: apiResponse['message'] as String,
      status: apiResponse['status'] as int,
      data: apiResponse['data'],
      error: apiResponse['error'],
    );
  }
}

extension ThemeHelper on BuildContext {
  bool get isDarkMode => ThemeProvider.themeOf(this).id.contains('dark');

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
