import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fashionstore/data/dto/api_response.dart';
import 'package:fashionstore/data/entity/category.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/network/network_service.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/cupertino.dart';

class CategoryRepository {
  String type = 'category';

  Future<Either<Failure, List<Category>>> getCategoryList(String url,
      {bool isAuthen = false}) async {
    try {
      ApiResponse response =
          await NetworkService.getDataFromApi(ValueRender.getUrl(
        type: type,
        url: url,
        isAuthen: isAuthen,
      ));

      if (response.result == 'success') {
        List<dynamic> jsonList = json.decode(jsonEncode(response.content));

        return Right(jsonList.map((json) => Category.fromJson(json)).toList());
      } else {
        return Left(ApiFailure(response.content));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Category>>> getAllCategories() async {
    return getCategoryList('/allCategories');
  }
}
