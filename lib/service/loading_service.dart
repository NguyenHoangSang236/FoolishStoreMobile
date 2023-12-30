import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/dto/invoice_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/categories/category_bloc.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/productDetails/product_details_bloc.dart';
import '../data/entity/category.dart';
import '../data/entity/product.dart';

class LoadingService {
  final BuildContext context;

  LoadingService(this.context);

  void reloadIndexPage() {
    context.read<CategoryBloc>().add(OnLoadCategoryEvent());
    context.read<ProductBloc>()
      ..add(const OnLoadNewArrivalProductListEvent())
      ..add(const OnLoadTopBestSellerProductListEvent())
      ..add(const OnLoadHotDiscountProductListEvent());
    context.read<CartBloc>()
      ..add(OnLoadTotalCartItemQuantityEvent())
      ..add(const OnLoadAllCartListEvent(1, 10));
  }

  Future<void> selectToViewProduct(Product product) async {
    return Future.delayed(
      const Duration(milliseconds: 150),
      () {
        context.read<CommentBloc>().add(const OnClearCommentEvent());
        context.read<ProductDetailsBloc>()
          ..add(
            OnSelectProductEvent(product.productId),
          )
          ..add(
            OnSelectProductColorEvent(product.color),
          );
        context.read<ProductAddToCartBloc>().add(
              OnSelectProductAddToCartEvent(
                productName: product.name,
                color: product.color,
                size: product.size.toLowerCase() == 'none' ? product.size : '',
              ),
            );
        context.read<CommentBloc>()
          ..add(
            OnLoadCommentIdYouLikedListEvent(
              productColor: product.color,
              productId: product.productId,
            ),
          )
          ..add(
            OnLoadCommentListEvent(
              productColor: product.color,
              productId: product.productId,
            ),
          );
      },
    );
  }

  void reloadCartPage() {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        context.read<CartBloc>()
          ..add(const OnLoadAllCartListEvent(1, 10))
          ..add(OnLoadTotalCartItemQuantityEvent());
      },
    );
  }

  void reloadAndClearPurchaseHistoryPage() {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        InvoiceFilter invoiceFilter =
            context.read<InvoiceBloc>().currentInvoiceFilter.copyValues;

        invoiceFilter.page = 1;
        invoiceFilter.limit = 10;

        context.read<InvoiceBloc>().add(
              OnFilterInvoiceEvent(invoiceFilter),
            );
      },
    );
  }

  void selectCategory(Category category) {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        context.read<ProductBloc>().add(OnLoadFilterProductListEvent(
              1,
              8,
              categoryList: [category.name],
            ));

        context.read<CategoryBloc>().add(
              OnSelectedCategoryEvent(category.name),
            );

        context.router.replaceNamed(AppRouterPath.allProducts);
      },
    );
  }

  void reloadNotificationPage() {
    context.read<NotificationBloc>().add(
          OnLoadNotificationList(
            10,
            1,
            DateTime(2023, 01, 01),
            DateTime.now(),
          ),
        );
  }
}
