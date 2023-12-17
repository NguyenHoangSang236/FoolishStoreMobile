part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class OnAddNewOrderEvent extends InvoiceEvent {
  final String paymentMethod;
  final AddressCode addressCode;
  final int serviceId;

  const OnAddNewOrderEvent(
    this.paymentMethod,
    this.addressCode,
    this.serviceId,
  );
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

class OnFilterInvoiceEvent extends InvoiceEvent {
  final InvoiceFilter invoiceFilter;

  const OnFilterInvoiceEvent(this.invoiceFilter);
}

class OnLoadInvoiceDetailsEvent extends InvoiceEvent {
  final int invoiceId;

  const OnLoadInvoiceDetailsEvent(this.invoiceId);
}

class OnLoadNextPageEvent extends InvoiceEvent {
  const OnLoadNextPageEvent();
}

class OnClearInvoiceFilterEvent extends InvoiceEvent {
  const OnClearInvoiceFilterEvent();
}
