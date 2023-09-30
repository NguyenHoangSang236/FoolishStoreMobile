import 'package:equatable/equatable.dart';

class InvoiceFilter extends Equatable {
  String? adminAcceptance;
  String? paymentMethod;
  String? paymentStatus;
  String? deliveryStatus;
  DateTime? startInvoiceDate;
  DateTime? endInvoiceDate;
  int? page;
  int? limit;

  InvoiceFilter({
    this.adminAcceptance,
    this.paymentMethod,
    this.paymentStatus,
    this.deliveryStatus,
    this.startInvoiceDate,
    this.endInvoiceDate,
    this.page,
    this.limit,
  });

  InvoiceFilter get copyValues => InvoiceFilter(
        adminAcceptance: adminAcceptance,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        deliveryStatus: deliveryStatus,
        startInvoiceDate: startInvoiceDate,
        endInvoiceDate: endInvoiceDate,
        page: page,
        limit: limit,
      );

  bool isClear() {
    return adminAcceptance == null &&
        paymentMethod == null &&
        paymentStatus == null &&
        deliveryStatus == null;
  }

  @override
  List<Object?> get props => [
        adminAcceptance,
        paymentMethod,
        paymentStatus,
        deliveryStatus,
        startInvoiceDate,
        endInvoiceDate,
        page,
        limit,
      ];
}
