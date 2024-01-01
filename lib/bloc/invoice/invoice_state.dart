part of 'invoice_bloc.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();
}

class InvoiceInitial extends InvoiceState {
  @override
  List<Object> get props => [];
}

class InvoiceLoadingState extends InvoiceState {
  @override
  List<Object> get props => [];
}

class InvoiceAddedState extends InvoiceState {
  final String message;

  const InvoiceAddedState(this.message);

  @override
  List<Object> get props => [message];
}

class InvoiceOnlinePaymentInfoLoadedState extends InvoiceState {
  final OnlinePaymentInfo onlinePaymentInfo;

  const InvoiceOnlinePaymentInfoLoadedState(this.onlinePaymentInfo);

  @override
  List<Object> get props => [onlinePaymentInfo];
}

class InvoiceListFilteredState extends InvoiceState {
  final List<Invoice> invoiceList;

  const InvoiceListFilteredState(this.invoiceList);

  @override
  List<Object> get props => [invoiceList];
}

class InvoiceDetailsLoadedState extends InvoiceState {
  final InvoiceDetails invoiceDetails;

  const InvoiceDetailsLoadedState(this.invoiceDetails);

  @override
  List<Object> get props => [invoiceDetails];
}

class InvoiceCanceledState extends InvoiceState {
  final String message;

  const InvoiceCanceledState(this.message);

  @override
  List<Object> get props => [message];
}

class InvoiceFilterClearedState extends InvoiceState {
  final String message;

  const InvoiceFilterClearedState(this.message);

  @override
  List<Object> get props => [message];
}

class InvoiceErrorState extends InvoiceState {
  final String message;

  const InvoiceErrorState(this.message);

  @override
  List<Object> get props => [message];
}
