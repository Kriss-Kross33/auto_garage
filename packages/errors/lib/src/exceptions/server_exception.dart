import 'package:errors/src/models/models.dart';

/// {@template server_exception}
///
/// {@endtemplate}
class ServerException implements Exception {
  /// Server error message.
  final String errorMessage;

  ///

  final ErrorDetails? errorDetails;

  /// {@macro server_exception}
  const ServerException({
    required this.errorMessage,
    this.errorDetails,
  });

  @override
  String toString() => errorMessage;
}
