import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/dto/place.dart';
import '../../data/repository/map_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository _mapRepository;

  List<Place> currentPlaceList = [];

  MapBloc(this._mapRepository) : super(MapInitial()) {
    on<OnSuggestAddressEvent>((event, emit) async {
      emit(MapLoadingState());

      try {
        final response = await _mapRepository.getAddressSuggestion(
          event.address,
        );

        response.fold(
          (failure) => emit(MapErrorState(failure.message)),
          (list) {
            currentPlaceList = List.of(list);

            emit(AddressSuggestedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(MapErrorState(e.toString()));
      }
    });
  }
}
