// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressCodeRequest _$AddressCodeRequestFromJson(Map<String, dynamic> json) =>
    AddressCodeRequest(
      fromProvince: json['fromProvince'] as String,
      fromDistrict: json['fromDistrict'] as String,
      fromWard: json['fromWard'] as String,
      fromAddress: json['fromAddress'] as String,
      toProvince: json['toProvince'] as String,
      toDistrict: json['toDistrict'] as String,
      toWard: json['toWard'] as String,
      toAddress: json['toAddress'] as String,
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
