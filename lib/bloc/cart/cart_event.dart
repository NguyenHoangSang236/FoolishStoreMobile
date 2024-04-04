part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class OnClearCartEvent extends CartEvent {}

class OnCheckoutEvent extends CartEvent {
  final AddressCode addressCode;
  final int serviceId;

  const OnCheckoutEvent(
    this.addressCode,
    this.serviceId,
  );
}

class OnLoadGhnAddressCodeEvent extends CartEvent {
  final AddressCodeRequest addressCodeRequest;

  const OnLoadGhnAddressCodeEvent(this.addressCodeRequest);
}

class OnLoadGhnAvailableShippingServicesEvent extends CartEvent {
  final int fromDistrictId;
  final int toDistrictId;

  const OnLoadGhnAvailableShippingServicesEvent(
    this.fromDistrictId,
    this.toDistrictId,
  );
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

  const OnFilterCartEvent({
    this.name,
    this.status,
    this.brand,
    this.page,
    this.limit,
  });
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
    this.productId,
    this.color,
    this.size,
    this.quantity,
  );
}

class OnLoadAddressCodeRequestEvent extends CartEvent {
  final LatLng latLng;

  const OnLoadAddressCodeRequestEvent(this.latLng);
}
