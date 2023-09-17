// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_payment_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlinePaymentInfo _$OnlinePaymentInfoFromJson(Map<String, dynamic> json) =>
    OnlinePaymentInfo(
      json['content'] as String,
      (json['moneyAmount'] as num).toDouble(),
      OnlinePaymentInfo.fromJson(json['receiverInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OnlinePaymentInfoToJson(OnlinePaymentInfo instance) =>
    <String, dynamic>{
      'content': instance.content,
      'moneyAmount': instance.moneyAmount,
      'receiverInfo': instance.receiverInfo,
    };
