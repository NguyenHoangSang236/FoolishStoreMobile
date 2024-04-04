part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

class CartCheckoutLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

class CartFilteredState extends CartState {
  final List<CartItem> cartItemList;

  const CartFilteredState(this.cartItemList);

  @override
  List<Object> get props => [cartItemList];
}

class CartCheckoutState extends CartState {
  final CartCheckout cartCheckout;

  const CartCheckoutState(this.cartCheckout);

  @override
  List<Object> get props => [cartCheckout];
}

class CartFilteredToCheckoutState extends CartState {
  final List<CartItem> cartItemList;

  const CartFilteredToCheckoutState(this.cartItemList);

  @override
  List<Object> get props => [cartItemList];
}

class TotalCartItemQuantityLoadedState extends CartState {
  final int totalQuantity;

  const TotalCartItemQuantityLoadedState(this.totalQuantity);

  @override
  List<Object> get props => [totalQuantity];
}

class CartAddedState extends CartState {
  final String message;

  const CartAddedState(this.message);

  @override
  List<Object> get props => [message];
}

class CartRemovedState extends CartState {
  final String message;

  const CartRemovedState(this.message);

  @override
  List<Object> get props => [message];
}

class CartUpdatedState extends CartState {
  final String message;

  const CartUpdatedState(this.message);

  @override
  List<Object> get props => [message];
}

class AddressCodeLoadedState extends CartState {
  final AddressCode addressCode;

  const AddressCodeLoadedState(this.addressCode);

  @override
  List<Object> get props => [addressCode];
}

class AddressCodeRequestLoadedState extends CartState {
  final AddressCodeRequest addressCodeRequest;

  const AddressCodeRequestLoadedState(this.addressCodeRequest);

  @override
  List<Object> get props => [addressCodeRequest];
}

class GhnShippingServiceListLoadedState extends CartState {
  final List<GhnShippingService> serviceList;

  const GhnShippingServiceListLoadedState(this.serviceList);

  @override
  List<Object> get props => [serviceList];
}

class CartSelectedState extends CartState {
  @override
  List<Object> get props => [];
}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState(this.message);

  @override
  List<Object> get props => [message];
}
