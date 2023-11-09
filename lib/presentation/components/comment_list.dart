import 'package:fashionstore/data/entity/comment.dart';
import 'package:fashionstore/presentation/components/text_sender_component.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/comment/comment_bloc.dart';
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
  });

  final int productId;
  final String productColor;
  final int replyOn;
  final int page;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _CommentList();
}

class _CommentList extends State<CommentList> {
  late int currentPage;

  @override
  void initState() {
    currentPage = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {},
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
            GestureDetector(
              onTap: () {
                setState(() {
                  currentPage++;
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
            ),
            ...List<Widget>.generate(
              commentList.length,
              (index) => CommentComponent(
                comment: commentList[index],
                productId: widget.productId,
                isLiked: commentYouLikedIdList.indexWhere(
                      (element) => element == commentList[index].id,
                    ) >=
                    0,
                needBorder: index == commentList.length - 1 ? false : true,
              ),
            ),
            TextSenderComponent(
              sendAction: () => context.read<CommentBloc>().add(
                    OnAddCommentEvent(
                      widget.controller.text,
                      widget.productColor,
                      widget.productId,
                      0,
                    ),
                  ),
              controller: widget.controller,
            ),
          ],
        );
      },
    );
  }
}
