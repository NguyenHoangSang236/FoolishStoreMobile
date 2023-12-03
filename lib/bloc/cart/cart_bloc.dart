import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/data/dto/cart_checkout.dart';
import 'package:fashionstore/data/enum/cart_enum.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/cart_item.dart';
import '../../data/entity/cart_item_info.dart';
import '../../data/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  List<CartItem> cartItemList = [];
  int currentPage = 1;
  int totalCartItemQuantity = 0;
  bool isFiltered = false;
  List<String> currentFilterOption = [];
  CartCheckout? currentCheckout;
  String currentBrandFilter = '';
  String currentNameFilter = '';

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<OnLoadAllCartListEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        final response = await _cartRepository.showFullCart(
          event.page,
          event.limit,
        );

        response.fold(
          (failure) => emit(CartErrorState(failure.message)),
          (list) {
            if (event.page != currentPage && list.isNotEmpty) {
              cartItemList = _removeDuplicates([...cartItemList, ...list]);
              currentPage = list.isNotEmpty ? event.page : currentPage;
              isFiltered = false;
              currentBrandFilter = '';
              currentNameFilter = '';
              currentFilterOption.clear();

              emit(AllCartListLoadedState(cartItemList));
            } else {
              cartItemList = list;
            }
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnClearCartEvent>((event, emit) {
      cartItemList = [];
      currentCheckout = null;
      totalCartItemQuantity = 0;
      isFiltered = false;
      currentBrandFilter = '';
      currentNameFilter = '';
      currentFilterOption.clear();
    });

    on<OnLoadTotalCartItemQuantityEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        final response = await _cartRepository.getTotalCartItemQuantity();

        response.fold(
          (failure) => emit(CartErrorState(failure.message)),
          (cartItemQuantity) {
            int quantity = int.parse(cartItemQuantity);

            totalCartItemQuantity = quantity;
            emit(TotalCartItemQuantityLoadedState(quantity));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnAddCartItemEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        final response = await _cartRepository.add(
          event.productId,
          event.color,
          event.size,
          event.quantity,
        );

        response.fold(
          (failure) => emit(CartErrorState(failure.message)),
          (message) => emit(CartAddedState(message)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnRemoveCartItemEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        final response = await _cartRepository.remove(event.cartIdList);

        response.fold(
          (failure) => emit(CartErrorState(failure.message)),
          (message) => emit(CartRemovedState(message)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnUpdateCartEvent>((event, emit) async {
      if (event.needReload == true) {
        emit(CartLoadingState());

        try {
          final response = await _cartRepository.update(event.cartItemList);

          response.fold(
            (failure) => emit(CartErrorState(failure.message)),
            (message) => emit(CartUpdatedState(message)),
          );
        } catch (e) {
          debugPrint(e.toString());
          emit(CartErrorState(e.toString()));
        }
      } else {
        try {
          final response = await _cartRepository.update(event.cartItemList);

          response.fold(
            (failure) => emit(CartErrorState(failure.message)),
            (message) => emit(CartSelectedState()),
          );
        } catch (e) {
          debugPrint(e.toString());
          emit(CartErrorState(e.toString()));
        }
      }
    });

    on<OnFilterCartEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        final response = await _cartRepository.filterCartItems(
          event.name,
          event.status,
          event.brand,
          event.page,
          event.limit,
        );

        response.fold(
          (failure) => emit(CartErrorState(failure.message)),
          (list) {
            if (event.page != null) {
              if (event.page != currentPage) {
                cartItemList = _removeDuplicates([...cartItemList, ...list]);
                currentPage = list.isNotEmpty ? event.page ?? 1 : currentPage;
                isFiltered = true;
              }
            } else {
              cartItemList = list;
            }

            currentBrandFilter = event.brand ?? '';
            currentNameFilter = event.name ?? '';
            currentFilterOption = event.status ?? [];

            if (event.name == null &&
                event.brand == null &&
                event.status == [CartEnum.SELECTED.name]) {
              emit(CartFilteredToCheckoutState(cartItemList));
            } else {
              emit(CartFilteredState(cartItemList));
            }
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });

    on<OnCheckoutEvent>((event, emit) async {
      emit(CartCheckoutLoadingState());

      try {
        final response = await _cartRepository.checkout();

        response.fold(
          (failure) => emit(CartErrorState(failure.message)),
          (cartCheckout) {
            currentCheckout = cartCheckout;

            emit(CartCheckoutState(cartCheckout));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CartErrorState(e.toString()));
      }
    });
  }

  List<CartItem> _removeDuplicates(List<CartItem> list) {
    Set<int> set = {};
    List<CartItem> uniqueList =
        list.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
