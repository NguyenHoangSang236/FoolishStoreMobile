import 'dart:convert';

import 'package:fashionstore/data/entity/comment.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/views/components/text_sender_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/comment/comment_bloc.dart';
import '../../data/dto/websocket_message.dart';
import '../../data/enum/websocket_enum.dart';
import '../../main.dart';
import '../../utils/render/ui_render.dart';
import 'comment_component.dart';

class CommentList extends StatefulWidget {
  const CommentList({
    super.key,
    required this.productId,
    required this.productColor,
    required this.replyOn,
    required this.page,
    required this.controller,
    required this.isSomeoneTyping,
  });

  final int productId;
  final String productColor;
  final int replyOn;
  final int page;
  final TextEditingController controller;
  final bool isSomeoneTyping;

  @override
  State<StatefulWidget> createState() => _CommentList();
}

class _CommentList extends State<CommentList> {
  late int currentPage;

  void _onPostComment() {
    context.read<CommentBloc>().add(
          OnAddCommentEvent(
            widget.controller.text,
            widget.productColor,
            widget.productId,
            0,
          ),
        );
  }

  @override
  void initState() {
    currentPage = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentAddedState) {
          // send websocket about a user posted a comment
          stompClient.send(
            destination:
                '$websocketDestinationPrefix/postComment/${widget.productId}/${widget.productColor}',
            body: json.encode(
              WebsocketMessage(
                type: WebsocketEnum.POST_COMMENT,
                sender:
                    context.read<AuthenticationBloc>().currentUser?.userName,
                content: {
                  'productId': widget.productId,
                  'productColor': widget.productColor,
                  'commentContent': widget.controller.text,
                  'replyOn': 0,
                },
              ).toJson(),
            ),
          );
        }
      },
      builder: (context, state) {
        List<int> commentYouLikedIdList =
            context.read<CommentBloc>().commentYouLikedIdList;

        List<Comment> commentList = context.read<CommentBloc>().commentList;

        int selectedId = context.read<CommentBloc>().selectedCommentId;

        if (state is CommentIdYouLikedListLoadedState) {
          commentYouLikedIdList = state.commentIdList;
        } else if (state is CommentListLoadedState && selectedId == 0) {
          commentList = state.commentList;
        } else if (state is CommentLoadingState) {
          return UiRender.loadingCircle();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            currentPage > 1
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage--;
                      });

                      context.read<CommentBloc>().add(
                            OnLoadCommentListEvent(
                              productColor: widget.productColor,
                              productId: widget.productId,
                              page: currentPage,
                            ),
                          );
                    },
                    child: commentList.isNotEmpty
                        ? commentList.length % 5 == 0
                            ? Container(
                                margin: EdgeInsets.only(left: 7.width),
                                child: Text(
                                  'See previous comments',
                                  style: TextStyle(
                                    color: const Color(0xFF979797),
                                    decoration: TextDecoration.underline,
                                    fontSize: 12.size,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Work Sans',
                                  ),
                                ),
                              )
                            : const SizedBox()
                        : Container(
                            padding: EdgeInsets.only(bottom: 15.height),
                            alignment: Alignment.center,
                            child: Text(
                              'No comment',
                              style: TextStyle(
                                color: const Color(0xFF979797),
                                fontSize: 13.size,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Work Sans',
                              ),
                            ),
                          ),
                  )
                : const SizedBox(),
            ...List<Widget>.generate(
              commentList.length,
              (index) => CommentComponent(
                comment: commentList[index],
                isLiked: commentYouLikedIdList.indexWhere(
                      (element) => element == commentList[index].id,
                    ) >=
                    0,
                needBorder: index == commentList.length - 1 ? false : true,
              ),
            ),
            widget.isSomeoneTyping
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/gif/typing_indicator_gif.gif",
                        width: 50,
                        height: 30,
                      ),
                      Text(
                        'Someone is typing a comment',
                        style: TextStyle(
                          fontSize: 13.size,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            TextSenderComponent(
              sendAction: _onPostComment,
              controller: widget.controller,
              productId: widget.productId,
              productColor: widget.productColor,
            ),
          ],
        );
      },
    );
  }
}
