// ignore_for_file: overridden_fields

import 'package:errors/errors.dart';

/// {@template server_failure}
/// Failure which occurs when an Exception is thrown from server
/// {@endtemplate}
class ServerFailure extends Failure {
  /// {@macro server_failure}
  const ServerFailure({
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
