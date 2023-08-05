// ignore_for_file: overridden_fields

import 'package:errors/src/errors.dart';

/// {@template forced_update_failure}
/// Failure which occurs when there is a failure in trying
/// to make the user force update the app.
/// {@endtemplate}
class ForcedUpdateFailure extends Failure {
  /// {@macro forced_update_failure}
  const ForcedUpdateFailure({
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
  List<Object?> get props => [errorMessage, errorDetails];
}
