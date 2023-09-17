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

class InvoiceErrorState extends InvoiceState {
  final String message;

  const InvoiceErrorState(this.message);

  @override
  List<Object> get props => [message];
}
