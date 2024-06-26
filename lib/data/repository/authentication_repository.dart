import 'package:either_dart/either.dart';
import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/network/failure.dart';
import '../../utils/network/network_service.dart';
import '../dto/api_response.dart';
import '../entity/user.dart';

class AuthenticationRepository {
  String type = 'systemAuthentication';

  Future<Either<Failure, User>> sendPostAndGetObject(
      String url, Map<String, dynamic> paramBody,
      {bool isAuthen = false}) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
        ValueRender.getUrl(isAuthen: isAuthen, type: type, url: url),
        param: paramBody,
      );

      if (response.result == 'success') {
        String jwt = response.message!;

        LocalStorageService.setLocalStorageData(
          LocalStorageKeyEnum.SAVED_JWT.name,
          jwt,
        );

        return Right(User.fromJson(response.content));
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, User>> login(String userName, String password) async {
    return sendPostAndGetObject(
      '/login',
      {
        'userName': userName,
        'password': password,
      },
    );
  }

  Future<Either<Failure, String>> logout() async {
    return NetworkService.getMessageFromApi(
      '/logout',
      isAuthen: true,
      type: type,
    );
  }

  Future<Either<Failure, String>> updateProfile(
    String name,
    String phoneNumber,
    String email,
    String address,
    String city,
    String country,
  ) async {
    return NetworkService.getMessageFromApi(
      '/updateProfile',
      isAuthen: true,
      type: type,
      paramBody: {
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'city': city,
        'country': country,
      },
    );
  }

  Future<Either<Failure, String>> register(
    String userName,
    String password,
    String name,
    String email,
    String phoneNumber,
  ) async {
    return NetworkService.getMessageFromApi(
      '/register',
      type: type,
      paramBody: {
        'userName': userName,
        'password': password,
        'customer': {
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      },
    );
  }
}
