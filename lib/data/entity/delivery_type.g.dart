// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryType _$DeliveryTypeFromJson(Map<String, dynamic> json) => DeliveryType(
      json['id'] as int,
      json['name'] as String,
      (json['price'] as num).toDouble(),
      json['condition'] as String,
    );

Map<String, dynamic> _$DeliveryTypeToJson(DeliveryType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'condition': instance.condition,
    };
