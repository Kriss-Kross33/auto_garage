// ignore_for_file: overridden_fields

import 'package:errors/src/errors.dart';

/// {@template cache_failure}
/// Failure which occurs when [CacheException] is thrown
/// {@endtemplate}
class CacheFailure extends Failure {
  /// {@macro cache_failure}
  const CacheFailure({
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
