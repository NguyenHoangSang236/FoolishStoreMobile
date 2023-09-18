import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fashionstore/config/app_router/app_router_config.dart';
import 'package:fashionstore/data/dto/api_response.dart';
import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/main.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:flutter/cupertino.dart';

import '../render/value_render.dart';
import 'failure.dart';

class NetworkService {
  static String domain = 'https://192.168.1.9:8080';

  const NetworkService._();

  static String sessionId = '';
  static Map<String, String> headers = {'Content-Type': 'application/json'};

  // static CookieJar cookieJar = CookieJar();
  static Dio dio = Dio();

  static Future<ApiResponse> getDataFromApi(
    String url, {
    Map<String, dynamic>? param,
    FormData? formDataParam,
  }) async {
    dio.interceptors
        // ..add(CookieManager(cookieJar))
        .add(
      InterceptorsWrapper(
        // onRequest: (options, handler) {
        //   handler.next(options);
        // },
        // onResponse: (response, handler) {
        //   handler.next(response);
        // },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (e.response!.statusCode == 401 || e.response!.statusCode == 403) {
            debugPrint('You need to login');
            appRouter.replaceAll([const LoginRoute()]);
          }

          return handler.next(e);
        },
      ),
    );
    dio.options = BaseOptions(
      baseUrl: domain,
      receiveDataWhenStatusError: true,
      validateStatus: (status) {
        return status! < 500;
      },
    );

    if (url.contains('/authen')) {
      String jwtFromStorage = await LocalStorageService.getLocalStorageData(
        LocalStorageKeyEnum.SAVED_JWT.name,
      ) as String;

      dio.options.headers['Authorization'] = 'Bearer $jwtFromStorage';
    }

    final Response response = (param == null && formDataParam == null)
        ? await dio.get(domain + url)
        : await dio.post(domain + url, data: formDataParam ?? param);

    debugPrint(domain + url);
    debugPrint('request: ${param ?? formDataParam.toString()}');
    debugPrint('header: ${response.headers}');
    debugPrint('statusCode: ${response.statusCode}');
    debugPrint('response: ${response.data}');
    debugPrint(
        '\n\n---------------------------------END-------------------------------------\n\n');

    if (url.contains('/logout')) {
      LocalStorageService.removeLocalStorageData(
        LocalStorageKeyEnum.SAVED_JWT.name,
      );
      // cookieJar.deleteAll();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      debugPrint('You need to login');

      LocalStorageService.removeLocalStorageData(
        LocalStorageKeyEnum.SAVED_USER_NAME.name,
      );
      LocalStorageService.removeLocalStorageData(
        LocalStorageKeyEnum.SAVED_PASSWORD.name,
      );

      appRouter.replaceAll([const LoginRoute()]);
    }

    final ApiResponse responseModel = ApiResponse.fromJson(response.data);

    return responseModel;
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
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }
}
