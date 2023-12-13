// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressCode _$AddressCodeFromJson(Map<String, dynamic> json) => AddressCode(
      fromDistrictId: json['fromDistrictId'] as int?,
      toDistrictId: json['toDistrictId'] as int?,
      fromProvinceId: json['fromProvinceId'] as int?,
      toProvinceId: json['toProvinceId'] as int?,
      fromWardCode: json['fromWardCode'] as String?,
      toWardCode: json['toWardCode'] as String?,
    );

Map<String, dynamic> _$AddressCodeToJson(AddressCode instance) =>
    <String, dynamic>{
      'fromDistrictId': instance.fromDistrictId,
      'toDistrictId': instance.toDistrictId,
      'fromProvinceId': instance.fromProvinceId,
      'toProvinceId': instance.toProvinceId,
      'fromWardCode': instance.fromWardCode,
      'toWardCode': instance.toWardCode,
    };
