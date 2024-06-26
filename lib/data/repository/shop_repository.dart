import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/network/network_service.dart';
import '../dto/api_response.dart';
import '../entity/product.dart';

class ShopRepository {
  String type = 'shop';

  Future<Either<Failure, List<Product>>> getProductList(
    String url, {
    Map<String, dynamic>? paramBody,
    Map<String, dynamic>? queryParamBody,
    bool isAuthen = false,
    bool isRecommender = false,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        isRecommender
            ? url
            : ValueRender.getUrl(
                isAuthen: isAuthen,
                type: type,
                url: url,
              ),
        useDefaultUrl: !isRecommender,
        param: paramBody,
        queryParam: queryParamBody,
      );

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return Right(jsonList.map((json) => Product.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, Product>> getProduct(
    String url, {
    bool isAuthen = false,
  }) async {
    Map<String, dynamic> jsonMap;

    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          isAuthen: isAuthen,
          type: type,
          url: url,
        ),
      );

      if (response.result == 'success') {
        jsonMap = json.decode(jsonEncode(response.content));

        return Right(Product.fromJson(jsonMap));
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> getProductListFromApi(
    String type,
  ) async {
    String url = '';

    switch (type) {
      case 'NEW_ARRIVAL':
        url = '/newArrivalProducts';
        break;
      case 'TOP_BEST_SELLERS':
        url = '/top8BestSellers';
        break;
      case 'HOT_DISCOUNT':
        url = '/hotDiscountProducts';
        break;
    }

    return getProductList(url);
  }

  Future<Either<Failure, List<Product>>> searchProduct(
    String productName, {
    int page = 1,
    int limit = 10,
  }) async {
    return getProductList(
      '/filterProducts',
      paramBody: {
        'filter': {
          'name': productName,
        },
        'pagination': {
          'page': page,
          'limit': limit,
        }
      },
    );
  }

  Future<Either<Failure, List<Product>>> getProductGeneralList(
    int page,
    int limit,
  ) async {
    return getProductList(
      '/productList',
      paramBody: {
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<Either<Failure, List<Product>>> getFilteredProducts(
    int page,
    int limit, {
    String? brand,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
  }) async {
    return getProductList(
      '/filterProducts',
      paramBody: {
        'filter': {
          'brand': brand,
          'maxPrice': maxPrice,
          'minPrice': minPrice,
          'categories': categories,
        },
        'pagination': {
          'page': page,
          'limit': limit,
        }
      },
    );
  }

  Future<Either<Failure, List<Product>>> getProductDetails(int productId) {
    return getProductList(
      '/product_id=$productId',
      queryParamBody: {'showFull': true},
    );
  }

  Future<Either<Failure, String>> rateProduct(
    int productId,
    String color,
    int overallRating,
  ) {
    return NetworkService.getMessageFromApi(
      '/rateProduct',
      paramBody: {
        "productId": productId,
        "color": color,
        "overallRating": overallRating,
      },
      isAuthen: true,
      type: type,
    );
  }

  Future<Either<Failure, List<Product>>> getRecommendProducts(
    int productId,
    String color,
  ) {
    return getProductList(
      'https://absolutely-suitable-yak.ngrok-free.app/recommendResults?fbclid=IwAR3f81NQcnM673uq7GdpUa1gZ5ofgppAdJSZXKGaNoWWzp1Z-HUH9qgFftY',
      isRecommender: true,
      paramBody: {
        'product': '$productId-$color',
      },
    );
  }
}
