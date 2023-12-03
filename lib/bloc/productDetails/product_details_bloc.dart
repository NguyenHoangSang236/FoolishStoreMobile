import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/product.dart';
import '../../data/repository/shop_repository.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ShopRepository _shopRepository;
  List<Product> selectedProductDetails = [];

  String selectedColor = '';
  int selectedProductId = 0;

  ProductDetailsBloc(this._shopRepository) : super(ProductDetailsInitial()) {
    on<OnSelectProductEvent>((event, emit) async {
      emit(ProductDetailsLoadingState());

      try {
        selectedProductId = event.productId;

        final response =
            await _shopRepository.getProductDetails(event.productId);

        response.fold(
          (failure) => emit(ProductDetailsErrorState(failure.message)),
          (list) {
            selectedProductDetails = list;
            emit(ProductDetailsLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductDetailsErrorState(e.toString()));
      }
    });

    on<OnSelectProductColorEvent>((event, emit) {
      selectedColor = event.color;
      emit(ProductDetailsColorSelectedState(selectedColor));
    });
  }
}
