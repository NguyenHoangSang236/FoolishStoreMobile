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
  List<int> commentYouLikedIdList = [];

  CommentBloc(this._commentRepository) : super(CommentInitial()) {
    on<OnLoadCommentListEvent>((event, emit) async {
      emit(CommentLoadingState());

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
            selectedCommentId = 0;
            commentList = List.of(list);

            emit(CommentListLoadedState(commentList));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });

    on<OnLoadCommentIdYouLikedListEvent>((event, emit) async {
      emit(CommentYouLikedIdListLoadingState());

      try {
        final response = await _commentRepository.getCommentIdYouLiked(
          productId: event.productId,
          productColor: event.productColor,
        );

        response.fold(
          (failure) => emit(CommentErrorState(failure.message)),
          (list) {
            commentYouLikedIdList = List.of(list);

            emit(CommentIdYouLikedListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });

    on<OnLoadReplyCommentListEvent>((event, emit) async {
      emit(CommentReplyLoadingState());

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
            selectedCommentId = event.replyOn;
            replyCommentList = _removeDuplicates(replyCommentList, list);

            emit(CommentReplyListLoadedState(list));
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

    on<OnAddReplyCommentEvent>((event, emit) async {
      try {
        final response = await _commentRepository.addNewComment(
          productId: event.productId,
          productColor: event.productColor,
          replyOn: event.replyOn,
          commentContent: event.commentContent,
        );

        response.fold(
          (failure) => emit(CommentErrorState(failure.message)),
          (message) {
            selectedCommentId = event.replyOn;

            emit(CommentReplyAddedState(message, event.replyOn));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });

    on<OnReactCommentEvent>((event, emit) async {
      try {
        final response = await _commentRepository.reactComment(event.id);

        response.fold(
          (failure) => emit(CommentErrorState(failure.message)),
          (message) => emit(CommentReactedState(message)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });

    on<OnClearCommentEvent>((event, emit) async {
      page = 1;
      selectedCommentId = 0;
      commentList = [];
      replyCommentList = [];
      commentYouLikedIdList = [];
    });
  }

  List<Comment> _removeDuplicates(
      List<Comment> oldList, List<Comment> newList) {
    Set<int> set = {};
    List<Comment> combineList = [...newList, ...oldList];
    List<Comment> uniqueList =
        combineList.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
