// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_checkout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartCheckout _$CartCheckoutFromJson(Map<String, dynamic> json) => CartCheckout(
      (json['subtotal'] as num).toDouble(),
      (json['shippingFee'] as num).toDouble(),
      (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$CartCheckoutToJson(CartCheckout instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'shippingFee': instance.shippingFee,
      'total': instance.total,
    };
