import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/category.dart';
import '../../repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  List<Category> categoryList = [];
  String selectedCategoryName = '';

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<OnLoadCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      categoryList = [];

      try {
        final response = await _categoryRepository.getAllCategories();

        response.fold(
          (failure) => emit(CategoryErrorState(response.toString())),
          (list) {
            categoryList = list;
            emit(CategoryLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<OnSelectedCategoryEvent>((event, emit) {
      selectedCategoryName = event.selectedCategoryName;
    });

    on<OnClearSelectedCategoryEvent>((event, emit) {
      selectedCategoryName = '';
    });
  }
}
