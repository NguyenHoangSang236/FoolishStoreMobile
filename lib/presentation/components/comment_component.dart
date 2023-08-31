import 'package:fashionstore/data/entity/comment.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentComponent extends StatefulWidget {
  const CommentComponent({
    super.key,
    required this.comment,
    required this.needBorder,
  });

  final Comment comment;
  final bool needBorder;

  @override
  State<StatefulWidget> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.height),
      decoration: BoxDecoration(
        border: widget.needBorder
            ? const Border(
                bottom: BorderSide(
                  color: Color(0xFF979797),
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 30.size,
                    width: 30.size,
                    child: UiRender.buildCachedNetworkImage(
                      context,
                      borderRadius: BorderRadius.circular(50.radius),
                      ValueRender.getGoogleDriveImageUrl(widget.comment.avatar),
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    widget.comment.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.size,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                ],
              ),
              Text(
                widget.comment.commentDate.date,
                style: TextStyle(
                  color: const Color(0xFF979797),
                  fontSize: 11.size,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Work Sans',
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            widget.comment.commentContent,
            style: TextStyle(
              color: const Color(0xFF626262),
              fontSize: 11.size,
              fontWeight: FontWeight.w400,
              fontFamily: 'Work Sans',
            ),
          ),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.comment.likeQuantity} people liked this comment',
                style: TextStyle(
                  color: const Color(0xFF979797),
                  fontSize: 10.size,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Work Sans',
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Reply',
                      style: TextStyle(
                        color: const Color(0xFF626262),
                        fontSize: 10.size,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Work Sans',
                      ),
                    ),
                  ),
                  2.horizontalSpace,
                  IconButton(
                    color: const Color(0xFF626262),
                    onPressed: () {},
                    icon: ImageIcon(
                      size: 20.size,
                      color: const Color(0xFF626262),
                      const AssetImage('assets/icon/like_icon.png'),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
