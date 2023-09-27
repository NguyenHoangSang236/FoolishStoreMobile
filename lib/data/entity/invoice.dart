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

  String getPaymentMethod() {
    return paymentMethod == PaymentEnum.PAYPAL.name
        ? 'Paypal'
        : paymentMethod == PaymentEnum.MOMO.name
            ? 'Momo'
            : paymentMethod == PaymentEnum.COD.name
                ? 'COD'
                : paymentMethod == PaymentEnum.BANK_TRANSFER.name
                    ? 'Master card'
                    : 'Undefined';
  }

  String getDeliveryStatus() {
    return deliveryStatus == DeliveryEnum.NOT_SHIPPED.name
        ? 'Not shipped'
        : deliveryStatus == DeliveryEnum.ACCEPTANCE_WAITING.name
            ? 'Waiting for Admin\'s acceptance'
            : deliveryStatus == DeliveryEnum.SHIPPING.name
                ? 'Shipping'
                : deliveryStatus == DeliveryEnum.FAILED.name
                    ? 'Shipped failed'
                    : deliveryStatus == DeliveryEnum.SHIPPED.name
                        ? 'Shipped successfully'
                        : deliveryStatus == DeliveryEnum.CUSTOMER_CANCEL.name
                            ? 'Customer canceled order'
                            : deliveryStatus == DeliveryEnum.SHIPPER_CANCEL.name
                                ? 'Shipper canceled order'
                                : deliveryStatus == DeliveryEnum.PACKING.name
                                    ? 'We are packing your order'
                                    : deliveryStatus ==
                                            DeliveryEnum.SHIPPER_WAITING.name
                                        ? 'Waiting for shipper to take your order'
                                        : deliveryStatus ==
                                                DeliveryEnum
                                                    .NORMAL_DELIVERY.name
                                            ? 'Normal delivery'
                                            : deliveryStatus ==
                                                    DeliveryEnum
                                                        .EXPRESS_DELIVERY.name
                                                ? 'Express delivery'
                                                : deliveryStatus ==
                                                        DeliveryEnum
                                                            .PAYMENT_WAITING
                                                            .name
                                                    ? 'Waiting for your online payment'
                                                    : deliveryStatus ==
                                                            DeliveryEnum
                                                                .FIRST_ATTEMPT_FAILED
                                                                .name
                                                        ? 'Shipped failed once'
                                                        : deliveryStatus ==
                                                                DeliveryEnum
                                                                    .SECOND_ATTEMPT_FAILED
                                                                    .name
                                                            ? 'Shipped failed twice'
                                                            : 'Undefined';
  }

  @override
  String toString() {
    return 'Invoice{id: $id, invoiceDate: $invoiceDate, payDate: $payDate, deliveryStatus: $deliveryStatus, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, currency: $currency, intent: $intent, description: $description, refundPercentage: $refundPercentage, totalPrice: $totalPrice, reason: $reason, adminAcceptance: $adminAcceptance}';
  }
}
