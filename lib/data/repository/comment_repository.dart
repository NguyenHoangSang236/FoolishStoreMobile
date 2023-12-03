import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/data/entity/comment.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/network/failure.dart';
import '../../utils/network/network_service.dart';
import '../../utils/render/value_render.dart';
import '../dto/api_response.dart';

class CommentRepository {
  String type = 'comment';

  Future<Either<Failure, List<Comment>>> getCommentList(
    String url, {
    Map<String, dynamic>? paramBody,
    bool isAuthen = false,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          type: type,
          url: url,
          isAuthen: isAuthen,
        ),
        param: paramBody,
      );

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return Right(jsonList.map((json) => Comment.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<int>>> getCommentIdList(
    String url, {
    Map<String, dynamic>? paramBody,
    bool isAuthen = false,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          type: type,
          url: url,
          isAuthen: isAuthen,
        ),
        param: paramBody,
      );

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return Right(jsonList.map((elem) => elem as int).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> addNewComment({
    required int productId,
    required String productColor,
    int replyOn = 0,
    required String commentContent,
  }) async {
    return NetworkService.getMessageFromApi(
      '/add',
      type: type,
      paramBody: {
        'commentContent': commentContent,
        'productId': productId,
        'productColor': productColor,
        'replyOn': replyOn
      },
      isAuthen: true,
    );
  }

  Future<Either<Failure, String>> updateComment({
    required int id,
    required String commentContent,
  }) async {
    return NetworkService.getMessageFromApi(
      '/update',
      type: type,
      paramBody: {
        'commentContent': commentContent,
        'id': id,
      },
      isAuthen: true,
    );
  }

  Future<Either<Failure, String>> deleteComment(int id) async {
    return NetworkService.getMessageFromApi(
      '/delete_comment_id=$id',
      type: type,
      isAuthen: true,
    );
  }

  Future<Either<Failure, String>> reactComment(int id) async {
    return NetworkService.getMessageFromApi(
      '/react_comment_id=$id',
      type: type,
      isAuthen: true,
    );
  }

  Future<Either<Failure, List<Comment>>> getProductComments({
    required int productId,
    required String productColor,
    int? replyOn,
    int page = 1,
    int limit = 5,
  }) async {
    return getCommentList(
      '/commentList',
      paramBody: {
        'filter': {
          'productId': productId,
          'productColor': productColor,
          'replyOn': replyOn
        },
        'pagination': {
          'page': page,
          'limit': limit,
        }
      },
    );
  }

  Future<Either<Failure, List<int>>> getCommentIdYouLiked({
    required int productId,
    required String productColor,
  }) async {
    return getCommentIdList(
      '/commentsYouLiked',
      paramBody: {
        'productId': productId,
        'productColor': productColor,
      },
      isAuthen: true,
    );
  }
}
