// ignore_for_file: overridden_fields

import 'package:errors/src/errors.dart';

/// {@templaten unknown_platform_failure}
/// Failure which occurs when the platform is unknown
/// {@endtemplate}
class UnknownPlatformFailure extends Failure {
  /// {@macro unknown_platform_failure}
  const UnknownPlatformFailure({
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
