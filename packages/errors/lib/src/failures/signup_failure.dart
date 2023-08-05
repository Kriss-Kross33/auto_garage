// ignore_for_file: overridden_fields

import 'package:errors/errors.dart';

/// {@template signup_failure}
/// Failure which occurs when [SignupException] is thrown
/// {@endtemplate}
class SignupFailure extends Failure {
  /// {@macro signup_failure}
  const SignupFailure({
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
