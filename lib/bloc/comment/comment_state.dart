part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
}

class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoadingState extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentReplyLoadingState extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentListLoadedState extends CommentState {
  final List<Comment> commentList;

  const CommentListLoadedState(this.commentList);

  @override
  List<Object?> get props => [commentList];
}

class CommentReplyListLoadedState extends CommentState {
  final List<Comment> commentList;

  const CommentReplyListLoadedState(this.commentList);

  @override
  List<Object?> get props => [commentList];
}

class CommentUpdatedState extends CommentState {
  final String message;

  const CommentUpdatedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentAddedState extends CommentState {
  final String message;

  const CommentAddedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentDeletedState extends CommentState {
  final String message;

  const CommentDeletedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentLikedState extends CommentState {
  final String message;

  const CommentLikedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentErrorState extends CommentState {
  final String message;

  const CommentErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
