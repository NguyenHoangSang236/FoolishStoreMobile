// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      json['id'] as int,
      json['title'] as String?,
      json['content'] as String?,
      json['topic'] as String?,
      json['additionalData'] as String?,
      json['seen'] as bool,
      DateTime.parse(json['notificationDate'] as String),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'topic': instance.topic,
      'additionalData': instance.additionalData,
      'seen': instance.seen,
      'notificationDate': instance.notificationDate.toIso8601String(),
    };
