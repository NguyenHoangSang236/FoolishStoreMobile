import 'package:either_dart/either.dart';
import 'package:fashionstore/main.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

import '../../utils/network/failure.dart';
import '../dto/place.dart';

class MapRepository {
  Future<Either<Failure, List<Place>>> getAddressSuggestion(
    String searchingAddress,
  ) async {
    List<Place> suggestionPlaceList = [];

    try {
      final response = await dio.get(
        'https://api.opencagedata.com/geocode/v1/json?q=$searchingAddress&key=bf1f41f64d1945b89a887e05cc2a3f00',
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> resMap = response.data;

        List<dynamic> results = resMap['results'];

        for (var result in results) {
          String formatted = result['formatted'];

          List<Location> locations = await locationFromAddress(formatted);

          if (locations.isNotEmpty) {
            Place place = Place(
              formatted,
              locations.first.latitude,
              locations.first.longitude,
            );
            suggestionPlaceList.add(place);
          } else {
            return const Left(ApiFailure('No data'));
          }

          // double lat = result['geometry']['lat'];
          // double lng = result['geometry']['lng'];
        }

        return Right(suggestionPlaceList);
      } else {
        return const Left(ApiFailure('No data'));
      }
    } catch (e, stackTrace) {
      debugPrint('Caught Exception: $e\n$stackTrace');
      return Left(ExceptionFailure(e.toString()));
    }
  }
}
