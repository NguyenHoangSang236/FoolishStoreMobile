import 'package:fashionstore/data/enum/websocket_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_message.g.dart';

@JsonSerializable()
class WebsocketMessage {
  String? sender;
  dynamic content;
  WebsocketEnum? type;

  WebsocketMessage({this.sender, this.content, this.type});

  factory WebsocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebsocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$WebsocketMessageToJson(this);

  @override
  String toString() {
    return '{sender: $sender, content: $content, type: $type}';
  }
}
