// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['id'] as int,
      json['productId'] as num?,
      json['name'] as String,
      (json['sellingPrice'] as num).toDouble(),
      (json['discount'] as num).toDouble(),
      json['brand'] as String,
      json['size'] as String,
      json['color'] as String,
      json['availableQuantity'] as int,
      json['image1'] as String?,
      json['image2'] as String?,
      json['image3'] as String?,
      json['image4'] as String?,
      (json['overallRating'] as num).toDouble(),
      json['description'] as String?,
      json['product_id'] as num?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'sellingPrice': instance.sellingPrice,
      'discount': instance.discount,
      'brand': instance.brand,
      'size': instance.size,
      'color': instance.color,
      'availableQuantity': instance.availableQuantity,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'image4': instance.image4,
      'description': instance.description,
      'overallRating': instance.overallRating,
      'product_id': instance.product_id,
    };
