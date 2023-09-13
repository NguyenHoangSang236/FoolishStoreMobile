import 'package:json_annotation/json_annotation.dart';

part 'cart_checkout.g.dart';

@JsonSerializable()
class CartCheckout {
  final double subtotal;
  final double shippingFee;
  final double total;

  CartCheckout(this.subtotal, this.shippingFee, this.total);

  factory CartCheckout.fromJson(Map<String, dynamic> json) =>
      _$CartCheckoutFromJson(json);

  Map<String, dynamic> toJson() => _$CartCheckoutToJson(this);
}
