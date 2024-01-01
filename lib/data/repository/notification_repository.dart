import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/data/entity/notification.dart';
import 'package:flutter/foundation.dart';

import '../../utils/network/failure.dart';
import '../../utils/network/network_service.dart';
import '../../utils/render/value_render.dart';
import '../dto/api_response.dart';

class NotificationRepository {
  String type = 'notification';

  Future<Either<Failure, List<Notification>>> getNotificationList(
    Map<String, dynamic> paramBody,
  ) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          isAuthen: true,
          type: type,
          url: '/filterNotifications',
        ),
        param: paramBody,
      );

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        if (jsonList.isEmpty) {
          return const Left(ApiFailure('No data'));
        }

        return Right(
            jsonList.map((json) => Notification.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> seenNotification(int id) async {
    return NetworkService.getMessageFromApi(
      '/seen_notification_id=$id',
      type: type,
      isAuthen: true,
    );
  }
}
