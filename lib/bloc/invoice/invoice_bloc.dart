import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/data/dto/invoice_filter.dart';
import 'package:fashionstore/data/entity/invoice.dart';
import 'package:fashionstore/data/entity/online_payment_info.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/invoice_repository.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository _invoiceRepository;

  OnlinePaymentInfo? currentOnlinePaymentInfo;
  List<Invoice> currentInvoiceList = [];
  InvoiceFilter? currentInvoiceFilter;
  int currentPage = 1;
  int currentAddedInvoiceId = 0;
  String currentPaymentMethod = '';
  String currentDeliveryType = '';

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
          (message) {
            String invoiceIdFromMsg = message.substring(
                message.indexOf('ID') + 3, message.indexOf('has'));

            currentAddedInvoiceId = int.parse(invoiceIdFromMsg);

            emit(InvoiceAddedState(message));
          },
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
          (onlinePaymentInfo) {
            currentPaymentMethod = event.paymentMethod;
            currentOnlinePaymentInfo = onlinePaymentInfo;

            emit(
              InvoiceOnlinePaymentInfoLoadedState(onlinePaymentInfo),
            );
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(InvoiceErrorState(e.toString()));
      }
    });

    on<OnFilterInvoiceEvent>((event, emit) async {
      if (currentInvoiceFilter != event.invoiceFilter) {
        emit(InvoiceLoadingState());

        try {
          final response = await _invoiceRepository.filterOrders(
            event.invoiceFilter,
          );

          response.fold(
            (failure) => emit(InvoiceErrorState(failure.message)),
            (invoiceList) {
              currentInvoiceFilter = event.invoiceFilter;
              currentPage = event.invoiceFilter.page ?? 1;

              emit(InvoiceListFilteredState(invoiceList));
            },
          );
        } catch (e) {
          debugPrint(e.toString());
          emit(InvoiceErrorState(e.toString()));
        }
      }
    });

    on<OnLoadNextPageEvent>((event, emit) async {
      emit(InvoiceLoadingState());

      try {
        final response = await _invoiceRepository.filterOrders(
          currentInvoiceFilter!,
        );

        response.fold(
          (failure) => emit(InvoiceErrorState(failure.message)),
          (invoiceList) {
            currentPage++;

            emit(
              InvoiceListFilteredState(
                _removeDuplicate([...currentInvoiceList, ...invoiceList]),
              ),
            );
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(InvoiceErrorState(e.toString()));
      }
    });

    on<OnClearInvoiceFilterEvent>((event, emit) async {
      currentOnlinePaymentInfo = null;
      currentInvoiceList = [];
      currentInvoiceFilter = null;
      currentPage = 1;
      currentAddedInvoiceId = 0;
      currentPaymentMethod = '';
      currentDeliveryType = '';
      emit(const InvoiceFilterClearedState('Invoice filter has been cleared'));
    });
  }

  List<Invoice> _removeDuplicate(List<Invoice> invoiceList) {
    Set<int> set = {};
    List<Invoice> uniqueList =
        invoiceList.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
