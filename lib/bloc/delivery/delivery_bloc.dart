import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/delivery_type.dart';
import '../../repository/delivery_repository.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryRepository _deliveryRepository;

  List<DeliveryType> currentDeliveryTypeList = [];

  DeliveryBloc(this._deliveryRepository) : super(DeliveryInitial()) {
    on<OnLoadDeliveryTypeEvent>((event, emit) async {
      emit(DeliveryLoadingState());

      try {
        final response = await _deliveryRepository.showAllDeliveryTypes();

        response.fold(
          (failure) => emit(DeliveryErrorState(failure.message)),
          (list) {
            currentDeliveryTypeList = List.of(list);

            emit(DeliveryTypeListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(DeliveryErrorState(e.toString()));
      }
    });
  }
}
