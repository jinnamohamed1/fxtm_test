import 'package:fxtm_test_app/core/errors/error_types.dart';

class AppException implements Exception {
  final String message;
  final ForexErrorType type;

  AppException({required this.message, required this.type});
}

class NetworkException extends AppException {
  NetworkException({super.message = 'Network connection error'})
      : super(type: ForexErrorType.network);
}

class AuthenticationException extends AppException {
  AuthenticationException({super.message = 'Authentication error'})
      : super(type: ForexErrorType.authentication);
}

class ServerException extends AppException {
  ServerException({super.message = 'Server error'})
      : super(type: ForexErrorType.server);
}

class UnknownException extends AppException {
  UnknownException({super.message = 'An unknown error occurred'})
      : super(type: ForexErrorType.unknown);
}
