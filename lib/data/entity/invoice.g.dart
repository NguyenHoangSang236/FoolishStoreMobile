// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      json['id'] as int,
      DateTime.parse(json['invoiceDate'] as String),
      json['payDate'] == null
          ? null
          : DateTime.parse(json['payDate'] as String),
      json['orderStatus'] as String?,
      json['paymentStatus'] as String,
      json['paymentMethod'] as String,
      json['currency'] as String,
      json['intent'] as String?,
      json['description'] as String?,
      (json['refundPercentage'] as num).toDouble(),
      (json['totalPrice'] as num).toDouble(),
      json['reason'] as String?,
      json['address'] as String?,
      json['districtId'] as int?,
      json['wardCode'] as String?,
      (json['deliveryFee'] as num).toDouble(),
      json['adminAcceptance'] as String,
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'invoiceDate': instance.invoiceDate.toIso8601String(),
      'payDate': instance.payDate?.toIso8601String(),
      'orderStatus': instance.orderStatus,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'currency': instance.currency,
      'intent': instance.intent,
      'description': instance.description,
      'refundPercentage': instance.refundPercentage,
      'totalPrice': instance.totalPrice,
      'reason': instance.reason,
      'address': instance.address,
      'districtId': instance.districtId,
      'wardCode': instance.wardCode,
      'deliveryFee': instance.deliveryFee,
      'adminAcceptance': instance.adminAcceptance,
    };
