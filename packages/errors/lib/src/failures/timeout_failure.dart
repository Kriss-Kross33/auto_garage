// ignore_for_file: overridden_fields, comment_references

import 'package:errors/errors.dart';

/// {@template timeout_failure}
/// Failure which occurs when [TimeoutException] is thrown
/// {@endtemplate}
class TimeoutFailure extends Failure {
  /// {@macro timeout_failure}
  const TimeoutFailure({
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
  List<Object?> get props => [errorMessage];
}
