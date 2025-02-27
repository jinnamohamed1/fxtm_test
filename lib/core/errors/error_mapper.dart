import 'package:fxtm_test_app/core/errors/exceptions.dart';

class ErrorMapper {
  static AppException mapToAppException(dynamic error) {
    if (error is AppException) {
      return error; // Already converted
    }

    final errorMessage = error.toString();

    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('SocketException')) {
      return NetworkException(message: errorMessage);
    } else if (errorMessage.contains('authentication') ||
        errorMessage.contains('token') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('401')) {
      return AuthenticationException(message: errorMessage);
    } else if (errorMessage.contains('server') ||
        errorMessage.contains('500')) {
      return ServerException(message: errorMessage);
    }

    // Use the concrete UnknownException instead
    return UnknownException(message: errorMessage);
  }
}
