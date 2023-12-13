// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghn_shipping_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GhnShippingService _$GhnShippingServiceFromJson(Map<String, dynamic> json) =>
    GhnShippingService(
      json['service_id'] as int,
      json['short_name'] as String,
      json['service_type_id'] as int,
    );

Map<String, dynamic> _$GhnShippingServiceToJson(GhnShippingService instance) =>
    <String, dynamic>{
      'service_id': instance.service_id,
      'short_name': instance.short_name,
      'service_type_id': instance.service_type_id,
    };
