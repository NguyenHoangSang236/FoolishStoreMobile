import 'package:json_annotation/json_annotation.dart';

part 'address_code_request.g.dart';

@JsonSerializable()
class AddressCodeRequest {
  String fromProvince;
  String fromDistrict;
  String fromWard;
  String fromAddress;
  String toProvince;
  String toDistrict;
  String toWard;
  String toAddress;

  AddressCodeRequest({
    required this.fromProvince,
    required this.fromDistrict,
    required this.fromWard,
    required this.fromAddress,
    required this.toProvince,
    required this.toDistrict,
    required this.toWard,
    required this.toAddress,
  });

  factory AddressCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$AddressCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddressCodeRequestToJson(this);

  @override
  String toString() {
    return 'AddressCodeRequest{fromProvince: $fromProvince, fromDistrict: $fromDistrict, fromWard: $fromWard, fromAddress: $fromAddress, toProvince: $toProvince, toDistrict: $toDistrict, toWard: $toWard, toAddress: $toAddress}';
  }
}
