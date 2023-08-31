import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../data/entity/cart_item.dart';
import '../data/entity/cart_item_info.dart';
import '../utils/network/network_service.dart';

class CartRepository {
  String type = 'cart';

  Future<Either<Failure, List<CartItem>>> sendPostAndGetCartItemList(
      String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
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

        return Right(jsonList.map((json) => CartItem.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> getTotalCartItemQuantity() {
    return NetworkService.getMessageFromApi(
      '/totalCartItemQuantity',
      isAuthen: true,
      type: type,
    );
  }

  Future<Either<Failure, List<CartItem>>> showFullCart(int page, int limit) {
    return sendPostAndGetCartItemList(
      '/showFullCart',
      isAuthen: true,
      {
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<Either<Failure, String>> update(List<CartItemInfo> cartItemList) {
    return NetworkService.getMessageFromApi(
      '/update',
      isAuthen: true,
      type: type,
      paramBody: {
        "objectList": cartItemList,
      },
    );
  }

  Future<Either<Failure, String>> add(
      int productId, String color, String size, int quantity) {
    return NetworkService.getMessageFromApi(
      '/add',
      isAuthen: true,
      type: type,
      paramBody: {
        'productId': productId,
        'color': color,
        'size': size,
        'quantity': quantity,
      },
    );
  }

  Future<Either<Failure, String>> remove(List<int> cartIdList) {
    return NetworkService.getMessageFromApi(
      '/remove',
      isAuthen: true,
      type: type,
      paramBody: {
        "integerArray": cartIdList,
      },
    );
  }

  Future<Either<Failure, List<CartItem>>> filterCartItems(
    String? name,
    List<String>? status,
    String? brand,
    int? page,
    int? limit,
  ) {
    return sendPostAndGetCartItemList(
      '/filterCartItems',
      isAuthen: true,
      {
        "filter": {
          "name": name,
          "status": status,
          "brand": brand,
        },
        "pagination": {
          "page": page,
          "limit": limit,
        }
      },
    );
  }
}
