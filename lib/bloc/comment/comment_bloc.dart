import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/comment.dart';
import '../../repository/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _commentRepository;

  List<Comment> commentList = [];

  CommentBloc(this._commentRepository) : super(CommentInitial()) {
    on<OnLoadCommentListEvent>((event, emit) async {
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
            commentList = List.of(list);
            emit(CommentListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CommentErrorState(e.toString()));
      }
    });
  }
}
