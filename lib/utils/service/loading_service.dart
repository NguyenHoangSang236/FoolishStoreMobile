import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/bloc/delivery/delivery_bloc.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/dto/invoice_filter.dart';
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
    BlocProvider.of<CartBloc>(context)
      ..add(OnLoadTotalCartItemQuantityEvent())
      ..add(const OnLoadAllCartListEvent(1, 10));
  }

  void selectToViewProduct(Product product) {
    Future.delayed(
      const Duration(milliseconds: 150),
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
      const Duration(milliseconds: 150),
      () {
        BlocProvider.of<CartBloc>(context)
          ..add(const OnLoadAllCartListEvent(1, 10))
          ..add(OnLoadTotalCartItemQuantityEvent());
      },
    );
  }

  void reloadAndClearPurchaseHistoryPage() {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        InvoiceFilter invoiceFilter = BlocProvider.of<InvoiceBloc>(context)
            .currentInvoiceFilter
            .copyValues;

        invoiceFilter.page = 1;
        invoiceFilter.limit = 10;

        BlocProvider.of<InvoiceBloc>(context).add(
          OnFilterInvoiceEvent(invoiceFilter),
        );
        
        if(BlocProvider.of<DeliveryBloc>(context).currentDeliveryTypeList.isEmpty) {
          BlocProvider.of<DeliveryBloc>(context).add(OnLoadDeliveryTypeEvent());
        }
      },
    );
  }

  void selectCategory(Category category) {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        BlocProvider.of<ProductBloc>(context).add(OnLoadFilterProductListEvent(
          1,
          8,
          categoryList: [category.name],
        ));

        BlocProvider.of<CategoryBloc>(context).add(
          OnSelectedCategoryEvent(category.name),
        );

        context.router.replaceNamed(AppRouterPath.allProducts);
      },
    );
  }
}
