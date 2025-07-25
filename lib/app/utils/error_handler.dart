import 'package:benevolent_crm_app/app/utils/api_exceptions.dart';
import 'package:dio/dio.dart';

class ErrorHandler {
  static ApiException handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else {
      return ApiException('Unexpected error occurred: ${error.toString()}');
    }
  }

  static ApiException _handleDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final errorData = error.response?.data;
    String message = 'Server error occurred (Method is not allowed)';
    String? errorCode;

    if (errorData is Map && errorData.containsKey('error')) {
      final errorObj = errorData['error'];
      if (errorObj is Map) {
        final errors = errorObj.entries
            .map(
              (e) =>
                  '${e.key}: ${e.value is List ? e.value.join(', ') : e.value}',
            )
            .join('; ');
        message = errors.isNotEmpty ? errors : 'Validation error occurred';
        errorCode = errorData['error_code']?.toString();
      } else {
        message = errorObj.toString();
      }
    } else if (errorData is Map && errorData.containsKey('message')) {
      message = errorData['message'].toString();
      errorCode = errorData['error_code']?.toString();
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Request timed out. Please check your internet connection.',
          statusCode: statusCode,
          errorData: errorData,
          errorCode: errorCode,
          suggestRetry: true,
        );

      case DioExceptionType.badResponse:
        switch (statusCode) {
          case 400:
            return BadRequestException(
              message,
              statusCode: statusCode,
              errorData: errorData,
              errorCode: errorCode,
            );
          case 401:
            return UnauthorizedException(
              message,
              statusCode: statusCode,
              errorData: errorData,
              errorCode: errorCode,
            );
          case 403:
            return ForbiddenException(
              message,
              statusCode: statusCode,
              errorData: errorData,
              errorCode: errorCode,
            );
          case 404:
            return NotFoundException(
              message,
              statusCode: statusCode,
              errorData: errorData,
              errorCode: errorCode,
            );
          case 500:
            return ServerException(
              'Internal server error',
              statusCode: statusCode,
              errorData: errorData,
              errorCode: errorCode,
              suggestRetry: true,
            );
          default:
            return ApiException(
              message,
              statusCode: statusCode,
              errorData: errorData,
              errorCode: errorCode,
            );
        }

      case DioExceptionType.cancel:
        return CancelledException(
          'Request was cancelled',
          statusCode: statusCode,
          errorData: errorData,
          errorCode: errorCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please try again.',
          statusCode: statusCode,
          errorData: errorData,
          errorCode: errorCode,
          suggestRetry: true,
        );

      case DioExceptionType.badCertificate:
        return BadCertificateException(
          'Invalid SSL certificate',
          statusCode: statusCode,
          errorData: errorData,
          errorCode: errorCode,
        );

      default:
        return ApiException(
          'Unknown error occurred: ${error.message}',
          statusCode: statusCode,
          errorData: errorData,
          errorCode: errorCode,
        );
    }
  }
}
