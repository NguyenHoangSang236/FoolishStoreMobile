// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressCodeRequest _$AddressCodeRequestFromJson(Map<String, dynamic> json) =>
    AddressCodeRequest(
      json['fromProvince'] as String,
      json['fromDistrict'] as String,
      json['fromWard'] as String,
      json['fromAddress'] as String,
      json['toProvince'] as String,
      json['toDistrict'] as String,
      json['toWard'] as String,
      json['toAddress'] as String,
    );

Map<String, dynamic> _$AddressCodeRequestToJson(AddressCodeRequest instance) =>
    <String, dynamic>{
      'fromProvince': instance.fromProvince,
      'fromDistrict': instance.fromDistrict,
      'fromWard': instance.fromWard,
      'fromAddress': instance.fromAddress,
      'toProvince': instance.toProvince,
      'toDistrict': instance.toDistrict,
      'toWard': instance.toWard,
      'toAddress': instance.toAddress,
    };
