import 'package:json_annotation/json_annotation.dart';

part 'address_code.g.dart';

@JsonSerializable()
class AddressCode {
  int? fromDistrictId;
  int? toDistrictId;
  int? fromProvinceId;
  int? toProvinceId;
  String? fromWardCode;
  String? toWardCode;

  AddressCode({
    required this.fromDistrictId,
    required this.toDistrictId,
    required this.fromProvinceId,
    required this.toProvinceId,
    required this.fromWardCode,
    required this.toWardCode,
  });

  factory AddressCode.fromJson(Map<String, dynamic> json) =>
      _$AddressCodeFromJson(json);

  Map<String, dynamic> toJson() => _$AddressCodeToJson(this);

  @override
  String toString() {
    return 'AddressCode{fromDistrictId: $fromDistrictId, toDistrictId: $toDistrictId, fromProvinceId: $fromProvinceId, toProvinceId: $toProvinceId, fromWardCode: $fromWardCode, toWardCode: $toWardCode}';
  }
}
