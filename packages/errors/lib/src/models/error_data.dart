// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ErrorData extends Equatable {
  final String? type;
  final String message;
  final String? field;

  const ErrorData({
    this.type,
    required this.message,
    this.field,
  });

  factory ErrorData.fromJson(Map<String, dynamic> json) =>
      _$ErrorDataFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDataToJson(this);

  @override
  List<Object?> get props => [
        type,
        message,
        field,
      ];
}
