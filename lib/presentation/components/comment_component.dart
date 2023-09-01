import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/data/entity/comment.dart';
import 'package:fashionstore/presentation/components/text_sender_component.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentComponent extends StatefulWidget {
  const CommentComponent({
    super.key,
    required this.comment,
    required this.needBorder,
    this.isReply = false,
  });

  final Comment comment;
  final bool needBorder;
  final bool isReply;

  @override
  State<StatefulWidget> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  bool reply = false;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: !widget.isReply ? 20.height : 10.height,
      ),
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
          10.verticalSpace,
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
                  SizedBox(
                    height: 35.height,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          reply = !reply;
                        });
                      },
                      child: Text(
                        !reply ? 'Reply' : 'Not reply',
                        style: TextStyle(
                          color: const Color(0xFF626262),
                          fontSize: 10.size,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                    ),
                  ),
                  2.horizontalSpace,
                  SizedBox(
                    height: 35.height,
                    child: IconButton(
                      color: const Color(0xFF626262),
                      onPressed: () {},
                      icon: ImageIcon(
                        size: 20.size,
                        color: const Color(0xFF626262),
                        const AssetImage('assets/icon/like_icon.png'),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          reply
              ? TextSenderComponent(
                  controller: controller,
                  sendAction: () {
                    BlocProvider.of<CommentBloc>(context).add(
                      OnAddCommentEvent(
                        controller.text,
                        widget.comment.productColor,
                        widget.comment.productId,
                        widget.comment.id,
                      ),
                    );
                  },
                )
              : const SizedBox(),
          !widget.isReply
              ? Container(
                  margin: EdgeInsets.only(left: 10.width),
                  child: BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, commentState) {
                      List<Comment> repCommentList =
                          BlocProvider.of<CommentBloc>(context)
                              .replyCommentList
                              .where((element) =>
                                  element.replyOn == widget.comment.replyOn)
                              .toList();

                      int selectedId = BlocProvider.of<CommentBloc>(context)
                          .selectedCommentId;

                      if (commentState is CommentLoadingState &&
                          selectedId == widget.comment.id) {
                        return UiRender.loadingCircle();
                      } else if (commentState is CommentReplyListLoadedState &&
                          selectedId == widget.comment.id) {
                        repCommentList = commentState.commentList;

                        return Column(
                          children: List<Widget>.generate(
                            repCommentList.length,
                            (index) => CommentComponent(
                              comment: repCommentList[index],
                              isReply: true,
                              needBorder: false,
                            ),
                          ),
                        );
                      }

                      return widget.comment.replyQuantity > 0
                          ? GestureDetector(
                              onTap: () {
                                BlocProvider.of<CommentBloc>(context).add(
                                  OnLoadCommentListEvent(
                                    productColor: widget.comment.productColor,
                                    productId: widget.comment.productId,
                                    replyOn: widget.comment.id,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ImageIcon(
                                    color: const Color(0xFF979797),
                                    size: 15.size,
                                    const AssetImage(
                                        'assets/icon/reply_icon.png'),
                                  ),
                                  Text(
                                    'See ${widget.comment.replyQuantity} other replies',
                                    style: TextStyle(
                                      color: const Color(0xFF979797),
                                      fontSize: 10.size,
                                      fontWeight: FontWeight.w400,
                                      height: 2,
                                      fontFamily: 'Work Sans',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
