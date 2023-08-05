import 'package:errors/src/models/models.dart';

/// {@template signup_exception}
///
/// {@endtemplate}
class SignupException implements Exception {
  /// Signup error message.
  final String errorMessage;

  ///
  final ErrorDetails? errorDetails;

  /// {@macro signup_exception}
  const SignupException({
    required this.errorMessage,
    this.errorDetails,
  });
}
