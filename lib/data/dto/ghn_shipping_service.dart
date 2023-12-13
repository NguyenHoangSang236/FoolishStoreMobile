import 'package:json_annotation/json_annotation.dart';

part 'ghn_shipping_service.g.dart';

@JsonSerializable()
class GhnShippingService {
  int service_id;
  String short_name;
  int service_type_id;

  GhnShippingService(this.service_id, this.short_name, this.service_type_id);

  factory GhnShippingService.fromJson(Map<String, dynamic> json) =>
      _$GhnShippingServiceFromJson(json);

  Map<String, dynamic> toJson() => _$GhnShippingServiceToJson(this);

  @override
  String toString() {
    return 'GhnShippingService{service_id: $service_id, short_name: $short_name, service_type_id: $service_type_id}';
  }
}
