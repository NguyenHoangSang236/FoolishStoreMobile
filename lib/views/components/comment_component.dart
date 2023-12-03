import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/data/entity/comment.dart';
import 'package:fashionstore/views/components/text_sender_component.dart';
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
    this.isLiked = false,
    required this.productId,
  });

  final Comment comment;
  final bool needBorder;
  final bool isLiked;
  final int productId;

  @override
  State<StatefulWidget> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  bool replyButtonPressed = false;
  int currentPage = 1;
  final TextEditingController controller = TextEditingController();
  late bool isReply;
  late Comment currentComment;

  void reloadCommentYouLikeIdList() {
    context.read<CommentBloc>().add(
          OnLoadCommentIdYouLikedListEvent(
            productColor: widget.comment.productColor,
            productId: widget.comment.productId,
          ),
        );
  }

  void onPressLikeButton() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        context.read<CommentBloc>().add(
              OnReactCommentEvent(widget.comment.id),
            );
      },
    );
  }

  void onPressSendButton() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        context.read<CommentBloc>().add(
              replyButtonPressed == true
                  ? OnAddReplyCommentEvent(
                      controller.text,
                      widget.comment.productColor,
                      widget.comment.productId,
                      widget.comment.id,
                    )
                  : OnAddCommentEvent(
                      controller.text,
                      widget.comment.productColor,
                      widget.productId,
                      widget.comment.id,
                    ),
            );
        controller.clear();
      },
    );
  }

  void onPressSeePreviousComments() {
    setState(() {
      currentPage++;
    });

    context.read<CommentBloc>().add(
          OnLoadReplyCommentListEvent(
            productColor: widget.comment.productColor,
            productId: widget.comment.productId,
            page: currentPage,
            replyOn: widget.comment.id,
          ),
        );
  }

  @override
  void initState() {
    currentComment = widget.comment;
    isReply = widget.comment.replyOn != 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: !isReply ? 20.height : 10.height,
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
                      ValueRender.getGoogleDriveImageUrl(currentComment.avatar),
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    currentComment.name,
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
                currentComment.commentDate.date,
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
            currentComment.commentContent,
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
                '${currentComment.likeQuantity} people liked this comment',
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
                          replyButtonPressed = !replyButtonPressed;
                        });
                      },
                      child: Text(
                        !replyButtonPressed ? 'Reply' : 'Stop reply',
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
                      onPressed: onPressLikeButton,
                      icon: ImageIcon(
                        size: 20.size,
                        color: !widget.isLiked
                            ? const Color(0xFF626262)
                            : Colors.orange,
                        const AssetImage('assets/icon/like_icon.png'),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          replyButtonPressed
              ? TextSenderComponent(
                  controller: controller,
                  sendAction: onPressSendButton,
                )
              : const SizedBox(),
          !isReply
              ? Container(
                  margin: EdgeInsets.only(left: 10.width),
                  child: BlocConsumer<CommentBloc, CommentState>(
                    listener:
                        (BuildContext context, CommentState commentState) {
                      if (commentState is CommentReplyAddedState) {
                        if (commentState.replyOn == currentComment.id) {
                          UiRender.showSnackBar(
                            context,
                            commentState.message,
                          );

                          setState(() {
                            currentComment.replyQuantity++;
                          });

                          context.read<CommentBloc>().add(
                                OnLoadReplyCommentListEvent(
                                  productColor: currentComment.productColor,
                                  productId: currentComment.productId,
                                  page: currentPage,
                                  replyOn: currentComment.id,
                                ),
                              );
                        }
                      } else if (commentState is CommentReactedState) {
                        reloadCommentYouLikeIdList();
                      }
                    },
                    builder: (context, commentState) {
                      List<Comment> repCommentList = context
                          .read<CommentBloc>()
                          .replyCommentList
                          .where(
                              (element) => element.replyOn == currentComment.id)
                          .toList();

                      int selectedId =
                          context.read<CommentBloc>().selectedCommentId;

                      List<int> commentYouLikedIdList =
                          context.read<CommentBloc>().commentYouLikedIdList;

                      if (commentState is CommentIdYouLikedListLoadedState) {
                        commentYouLikedIdList = commentState.commentIdList;
                      } else if (commentState is CommentReplyLoadingState &&
                          selectedId == currentComment.id) {
                        return UiRender.loadingCircle();
                      } else if (commentState is CommentReplyListLoadedState &&
                          selectedId == currentComment.id) {
                        repCommentList = commentState.commentList;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          5.verticalSpace,
                          if (currentComment.replyQuantity > 0 &&
                              repCommentList.isNotEmpty) ...[
                            GestureDetector(
                              onTap: onPressSeePreviousComments,
                              child: repCommentList.isNotEmpty
                                  ? repCommentList.length % 5 == 0
                                      ? Text(
                                          'See previous replies',
                                          style: TextStyle(
                                            color: const Color(0xFF979797),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 12.size,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Work Sans',
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                            ),
                            5.verticalSpace,
                            ...List<Widget>.generate(
                              repCommentList.length,
                              (index) => CommentComponent(
                                isLiked: commentYouLikedIdList.indexWhere(
                                      (element) =>
                                          element == repCommentList[index].id,
                                    ) >=
                                    0,
                                comment: repCommentList[index],
                                productId: widget.productId,
                                needBorder: false,
                              ),
                            ),
                          ] else if (currentComment.replyQuantity > 0 &&
                              repCommentList.isEmpty) ...[
                            GestureDetector(
                              onTap: () {
                                context.read<CommentBloc>().add(
                                      OnLoadReplyCommentListEvent(
                                        productColor:
                                            currentComment.productColor,
                                        productId: currentComment.productId,
                                        replyOn: currentComment.id,
                                      ),
                                    );
                              },
                              child: Row(
                                children: [
                                  ImageIcon(
                                    color: const Color(0xFF979797),
                                    size: 15.size,
                                    const AssetImage(
                                      'assets/icon/reply_icon.png',
                                    ),
                                  ),
                                  Text(
                                    'See ${currentComment.replyQuantity} other replies',
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
                          ],
                        ],
                      );
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
