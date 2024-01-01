import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonSerializable()
class Delivery {
  int id;
  String shippingOrderCode;
  DateTime? shipDate;
  DateTime? expectedDeliveryTime;

  Delivery(
    this.id,
    this.shippingOrderCode,
    this.shipDate,
    this.expectedDeliveryTime,
  );

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}
