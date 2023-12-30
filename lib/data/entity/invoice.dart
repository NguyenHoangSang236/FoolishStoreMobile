import 'package:fashionstore/data/enum/order_status_enum.dart';
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
  String? address;
  int? districtId;
  String? wardCode;
  double deliveryFee;
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
    this.address,
    this.districtId,
    this.wardCode,
    this.deliveryFee,
    this.adminAcceptance,
  );

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  String getPaymentMethod() {
    return paymentMethod == PaymentMethodEnum.MOMO.name
        ? 'Momo'
        : paymentMethod == PaymentMethodEnum.COD.name
            ? 'COD'
            : paymentMethod == PaymentMethodEnum.BANK_TRANSFER.name
                ? 'Master card'
                : 'Undefined';
  }

  String getOrderStatus() {
    return orderStatus == OrderStatusEnum.FINISH_PACKING.name
        ? 'Finished packing'
        : orderStatus == OrderStatusEnum.ACCEPTANCE_WAITING.name
            ? 'Waiting for Admin\'s acceptance'
            : orderStatus == OrderStatusEnum.SHIPPING.name
                ? 'Shipping'
                : orderStatus == OrderStatusEnum.FAILED.name
                    ? 'Shipped failed'
                    : orderStatus == OrderStatusEnum.CUSTOMER_CANCEL.name
                        ? 'Customer canceled order'
                        : orderStatus == OrderStatusEnum.SHIPPER_CANCEL.name
                            ? 'Shipper canceled order'
                            : orderStatus == OrderStatusEnum.PACKING.name
                                ? 'We are packing your order'
                                : orderStatus ==
                                        OrderStatusEnum.PAYMENT_WAITING.name
                                    ? 'Waiting for your online payment'
                                    : orderStatus ==
                                            OrderStatusEnum.SUCCESS.name
                                        ? 'Success'
                                        : 'Undefined';
  }

  @override
  String toString() {
    return 'Invoice{id: $id, invoiceDate: $invoiceDate, payDate: $payDate, orderStatus: $orderStatus, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, currency: $currency, intent: $intent, description: $description, refundPercentage: $refundPercentage, totalPrice: $totalPrice, reason: $reason, adminAcceptance: $adminAcceptance}';
  }
}
