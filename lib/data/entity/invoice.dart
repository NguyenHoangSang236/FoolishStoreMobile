import 'package:fashionstore/data/enum/delivery_enum.dart';
import 'package:fashionstore/data/enum/payment_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  @JsonKey(name: 'id')
  int id;
  DateTime invoiceDate;
  DateTime? payDate;
  String? orderStatus;
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
    this.orderStatus,
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

  String getPaymentMethod() {
    return paymentMethod == PaymentMethodEnum.PAYPAL.name
        ? 'Paypal'
        : paymentMethod == PaymentMethodEnum.MOMO.name
            ? 'Momo'
            : paymentMethod == PaymentMethodEnum.COD.name
                ? 'COD'
                : paymentMethod == PaymentMethodEnum.BANK_TRANSFER.name
                    ? 'Master card'
                    : 'Undefined';
  }

  String getDeliveryStatus() {
    return orderStatus == DeliveryEnum.NOT_SHIPPED.name
        ? 'Not shipped'
        : orderStatus == DeliveryEnum.ACCEPTANCE_WAITING.name
            ? 'Waiting for Admin\'s acceptance'
            : orderStatus == DeliveryEnum.SHIPPING.name
                ? 'Shipping'
                : orderStatus == DeliveryEnum.FAILED.name
                    ? 'Shipped failed'
                    : orderStatus == DeliveryEnum.SHIPPED.name
                        ? 'Shipped successfully'
                        : orderStatus == DeliveryEnum.CUSTOMER_CANCEL.name
                            ? 'Customer canceled order'
                            : orderStatus == DeliveryEnum.SHIPPER_CANCEL.name
                                ? 'Shipper canceled order'
                                : orderStatus == DeliveryEnum.PACKING.name
                                    ? 'We are packing your order'
                                    : orderStatus ==
                                            DeliveryEnum.SHIPPER_WAITING.name
                                        ? 'Waiting for shipper to take your order'
                                        : orderStatus ==
                                                DeliveryEnum
                                                    .PAYMENT_WAITING.name
                                            ? 'Waiting for your online payment'
                                            : orderStatus ==
                                                    DeliveryEnum
                                                        .FIRST_ATTEMPT_FAILED
                                                        .name
                                                ? 'Shipped failed once'
                                                : orderStatus ==
                                                        DeliveryEnum
                                                            .SECOND_ATTEMPT_FAILED
                                                            .name
                                                    ? 'Shipped failed twice'
                                                    : 'Undefined';
  }

  @override
  String toString() {
    return 'Invoice{id: $id, invoiceDate: $invoiceDate, payDate: $payDate, orderStatus: $orderStatus, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, currency: $currency, intent: $intent, description: $description, refundPercentage: $refundPercentage, totalPrice: $totalPrice, reason: $reason, adminAcceptance: $adminAcceptance}';
  }
}
