// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      json['productId'] as int,
      json['name'] as String,
      json['color'] as String?,
      json['size'] as String?,
      (json['sellingPrice'] as num).toDouble(),
      json['quantity'] as int,
      (json['discount'] as num).toDouble(),
      json['image1'] as String,
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'color': instance.color,
      'size': instance.size,
      'sellingPrice': instance.sellingPrice,
      'quantity': instance.quantity,
      'discount': instance.discount,
      'image1': instance.image1,
    };
