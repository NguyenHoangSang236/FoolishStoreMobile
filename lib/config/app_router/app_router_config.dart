import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/views/screens/index_page.dart';
import 'package:flutter/cupertino.dart';

import '../../views/screens/all_categories_page.dart';
import '../../views/screens/all_products_page.dart';
import '../../views/screens/cart_page.dart';
import '../../views/screens/initial_loading_page.dart';
import '../../views/screens/invoice_details_page.dart';
import '../../views/screens/login_page.dart';
import '../../views/screens/map_page.dart';
import '../../views/screens/notification_page.dart';
import '../../views/screens/online_payment_receiver_info_page.dart';
import '../../views/screens/photo_view_page.dart';
import '../../views/screens/product_details_page.dart';
import '../../views/screens/profile_page.dart';
import '../../views/screens/purchase_history_page.dart';
import '../../views/screens/searching_page.dart';

part 'app_router_config.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: AppRouterPath.login,
        ),
        AutoRoute(
          page: AllCategoriesRoute.page,
          path: AppRouterPath.allCategories,
        ),
        AutoRoute(
          page: AllProductsRoute.page,
          path: AppRouterPath.allProducts,
        ),
        AutoRoute(
          page: CartRoute.page,
          path: AppRouterPath.cart,
        ),
        AutoRoute(
          page: IndexRoute.page,
          path: AppRouterPath.index,
        ),
        AutoRoute(
          page: InitialLoadingRoute.page,
          path: AppRouterPath.initialLoading,
          initial: true,
        ),
        AutoRoute(
          page: ProductDetailsRoute.page,
          path: AppRouterPath.productDetails,
        ),
        AutoRoute(
          page: ProfileRoute.page,
          path: AppRouterPath.profile,
        ),
        AutoRoute(
          page: SearchingRoute.page,
          path: AppRouterPath.searching,
        ),
        AutoRoute(
          page: MapRoute.page,
          path: AppRouterPath.map,
        ),
        AutoRoute(
          page: OnlinePaymentReceiverInfoRoute.page,
          path: AppRouterPath.onlinePaymentReceiverInfo,
        ),
        AutoRoute(
          page: PurchaseHistoryRoute.page,
          path: AppRouterPath.purchaseHistory,
        ),
        AutoRoute(
          page: NotificationRoute.page,
          path: AppRouterPath.notification,
        ),
        AutoRoute(
          page: InvoiceDetailsRoute.page,
          path: AppRouterPath.invoiceDetails,
        ),
      ];
}
