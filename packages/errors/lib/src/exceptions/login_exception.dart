import 'package:errors/src/models/models.dart';

/// {@template login_exception}
///
/// {@endtemplate}
class LoginException implements Exception {
  /// Login error message.
  final String errorMessage;

  ///
  final ErrorDetails? errorDetails;

  /// {@macro login_exception}
  const LoginException({
    required this.errorMessage,
    this.errorDetails,
  });
}
