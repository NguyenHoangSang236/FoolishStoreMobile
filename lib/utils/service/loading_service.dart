import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/categories/category_bloc.dart';
import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/category.dart';
import '../../data/entity/product.dart';

class LoadingService {
  final BuildContext context;

  LoadingService(this.context);

  void reloadIndexPage() {
    BlocProvider.of<CategoryBloc>(context).add(OnLoadCategoryEvent());
    BlocProvider.of<ProductBloc>(context)
      ..add(const OnLoadNewArrivalProductListEvent())
      ..add(const OnLoadTopBestSellerProductListEvent())
      ..add(const OnLoadHotDiscountProductListEvent());
    BlocProvider.of<CartBloc>(context).add(OnLoadTotalCartItemQuantityEvent());
  }

  void selectToViewProduct(Product product) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        BlocProvider.of<CommentBloc>(context).add(const OnClearCommentEvent());
        BlocProvider.of<ProductDetailsBloc>(context)
          ..add(
            OnSelectProductEvent(product.productId),
          )
          ..add(
            OnSelectProductColorEvent(product.color),
          );
        BlocProvider.of<ProductAddToCartBloc>(context).add(
          OnSelectProductAddToCartEvent(
            productName: product.name,
            color: product.color,
            size: product.size.toLowerCase() == 'none' ? product.size : '',
          ),
        );
        BlocProvider.of<CommentBloc>(context)
          ..add(
            OnLoadCommentIdYouLikedListEvent(
              productColor: product.color,
              productId: product.id,
            ),
          )
          ..add(
            OnLoadCommentListEvent(
              productColor: product.color,
              productId: product.id,
            ),
          );
      },
    );
  }

  void reloadCartPage() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        BlocProvider.of<CartBloc>(context)
          ..add(const OnLoadAllCartListEvent(1, 10))
          ..add(OnLoadTotalCartItemQuantityEvent());
      },
    );
  }

  void selectCategory(Category category) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        BlocProvider.of<ProductBloc>(context).add(
            OnLoadFilterProductListEvent(1, 8, categoryList: [category.name]));

        BlocProvider.of<CategoryBloc>(context)
            .add(OnSelectedCategoryEvent(category.name));

        context.router.replaceNamed(AppRouterPath.allProducts);
      },
    );
  }
}
