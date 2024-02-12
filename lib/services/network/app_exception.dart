class AppException {
  int code = 0;
  String? message;
  Exception? innerException;
  StackTrace? stackTrace;

  AppException(this.code, this.message);

  AppException.withInner(this.code, this.message, this.stackTrace);

  @override
  String toString() {
    return 'AppException{code: $code, message: $message, innerException: $innerException, stackTrace: $stackTrace}';
  }
}
