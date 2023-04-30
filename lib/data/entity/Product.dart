import 'package:json_annotation/json_annotation.dart';

part 'Product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: 'id')
  int id;
  int productId;
  String name;
  double sellingPrice;
  double discount;
  String brand;
  String size;
  String color;
  int availableQuantity;
  String image1;
  String image2;
  String image3;
  String image4;
  int overallRating;

  Product(
      this.id,
      this.productId,
      this.name,
      this.sellingPrice,
      this.discount,
      this.brand,
      this.size,
      this.color,
      this.availableQuantity,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.overallRating
  );

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    return 'Product{id: $id, productId: $productId, name: $name, sellingPrice: $sellingPrice, discount: $discount, brand: $brand, size: $size, color: $color, availableQuantity: $availableQuantity, image1: $image1, image2: $image2, image3: $image3, image4: $image4, overallRating: $overallRating}';
  }
}