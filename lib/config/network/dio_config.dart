import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';
import '../app_router/app_router_config.dart';

class DioConfig {
  static void configInterceptors(Dio dio) {
    dio.interceptors
      // ..add(CookieManager(cookieJar))
      ..add(
        InterceptorsWrapper(
          onError: (DioException e, ErrorInterceptorHandler handler) {
            if (e.response!.statusCode == 401 ||
                e.response!.statusCode == 403) {
              debugPrint('You need to login');
              appRouter.replaceAll([const LoginRoute()]);
            }

            return handler.next(e);
          },
        ),
      )
      ..add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      )
      ..add(
        CurlLoggerDioInterceptor(),
      );
  }

  static void configBasicOptions(Dio dio) {
    dio.options = BaseOptions(
      baseUrl: 'https://$domain:8080',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) {
        return status! < 500;
      },
    );
  }
}
