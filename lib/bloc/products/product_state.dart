part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
}

class ProductInitial extends ProductState {
  @override
  List<Object> get props => [];
}

class ProductLoadingState extends ProductState {
  @override
  List<Object> get props => [];
}

class ProductTopBestSellerListLoadedState extends ProductState {
  final List<Product> productList;

  const ProductTopBestSellerListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductFilteredListLoadedState extends ProductState {
  final List<Product> productList;

  const ProductFilteredListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductHotDiscountListLoadedState extends ProductState {
  final List<Product> productList;

  const ProductHotDiscountListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductNewArrivalListLoadedState extends ProductState {
  final List<Product> productList;

  const ProductNewArrivalListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductAllListLoadedState extends ProductState {
  final List<Product> productList;

  const ProductAllListLoadedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductRatedState extends ProductState {
  final String message;

  const ProductRatedState(this.message);

  @override
  List<Object> get props => [message];
}

class ProductRecommendedState extends ProductState {
  final List<Product> productList;

  const ProductRecommendedState(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductErrorState extends ProductState {
  final String message;

  const ProductErrorState(this.message);

  @override
  List<Object> get props => [message];
}
