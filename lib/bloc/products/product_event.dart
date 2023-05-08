part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class OnSearchProductEvent extends ProductEvent{
  final String productName;

  const OnSearchProductEvent(this.productName);
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
      this.maxPrice});
}

class OnLoadHotDiscountProductListEvent extends ProductEvent {
  const OnLoadHotDiscountProductListEvent();
}

class OnLoadTopBestSellerProductListEvent extends ProductEvent {
  const OnLoadTopBestSellerProductListEvent();
}

class OnLoadNewArrivalProductListEvent extends ProductEvent {
  const OnLoadNewArrivalProductListEvent();
}

class OnClearProductListEvent extends ProductEvent {}