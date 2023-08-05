// ignore_for_file: overridden_fields

import 'package:errors/src/errors.dart';

/// {@template login_failure}
/// Failure which occurs when [LoginException] is thrown
/// {@endtemplate}
class LoginFailure extends Failure {
  /// {@macro login_failure}
  const LoginFailure({
    required this.errorMessage,
    this.errorDetails,
  }) : super(
          errorMessage: errorMessage,
          errorDetails: errorDetails,
        );
  @override
  final String errorMessage;

  @override
  final ErrorDetails? errorDetails;
  @override
  List<Object?> get props => [
        errorMessage,
        errorDetails,
      ];
}
