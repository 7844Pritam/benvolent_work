// import 'package:benevolent_crm_app/app/utils/api_exceptions.dart';
// import 'package:dio/dio.dart';

// class ErrorHandler {
//   static ApiException handle(dynamic error) {
//     if (error is DioException) {
//       return _handleDioException(error);
//     } else {
//       return ApiException('Unexpected error occurred: ${error.toString()}');
//     }
//   }

//   static ApiException _handleDioException(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return TimeoutException(
//           'Request timed out. Please check your internet connection.',
//         );

//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         final message =
//             error.response?.data['message'] ?? 'Server error occurred';

//         switch (statusCode) {
//           case 400:
//             return BadRequestException(message);
//           case 401:
//             return UnauthorizedException(message);
//           case 403:
//             return ForbiddenException(message);
//           case 404:
//             return NotFoundException(message);
//           case 500:
//             return ServerException('Internal server error');
//           default:
//             return ApiException('Server error: $statusCode - $message');
//         }

//       case DioExceptionType.cancel:
//         return ApiException('Request was cancelled');

//       case DioExceptionType.connectionError:
//         return NetworkException('No internet connection. Please try again.');

//       case DioExceptionType.badCertificate:
//         return ApiException('Invalid SSL certificate');

//       default:
//         return ApiException('Unknown error occurred: ${error.message}');
//     }
//   }
// }
