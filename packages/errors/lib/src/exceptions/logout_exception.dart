import 'package:errors/src/models/models.dart';

/// {@template login_exception}
///
/// {@endtemplate}
class LogoutException implements Exception {
  /// Logout error message.
  final String errorMessage;

  ///
  final ErrorDetails? errorDetails;

  /// {@macro login_exception}
  const LogoutException({
    required this.errorMessage,
    this.errorDetails,
  });
}
