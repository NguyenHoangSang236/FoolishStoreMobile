import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/data/dto/address_code_request.dart';
import 'package:fashionstore/data/dto/cart_checkout.dart';
import 'package:fashionstore/data/dto/ghn_shipping_service.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/network/network_service.dart';
import '../dto/api_response.dart';
import '../entity/address_code.dart';
import '../entity/cart_item.dart';
import '../entity/cart_item_info.dart';

class CartRepository {
  String type = 'cart';

  Future<Either<Failure, List<CartItem>>> sendPostAndGetCartItemList(
    String url,
    Map<String, dynamic> paramBody, {
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

        return Right(jsonList.map((json) => CartItem.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, CartCheckout>> getCartCheckout({
    required String url,
    required AddressCode addressCode,
    required int serviceId,
  }) async {
    try {
      Map<String, dynamic> requestMap = addressCode.toJson();
      requestMap.addAll({"serviceId": serviceId});

      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          isAuthen: true,
          type: type,
          url: url,
        ),
        param: requestMap,
      );

      if (response.result == 'success') {
        return Right(CartCheckout.fromJson(response.content));
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, AddressCode>> getGhnAddressCodeFromAddressString({
    required String url,
    required AddressCodeRequest addressCodeRequest,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          isAuthen: true,
          type: type,
          url: url,
        ),
        param: addressCodeRequest.toJson(),
      );

      if (response.result == 'success') {
        return Right(AddressCode.fromJson(response.content));
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<GhnShippingService>>>
      getGhnShippingServiceListFromDistrictId({
    required String url,
    required int fromDistrictId,
    required int toDistrictId,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(
          isAuthen: true,
          type: type,
          url: url,
        ),
        param: {
          "fromDistrictId": fromDistrictId,
          "toDistrictId": toDistrictId,
        },
      );

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return Right(
          jsonList.map((json) => GhnShippingService.fromJson(json)).toList(),
        );
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
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

  Future<Either<Failure, CartCheckout>> checkout({
    required AddressCode addressCode,
    required int serviceId,
  }) {
    return getCartCheckout(
      url: '/checkout',
      addressCode: addressCode,
      serviceId: serviceId,
    );
  }

  Future<Either<Failure, AddressCode>> getGhnAddressCode({
    required AddressCodeRequest addressCodeRequest,
  }) {
    return getGhnAddressCodeFromAddressString(
      url: '/getGhnAddressCode',
      addressCodeRequest: addressCodeRequest,
    );
  }

  Future<Either<Failure, List<GhnShippingService>>> getGnhAvailableServiceList({
    required int fromDistrictId,
    required int toDistrictId,
  }) {
    return getGhnShippingServiceListFromDistrictId(
      url: '/getGnhAvailableServiceList',
      fromDistrictId: fromDistrictId,
      toDistrictId: toDistrictId,
    );
  }

  Future<Either<Failure, AddressCodeRequest>>
      getAddressCodeRequestFromCoordinate(
    LatLng latLng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placeMark = placemarks.first;

        print(placeMark.toJson());

        return Right(AddressCodeRequest(
          fromAddress: '249 Đặng Thúc Vịnh ấp 7',
          fromWard: 'Đông Thạnh',
          fromDistrict: 'Hóc Môn',
          fromProvince: 'Thành phố Hồ Chí Minh',
          toAddress: placeMark.street ?? '',
          toWard: placeMark.subLocality ?? '',
          toDistrict: placeMark.subAdministrativeArea ?? '',
          toProvince: placeMark.administrativeArea ?? '',
        ));
      } else {
        return const Left(ApiFailure('No data'));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }
}
