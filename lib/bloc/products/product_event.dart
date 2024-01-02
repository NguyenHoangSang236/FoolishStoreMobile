part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadAllProductListEvent extends ProductEvent {
  final int page;
  final int limit;

  const OnLoadAllProductListEvent(this.page, this.limit);
}

class OnLoadFilterProductListEvent extends ProductEvent {
  final int page;
  final int limit;
  final List<String>? categoryList;
  final String? brand;
  final String? name;
  final double? minPrice;
  final double? maxPrice;

  const OnLoadFilterProductListEvent(
    this.page,
    this.limit, {
    this.categoryList,
    this.brand,
    this.name,
    this.minPrice,
    this.maxPrice,
  });
}

class OnSelectProduct extends ProductEvent {
  final Product product;

  const OnSelectProduct(this.product);
}

class OnDeselectProduct extends ProductEvent {}

class OnRateProduct extends ProductEvent {
  final int productId;
  final String color;
  final int overallRating;

  const OnRateProduct(this.productId, this.color, this.overallRating);
}

class OnLoadHotDiscountProductListEvent extends ProductEvent {
  const OnLoadHotDiscountProductListEvent();
}

class OnLoadTopBestSellerProductListEvent extends ProductEvent {
  const OnLoadTopBestSellerProductListEvent();
}

class OnLoadRecommendedProductListEvent extends ProductEvent {
  final String color;
  final int productId;

  const OnLoadRecommendedProductListEvent(this.color, this.productId);
}

class OnLoadNewArrivalProductListEvent extends ProductEvent {
  const OnLoadNewArrivalProductListEvent();
}

class OnClearProductListEvent extends ProductEvent {}
