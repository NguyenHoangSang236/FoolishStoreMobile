import 'package:either_dart/either.dart';
import 'package:fashionstore/data/entity/online_payment_info.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/network/network_service.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../utils/render/value_render.dart';

class InvoiceRepository {
  String type = 'invoice';

  Future<Either<Failure, OnlinePaymentInfo>> getOnlinePaymentInfo(
    String url,
    Map<String, dynamic> param,
  ) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          type: type,
          url: url,
          isAuthen: true,
          paramBody: param,
        ),
      );

      if (response.result == 'success') {
        return Right(OnlinePaymentInfo.fromJson(response.content));
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> addNewOrder({
    required String paymentMethod,
    required String deliveryType,
  }) {
    return NetworkService.getMessageFromApi(
      '/addNewOrder',
      type: type,
      isAuthen: true,
      paramBody: {
        'paymentMethod': paymentMethod,
        'deliveryType': deliveryType,
      },
    );
  }

  Future<Either<Failure, OnlinePaymentInfo>> onlinePayment({
    required int id,
    required String paymentMethod,
  }) {
    return getOnlinePaymentInfo(
      '/onlinePayment',
      {
        "id": id,
        "paymentMethod": paymentMethod,
      },
    );
  }
}
