import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:either_dart/either.dart';
import 'package:fashionstore/data/dto/api_response.dart';
import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:flutter/cupertino.dart';

import '../render/value_render.dart';
import 'failure.dart';

class NetworkService {
  static String domain = 'https://192.168.1.14:8080';

  const NetworkService._();

  static String sessionId = '';
  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static CookieJar cookieJar = CookieJar();
  static Dio dio = Dio();

  static Future<ApiResponse> getDataFromApi(
    String url, {
    Map<String, dynamic>? param,
    FormData? formDataParam,
  }) async {
    dio.interceptors.add(CookieManager(cookieJar));

    if (url.contains('/authen')) {
      String jwtFromStorage = await LocalStorageService.getLocalStorageData(
        LocalStorageKeyEnum.SAVED_JWT.name,
      ) as String;

      dio.options.headers['Authorization'] = 'Bearer $jwtFromStorage';
    }

    final Response response = (param == null && formDataParam == null)
        ? await dio.get(domain + url)
        : await dio.post(
            domain + url,
            data: formDataParam ?? param,
          );

    debugPrint(domain + url);

    if (url.contains('/logout')) {
      LocalStorageService.removeLocalStorageData(
        LocalStorageKeyEnum.SAVED_JWT.name,
      );
      cookieJar.deleteAll();
    }

    debugPrint('request: ${param ?? formDataParam.toString()}');
    debugPrint('header: ${response.headers}');
    debugPrint('statusCode: ${response.statusCode}');
    debugPrint('response: ${response.data}');
    debugPrint('\n');
    debugPrint(
        '\n---------------------------------END-------------------------------------\n');
    debugPrint('\n');

    Map<String, dynamic> jsonMap = response.data;
    final ApiResponse responseModel = ApiResponse.fromJson(jsonMap);

    return responseModel;

    // try {
    //
    // } catch (e, stackTrace) {
    //   debugPrint(domain + url);
    //   debugPrint('request: ${param ?? formDataParam.toString()}');
    //   debugPrint('Caught exception: $e\n$stackTrace');
    //   throw Exception(e);
    // }
  }

  static Future<Either<Failure, String>> getMessageFromApi(
    String url, {
    Map<String, dynamic>? paramBody,
    FormData? formDataBody,
    bool isAuthen = false,
    required String type,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
          ValueRender.getUrl(
            isAuthen: isAuthen,
            type: type,
            url: url,
          ),
          param: paramBody,
          formDataParam: formDataBody);

      if (response.result == 'success') {
        return Right(response.content.toString());
      } else {
        return Left(ApiFailure(response.content.toString()));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }
}
