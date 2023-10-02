import 'package:json_annotation/json_annotation.dart';

part 'delivery_type.g.dart';

@JsonSerializable()
class DeliveryType {
  @JsonKey(name: 'id')
  int id;
  String name;
  double price;
  String condition;

  DeliveryType(this.id, this.name, this.price, this.condition);

  factory DeliveryType.fromJson(Map<String, dynamic> json) =>
      _$DeliveryTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryTypeToJson(this);
}
