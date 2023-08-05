// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:errors/src/models/models.dart';

/// {@template failure}
/// Represents an error which occurs in the app.
/// {@endtemplate}
abstract class Failure extends Equatable {
  /// {macro failure}
  const Failure({
    required this.errorMessage,
    this.errorDetails,
  });

  final ErrorDetails? errorDetails;

  /// Error message to display to user.
  final String errorMessage;
}
