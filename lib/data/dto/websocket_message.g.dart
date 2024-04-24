// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebsocketMessage _$WebsocketMessageFromJson(Map<String, dynamic> json) =>
    WebsocketMessage(
      sender: json['sender'] as String?,
      content: json['content'],
      type: $enumDecodeNullable(_$WebsocketEnumEnumMap, json['type']),
    );

Map<String, dynamic> _$WebsocketMessageToJson(WebsocketMessage instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'content': instance.content,
      'type': _$WebsocketEnumEnumMap[instance.type],
    };

const _$WebsocketEnumEnumMap = {
  WebsocketEnum.LEAVE: 'LEAVE',
  WebsocketEnum.JOIN: 'JOIN',
  WebsocketEnum.POST_COMMENT: 'POST_COMMENT',
  WebsocketEnum.TYPING_COMMENT: 'TYPING_COMMENT',
  WebsocketEnum.LIKE_COMMENT: 'LIKE_COMMENT',
};
