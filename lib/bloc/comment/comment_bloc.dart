import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/comment.dart';
import '../../repository/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _commentRepository;

  int page = 1;
  int selectedCommentId = 0;
  List<Comment> commentList = [];
  List<Comment> replyCommentList = [];

  CommentBloc(this._commentRepository) : super(CommentInitial()) {
    on<OnLoadCommentListEvent>((event, emit) async {
      emit(
        event.replyOn != null && event.replyOn == 0
            ? CommentLoadingState()
            : CommentReplyLoadingState(),
      );

      try {
        final response = await _commentRepository.getProductComments(
          productId: event.productId,
          productColor: event.productColor,
          replyOn: event.replyOn,
          page: event.page ?? 1,
          limit: event.limit ?? 5,
        );

        response.fold(
          (failure) => emit(CommentErrorState(failure.message)),
          (list) {
            page = event.page ?? 1;
            selectedCommentId = event.replyOn ?? 0;
            event.replyOn != null && event.replyOn! > 0
                ? replyCommentList = List.of(list)
                : commentList = List.of(list);

            emit(
              event.replyOn != null && event.replyOn == 0
                  ? CommentListLoadedState(commentList)
                  : CommentReplyListLoadedState(replyCommentList),
            );
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });

    on<OnAddCommentEvent>((event, emit) async {
      try {
        final response = await _commentRepository.addNewComment(
          productId: event.productId,
          productColor: event.productColor,
          replyOn: event.replyOn,
          commentContent: event.commentContent,
        );

        response.fold(
          (failure) => emit(CommentErrorState(failure.message)),
          (message) => emit(CommentAddedState(message)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });
  }

  List<Comment> _removeDuplicates(List<Comment> list) {
    Set<int> set = {};
    List<Comment> uniqueList =
        list.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
