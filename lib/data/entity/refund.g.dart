// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Refund _$RefundFromJson(Map<String, dynamic> json) => Refund(
      json['id'] as int,
      (json['refundMoney'] as num).toDouble(),
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['evidentImage'] as String?,
      json['status'] as String,
    );

Map<String, dynamic> _$RefundToJson(Refund instance) => <String, dynamic>{
      'id': instance.id,
      'refundMoney': instance.refundMoney,
      'date': instance.date?.toIso8601String(),
      'evidentImage': instance.evidentImage,
      'status': instance.status,
    };
