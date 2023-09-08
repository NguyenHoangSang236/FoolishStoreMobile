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

class CommentYouLikedIdListLoadingState extends CommentState {
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

class CommentReplyAddedState extends CommentState {
  final int replyOn;
  final String message;

  const CommentReplyAddedState(this.message, this.replyOn);

  @override
  List<Object?> get props => [message];
}

class CommentDeletedState extends CommentState {
  final String message;

  const CommentDeletedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentReactedState extends CommentState {
  final String message;

  const CommentReactedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentReplyReactedState extends CommentState {
  final String message;

  const CommentReplyReactedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentIdYouLikedListLoadedState extends CommentState {
  final List<int> commentIdList;

  const CommentIdYouLikedListLoadedState(this.commentIdList);

  @override
  List<Object?> get props => [commentIdList];
}

class CommentErrorState extends CommentState {
  final String message;

  const CommentErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
