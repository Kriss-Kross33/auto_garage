// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:errors/errors.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_details.g.dart';

///
///
///
@JsonSerializable(explicitToJson: true)
class ErrorDetails extends Equatable {
  final String name;
  final String message;
  final int code;
  final String? type;
  final List<ErrorData>? data;

  const ErrorDetails({
    required this.name,
    required this.message,
    required this.code,
    this.type,
    this.data,
  });

  factory ErrorDetails.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDetailsToJson(this);

  @override
  List<Object?> get props => [
        name,
        message,
        code,
        type,
        data,
      ];
}
