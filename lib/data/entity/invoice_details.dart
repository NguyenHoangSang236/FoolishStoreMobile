import 'package:json_annotation/json_annotation.dart';

import 'invoice.dart';
import 'invoice_item.dart';

part 'invoice_details.g.dart';

@JsonSerializable()
class InvoiceDetails {
  Invoice invoice;
  List<InvoiceItem> invoiceProducts;

  InvoiceDetails(this.invoice, this.invoiceProducts);

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDetailsToJson(this);
}
