part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class OnAddCommentEvent extends CommentEvent {
  final String commentContent;
  final String productColor;
  final int productId;
  final int replyOn;

  const OnAddCommentEvent(
    this.commentContent,
    this.productColor,
    this.productId,
    this.replyOn,
  );
}

class OnAddReplyCommentEvent extends CommentEvent {
  final String commentContent;
  final String productColor;
  final int productId;
  final int replyOn;

  const OnAddReplyCommentEvent(
    this.commentContent,
    this.productColor,
    this.productId,
    this.replyOn,
  );
}

class OnUpdateCommentEvent extends CommentEvent {
  final String commentContent;
  final int id;

  const OnUpdateCommentEvent(
    this.commentContent,
    this.id,
  );
}

class OnDeleteCommentEvent extends CommentEvent {
  final int id;

  const OnDeleteCommentEvent(this.id);
}

class OnLikeCommentEvent extends CommentEvent {
  final int id;

  const OnLikeCommentEvent(this.id);
}

class OnLoadCommentListEvent extends CommentEvent {
  final String productColor;
  final int productId;
  final int? replyOn;
  final int? page;
  final int? limit;

  const OnLoadCommentListEvent({
    required this.productColor,
    required this.productId,
    this.replyOn = 0,
    this.page = 1,
    this.limit = 5,
  });
}

class OnLoadReplyCommentListEvent extends CommentEvent {
  final String productColor;
  final int productId;
  final int replyOn;
  final int? page;
  final int? limit;

  const OnLoadReplyCommentListEvent({
    required this.productColor,
    required this.productId,
    required this.replyOn,
    this.page = 1,
    this.limit = 5,
  });
}
