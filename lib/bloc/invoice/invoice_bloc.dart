import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/data/entity/online_payment_info.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/invoice_repository.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository _invoiceRepository;

  InvoiceBloc(this._invoiceRepository) : super(InvoiceInitial()) {
    on<OnAddNewOrderEvent>((event, emit) async {
      emit(InvoiceLoadingState());

      try {
        final response = await _invoiceRepository.addNewOrder(
          paymentMethod: event.paymentMethod,
          deliveryType: event.deliveryType,
        );

        response.fold(
          (failure) => emit(InvoiceErrorState(failure.message)),
          (message) => emit(InvoiceAddedState(message)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(InvoiceErrorState(e.toString()));
      }
    });

    on<OnLoadOnlinePaymentInfoEvent>((event, emit) async {
      emit(InvoiceLoadingState());

      try {
        final response = await _invoiceRepository.onlinePayment(
          paymentMethod: event.paymentMethod,
          id: event.id,
        );

        response.fold(
          (failure) => emit(InvoiceErrorState(failure.message)),
          (onlinePaymentInfo) => emit(
            InvoiceOnlinePaymentInfoLoadedState(onlinePaymentInfo),
          ),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(InvoiceErrorState(e.toString()));
      }
    });
  }
}
