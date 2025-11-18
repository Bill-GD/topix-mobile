import 'package:dio/dio.dart';

import 'package:topix/utils/api_response.dart';

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
