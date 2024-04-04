import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/product.dart';
import '../../data/enum/product_list_type_enum.dart';
import '../../data/repository/shop_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ShopRepository _shopRepository;

  List<Product> allProductList = [];
  List<Product> recommendedProductList = [];
  List<Product> filteredProductList = [];
  List<Product> hotDiscountProductList = [];
  List<Product> top8BestSellerProductList = [];
  List<Product> newArrivalProductList = [];
  Product? selectedProductToView;

  int currentAllProductListPage = 1;

  ProductBloc(this._shopRepository) : super(ProductInitial()) {
    on<OnLoadProductGeneralListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.getProductGeneralList(
          event.page,
          event.limit,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (list) {
            if (list.isNotEmpty) {
              if (event.page >= currentAllProductListPage) {
                currentAllProductListPage = event.page;
                allProductList =
                    _removeDuplicates([...allProductList, ...list]);
              }
            }

            emit(ProductGeneralListLoadedState(allProductList));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadHotDiscountProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.getProductListFromApi(
          ProductListTypeEnum.HOT_DISCOUNT.name,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (list) {
            hotDiscountProductList = list;
            emit(ProductHotDiscountListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadRecommendedProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.getRecommendProducts(
          event.productId,
          event.color,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (list) {
            recommendedProductList = list;
            emit(ProductRecommendedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadNewArrivalProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.getProductListFromApi(
          ProductListTypeEnum.NEW_ARRIVAL.name,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (list) {
            newArrivalProductList = list;
            emit(ProductNewArrivalListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnLoadTopBestSellerProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.getProductListFromApi(
          ProductListTypeEnum.TOP_BEST_SELLERS.name,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (list) {
            top8BestSellerProductList = list;
            emit(ProductTopBestSellerListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnClearProductListEvent>((event, emit) {
      filteredProductList = [];
      hotDiscountProductList = [];
      top8BestSellerProductList = [];
      newArrivalProductList = [];
    });

    on<OnLoadFilterProductListEvent>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.getFilteredProducts(
          event.page,
          event.limit,
          brand: event.brand,
          maxPrice: event.minPrice,
          minPrice: event.minPrice,
          categories: event.categoryList,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (list) {
            if (list.isNotEmpty) {
              currentAllProductListPage =
                  (list.isNotEmpty && event.page > currentAllProductListPage) ||
                          (list.isEmpty && event.page == 1)
                      ? event.page
                      : currentAllProductListPage;

              filteredProductList = currentAllProductListPage > 1
                  ? _removeDuplicates([...filteredProductList, ...list])
                  : List.of(list);

              emit(ProductFilteredListLoadedState(list));
            } else {
              emit(ProductFilteredListLoadedState(filteredProductList));
            }
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnRateProduct>((event, emit) async {
      emit(ProductLoadingState());

      try {
        final response = await _shopRepository.rateProduct(
          event.productId,
          event.color,
          event.overallRating,
        );

        response.fold(
          (failure) => emit(ProductErrorState(failure.message)),
          (message) => emit(ProductRatedState(message)),
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(ProductErrorState(e.toString()));
      }
    });

    on<OnSelectProduct>((event, emit) async {
      selectedProductToView = event.product;
    });

    on<OnDeselectProduct>((event, emit) async {
      selectedProductToView = null;
    });
  }

  List<Product> _removeDuplicates(List<Product> list) {
    Set<int> set = {};
    List<Product> uniqueList =
        list.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
