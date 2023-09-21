import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  @JsonKey(name: 'id')
  int id;
  DateTime invoiceDate;
  DateTime? payDate;
  String deliveryStatus;
  String paymentStatus;
  String paymentMethod;
  String currency;
  String? intent;
  String? description;
  double refundPercentage;
  double totalPrice;
  String? reason;
  String adminAcceptance;

  Invoice(
    this.id,
    this.invoiceDate,
    this.payDate,
    this.deliveryStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.currency,
    this.intent,
    this.description,
    this.refundPercentage,
    this.totalPrice,
    this.reason,
    this.adminAcceptance,
  );

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  @override
  String toString() {
    return 'Invoice{id: $id, invoiceDate: $invoiceDate, payDate: $payDate, deliveryStatus: $deliveryStatus, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, currency: $currency, intent: $intent, description: $description, refundPercentage: $refundPercentage, totalPrice: $totalPrice, reason: $reason, adminAcceptance: $adminAcceptance}';
  }
}
