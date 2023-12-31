import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final String result;
  final dynamic content;
  final String? message;

  ApiResponse(this.result, this.content, this.message);

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  @override
  String toString() {
    return 'ApiResponse{result: $result, content: $content, message: $message}';
  }
}
