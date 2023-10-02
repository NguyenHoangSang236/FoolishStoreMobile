import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../data/entity/delivery_type.dart';
import '../utils/network/failure.dart';
import '../utils/network/network_service.dart';
import '../utils/render/value_render.dart';

class DeliveryRepository {
  String type = 'deliveryType';

  Future<Either<Failure, List<DeliveryType>>> getDeliveryTypeList(
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

        return Right(
            jsonList.map((json) => DeliveryType.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<DeliveryType>>> showAllDeliveryTypes() {
    return getDeliveryTypeList('/showAllDeliveryTypes', isAuthen: false);
  }
}
