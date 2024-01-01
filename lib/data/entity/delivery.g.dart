// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      json['id'] as int,
      json['shippingOrderCode'] as String,
      json['shipDate'] == null
          ? null
          : DateTime.parse(json['shipDate'] as String),
      json['expectedDeliveryTime'] == null
          ? null
          : DateTime.parse(json['expectedDeliveryTime'] as String),
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'id': instance.id,
      'shippingOrderCode': instance.shippingOrderCode,
      'shipDate': instance.shipDate?.toIso8601String(),
      'expectedDeliveryTime': instance.expectedDeliveryTime?.toIso8601String(),
    };
