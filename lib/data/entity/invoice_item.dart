import 'package:json_annotation/json_annotation.dart';

part 'invoice_item.g.dart';

@JsonSerializable()
class InvoiceItem {
  int productId;
  String name;
  String? color;
  String? size;
  double sellingPrice;
  int quantity;
  double discount;
  String image1;

  InvoiceItem(
    this.productId,
    this.name,
    this.color,
    this.size,
    this.sellingPrice,
    this.quantity,
    this.discount,
    this.image1,
  );

  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);

  @override
  String toString() {
    return 'InvoiceItem{productId: $productId, name: $name, color: $color, size: $size, sellingPrice: $sellingPrice, quantity: $quantity, discount: $discount, image1: $image1}';
  }
}
