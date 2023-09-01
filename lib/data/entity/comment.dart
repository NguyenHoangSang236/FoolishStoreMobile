import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: 'id')
  int id;
  int productId;
  String productColor;
  int customerId;
  String name;
  String avatar;
  String commentContent;
  int likeQuantity;
  int replyOn;
  int replyQuantity;
  DateTime commentDate;

  Comment(
    this.id,
    this.productId,
    this.productColor,
    this.customerId,
    this.name,
    this.avatar,
    this.commentContent,
    this.likeQuantity,
    this.replyOn,
    this.commentDate,
    this.replyQuantity,
  );

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  String toString() {
    return 'Comment{id: $id, productId: $productId, productColor: $productColor, customerId: $customerId, name: $name, avatar: $avatar, commentContent: $commentContent, likeQuantity: $likeQuantity, replyOn: $replyOn, commentDate: $commentDate}';
  }
}
