class Result<T> {
  final bool success;
  final String message;
  final T data;

  Result._internal({required this.success, required this.message, required this.data});

  static Result<T> ok<T>(String message, T data) {
    return Result._internal(success: true, message: message, data: data);
  }

  static Result<Null> fail(String message) {
    return Result._internal(success: false, message: message, data: null);
  }
}
