import 'package:errors/src/models/models.dart';

/// {@template unknown_exception}
///
/// {@endtemplate}
class UnknownException implements Exception {
  /// Unknown error message.
  final String errorMessage;

  ///
  final ErrorDetails? errorDetails;

  /// {@macro unknown_exception}
  const UnknownException({
    required this.errorMessage,
    this.errorDetails,
  });
}
