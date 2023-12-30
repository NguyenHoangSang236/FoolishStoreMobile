import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(name: 'id')
  int id;
  String? title;
  String? content;
  String? topic;
  String? additionalData;
  bool seen;
  DateTime notificationDate;

  Notification(
    this.id,
    this.title,
    this.content,
    this.topic,
    this.additionalData,
    this.seen,
    this.notificationDate,
  );

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  String toString() {
    return 'Notification{id: $id, title: $title, content: $content, topic: $topic, additionalData: $additionalData, seen: $seen, notificationDate: $notificationDate}';
  }
}
