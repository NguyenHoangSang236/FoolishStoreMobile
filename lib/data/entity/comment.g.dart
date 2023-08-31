// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['id'] as int,
      json['productId'] as int,
      json['productColor'] as String,
      json['customerId'] as int,
      json['name'] as String,
      json['avatar'] as String,
      json['commentContent'] as String,
      json['likeQuantity'] as int,
      json['replyOn'] as int,
      DateTime.parse(json['commentDate'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productColor': instance.productColor,
      'customerId': instance.customerId,
      'name': instance.name,
      'avatar': instance.avatar,
      'commentContent': instance.commentContent,
      'likeQuantity': instance.likeQuantity,
      'replyOn': instance.replyOn,
      'commentDate': instance.commentDate.toIso8601String(),
    };
