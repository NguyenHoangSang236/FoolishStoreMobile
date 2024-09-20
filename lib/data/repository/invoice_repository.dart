import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/data/dto/invoice_filter.dart';
import 'package:fashionstore/data/entity/invoice_details.dart';
import 'package:fashionstore/data/entity/online_payment_info.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/network/network_service.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/render/value_render.dart';
import '../dto/api_response.dart';
import '../entity/address_code.dart';
import '../entity/invoice.dart';

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
        ),
        param: param,
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

  Future<Either<Failure, InvoiceDetails>> getInvoiceDetails(
    String url,
  ) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          type: type,
          url: url,
          isAuthen: true,
        ),
      );

      if (response.result == 'success') {
        return Right(InvoiceDetails.fromJson(response.content));
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Invoice>>> getInvoiceList(
    String url,
    Map<String, dynamic> param,
  ) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          type: type,
          url: url,
          isAuthen: true,
        ),
        param: param,
      );

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return Right(jsonList.map((json) => Invoice.fromJson(json)).toList());
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
    required AddressCode addressCode,
    required String address,
    String note = '',
    required int serviceId,
  }) {
    Map<String, dynamic> requestMap = {
      'paymentMethod': paymentMethod,
      'serviceId': serviceId,
      'address': address,
      'note': note,
    };

    requestMap.addAll(addressCode.toJson());

    return NetworkService.getMessageFromApi(
      '/addNewOrder',
      type: type,
      isAuthen: true,
      paramBody: requestMap,
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

  Future<Either<Failure, InvoiceDetails>> getInvoiceDetailsById(int invoiceId) {
    return getInvoiceDetails('/invoice_id=$invoiceId');
  }

  Future<Either<Failure, List<Invoice>>> filterOrders(InvoiceFilter filter) {
    return getInvoiceList(
      '/filterOrders',
      {
        'filter': {
          'adminAcceptance': filter.adminAcceptance,
          'paymentMethod': filter.paymentMethod,
          'paymentStatus': filter.paymentStatus,
          'orderStatus': filter.orderStatus,
          'startInvoiceDate': filter.startInvoiceDate?.dateApiFormat ??
              "2020-01-01T00:00:00.000+0000",
          'endInvoiceDate': filter.endInvoiceDate?.dateApiFormat ??
              DateTime.now().dateApiFormat,
        },
        'pagination': {
          'page': filter.page ?? 1,
          'limit': filter.limit ?? 10,
        }
      },
    );
  }

  Future<Either<Failure, String>> cancelOrder(int invoiceId) {
    return NetworkService.getMessageFromApi(
      '/cancel_order_id=$invoiceId',
      isAuthen: true,
      type: type,
    );
  }
}
