part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class OnAddNewOrderEvent extends InvoiceEvent {
  final String paymentMethod;
  final String deliveryType;

  const OnAddNewOrderEvent(this.paymentMethod, this.deliveryType);
}

class OnCancelOrderEvent extends InvoiceEvent {
  final int orderId;

  const OnCancelOrderEvent(this.orderId);
}

class OnLoadInvoiceEvent extends InvoiceEvent {
  final int invoiceId;

  const OnLoadInvoiceEvent(this.invoiceId);
}

class OnLoadOnlinePaymentInfoEvent extends InvoiceEvent {
  final int id;
  final String paymentMethod;

  const OnLoadOnlinePaymentInfoEvent(this.id, this.paymentMethod);
}
