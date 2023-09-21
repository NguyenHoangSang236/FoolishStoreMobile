import 'package:equatable/equatable.dart';

class InvoiceFilter extends Equatable {
  final String? adminAcceptance;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? deliveryStatus;
  final DateTime? startInvoiceDate;
  final DateTime? endInvoiceDate;
  final int? page;
  final int? limit;

  const InvoiceFilter({
    this.adminAcceptance,
    this.paymentMethod,
    this.paymentStatus,
    this.deliveryStatus,
    this.startInvoiceDate,
    this.endInvoiceDate,
    this.page,
    this.limit,
  });

  @override
  // TODO: implement props
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
