class InvoiceFilter {
  String? adminAcceptance;
  String? paymentMethod;
  String? paymentStatus;
  String? orderStatus;
  DateTime? startInvoiceDate;
  DateTime? endInvoiceDate;
  int? page;
  int? limit;

  InvoiceFilter({
    this.adminAcceptance,
    this.paymentMethod,
    this.paymentStatus,
    this.orderStatus,
    this.startInvoiceDate,
    this.endInvoiceDate,
    this.page,
    this.limit,
  });

  InvoiceFilter get copyValues => InvoiceFilter(
        adminAcceptance: adminAcceptance,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        orderStatus: orderStatus,
        startInvoiceDate: startInvoiceDate,
        endInvoiceDate: endInvoiceDate,
        page: page,
        limit: limit,
      );

  bool isClear() {
    return adminAcceptance == null &&
        paymentMethod == null &&
        paymentStatus == null &&
        orderStatus == null;
  }
}
