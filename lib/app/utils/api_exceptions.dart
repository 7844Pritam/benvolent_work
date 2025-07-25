class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;
  final String? errorCode;
  final bool suggestRetry;

  ApiException(
    this.message, {
    this.statusCode,
    this.errorData,
    this.errorCode,
    this.suggestRetry = false,
  });

  @override
  String toString() {
    final parts = <String>[];

    if (statusCode != null) parts.add('Status $statusCode');
    if (errorCode != null) parts.add('Code $errorCode');

    final prefix = parts.isNotEmpty ? '[${parts.join(' | ')}] ' : '';
    return '$prefix$message';
  }
}

class TimeoutException extends ApiException {
  TimeoutException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
    required bool suggestRetry,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: true, // Timeouts often warrant a retry
       );
}

class BadRequestException extends ApiException {
  BadRequestException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: false, // Bad requests typically need user correction
       );
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: false, // Unauthorized requires re-authentication
       );
}

class ForbiddenException extends ApiException {
  ForbiddenException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: false, // Forbidden indicates access issue
       );
}

class NotFoundException extends ApiException {
  NotFoundException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: false, // Not found indicates invalid resource
       );
}

class ServerException extends ApiException {
  ServerException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
    required bool suggestRetry,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: true, // Server errors might resolve on retry
       );
}

class NetworkException extends ApiException {
  NetworkException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
    required bool suggestRetry,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: true, // Network issues might resolve on retry
       );
}

class CancelledException extends ApiException {
  CancelledException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: false, // Cancelled requests shouldn't retry
       );
}

class BadCertificateException extends ApiException {
  BadCertificateException(
    String message, {
    int? statusCode,
    dynamic errorData,
    String? errorCode,
  }) : super(
         message,
         statusCode: statusCode,
         errorData: errorData,
         errorCode: errorCode,
         suggestRetry: false, // Certificate issues require manual resolution
       );
}
