import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    if (err.response != null) {
      final statusCode = err.response?.statusCode ?? 0;

      if (statusCode >= 300) {
        // Attempt to extract backend error message
        errorMessage =
            err.response?.data['message']?.toString() ??
            err.response?.statusMessage ??
            'Unknown server error';
      } else {
        errorMessage = 'Something went wrong';
      }
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      errorMessage = 'Request timeout. Please try again.';
    } else if (err.type == DioExceptionType.badCertificate ||
        err.type == DioExceptionType.badResponse) {
      errorMessage = 'Bad server response.';
    } else {
      errorMessage = 'No connection. Please check your internet.';
    }

    // Create a new DioException with the custom message
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: errorMessage,
      type: err.type,
    );

    // Pass custom error to the next handler
    super.onError(customError, handler);
  }
}
