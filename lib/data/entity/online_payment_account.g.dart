// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_payment_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlinePaymentAccount _$OnlinePaymentAccountFromJson(
        Map<String, dynamic> json) =>
    OnlinePaymentAccount(
      json['id'] as int,
      json['receiverAccount'] as String,
      json['receiverName'] as String,
      json['additionalInfo'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$OnlinePaymentAccountToJson(
        OnlinePaymentAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiverAccount': instance.receiverAccount,
      'receiverName': instance.receiverName,
      'additionalInfo': instance.additionalInfo,
      'type': instance.type,
    };
