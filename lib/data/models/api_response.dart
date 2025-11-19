import 'package:dio/dio.dart' show Headers;

class ApiResponse {
  final Headers headers;
  final bool success;
  final String message;
  final int status;
  final Object? data;
  final Object? error;

  ApiResponse({
    required this.headers,
    required this.success,
    required this.message,
    required this.status,
    required this.data,
    required this.error,
  });

  @override
  String toString() {
    return 'ApiResponse(\n'
        '\tsuccess: $success,\n'
        '\tmessage: $message,\n'
        '\tstatus: $status,\n'
        '\tdata: $data,\n'
        '\terror: $error,\n'
        ')';
  }
}
