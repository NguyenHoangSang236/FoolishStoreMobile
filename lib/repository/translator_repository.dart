import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

import '../data/dto/api_response.dart';
import '../data/entity/translator_language.dart';
import '../utils/network/network_service.dart';

class TranslatorRepository {
  String type = 'translator';

  Future<Either<Failure, List<TranslatorLanguage>>> getLanguageList(
    String url, {
    bool isAuthen = false,
  }) async {
    try {
      ApiResponse response = await NetworkService.getDataFromApi(
          ValueRender.getUrl(type: type, url: url, isAuthen: isAuthen));

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));
        return Right(
          jsonList.map((json) => TranslatorLanguage.fromJson(json)).toList(),
        );
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> translate(
      String text, String sourceLanguageCode) {
    return NetworkService.getMessageFromApi(
      type: type,
      '/translate',
      paramBody: {
        'text': text,
        'sourceLanguageCode': sourceLanguageCode,
      },
    );
  }

  Future<dynamic> getAllLanguageList() {
    return getLanguageList('/getAllLanguageList');
  }
}
