import 'package:flutter/material.dart' show BuildContext, ColorScheme, Theme;

import 'package:dio/dio.dart';
import 'package:theme_provider/theme_provider.dart' show ThemeProvider;

import 'package:topix/data/models/api_response.dart';
import 'package:topix/utils/helpers.dart' show range;

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

  void nextTheme() => ThemeProvider.controllerOf(this).nextTheme();

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension TimeAgo on DateTime {
  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String getTimeAgo([bool hasAgo = false]) {
    final diffInSec =
        ((DateTime.now().millisecondsSinceEpoch - millisecondsSinceEpoch) / 1000)
            .truncate();

    if (diffInSec > 1209600) {
      return '$day ${_monthNames[month - 1]}';
    }

    double interval = diffInSec / 604800;
    if (interval > 1) return '${interval.truncate()}w${hasAgo ? ' ago' : ''}';

    interval = diffInSec / 86400;
    if (interval > 1) return '${interval.truncate()}d${hasAgo ? ' ago' : ''}';

    interval = diffInSec / 3600;
    if (interval > 1) return '${interval.truncate()}h${hasAgo ? ' ago' : ''}';

    interval = diffInSec / 60;
    if (interval > 1) return '${interval.truncate()}m${hasAgo ? ' ago' : ''}';

    return 'now';
  }
}

extension WhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final i in range(0, length - 1)) {
      if (test(elementAt(i))) return elementAt(i);
    }
    return null;
  }
}
