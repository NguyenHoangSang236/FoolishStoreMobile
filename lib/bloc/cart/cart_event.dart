part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class OnClearCartEvent extends CartEvent {}

class OnLoadAllCartListEvent extends CartEvent {
  final int page;
  final int limit;

  const OnLoadAllCartListEvent(this.page, this.limit);
}

class OnCheckoutEvent extends CartEvent {
  final DeliveryTypeEnum deliveryType;

  const OnCheckoutEvent(this.deliveryType);
}

class OnLoadTotalCartItemQuantityEvent extends CartEvent {}

class OnUpdateCartEvent extends CartEvent {
  final List<CartItemInfo> cartItemList;
  final bool needReload;

  const OnUpdateCartEvent(this.cartItemList, {required this.needReload});
}

class OnFilterCartEvent extends CartEvent {
  final String? name;
  final List<String>? status;
  final String? brand;
  final int? page;
  final int? limit;

  const OnFilterCartEvent(
      {this.name, this.status, this.brand, this.page, this.limit});
}

class OnRemoveCartItemEvent extends CartEvent {
  final List<int> cartIdList;

  const OnRemoveCartItemEvent(this.cartIdList);
}

class OnAddCartItemEvent extends CartEvent {
  final int productId;
  final String color;
  final String size;
  final int quantity;

  const OnAddCartItemEvent(
      this.productId, this.color, this.size, this.quantity);
}
