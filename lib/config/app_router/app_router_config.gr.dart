// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router_config.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AllCategoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AllCategoriesPage(),
      );
    },
    AllProductsRoute.name: (routeData) {
      final args = routeData.argsAs<AllProductsRouteArgs>(
          orElse: () => const AllProductsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AllProductsPage(
          key: args.key,
          isFromCategoryPage: args.isFromCategoryPage,
        ),
      );
    },
    CartRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartPage(),
      );
    },
    IndexRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IndexPage(),
      );
    },
    InitialLoadingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InitialLoadingPage(),
      );
    },
    InvoiceDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<InvoiceDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InvoiceDetailsPage(
          key: args.key,
          invoiceId: args.invoiceId,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MapRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapPage(),
      );
    },
    NotificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPage(),
      );
    },
    OnlinePaymentReceiverInfoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnlinePaymentReceiverInfoPage(),
      );
    },
    PhotoViewRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoViewRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PhotoViewPage(
          key: args.key,
          url: args.url,
        ),
      );
    },
    ProductDetailsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProductDetailsPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    PurchaseHistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PurchaseHistoryPage(),
      );
    },
    SearchingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchingPage(),
      );
    },
  };
}

/// generated route for
/// [AllCategoriesPage]
class AllCategoriesRoute extends PageRouteInfo<void> {
  const AllCategoriesRoute({List<PageRouteInfo>? children})
      : super(
          AllCategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AllCategoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AllProductsPage]
class AllProductsRoute extends PageRouteInfo<AllProductsRouteArgs> {
  AllProductsRoute({
    Key? key,
    bool isFromCategoryPage = false,
    List<PageRouteInfo>? children,
  }) : super(
          AllProductsRoute.name,
          args: AllProductsRouteArgs(
            key: key,
            isFromCategoryPage: isFromCategoryPage,
          ),
          initialChildren: children,
        );

  static const String name = 'AllProductsRoute';

  static const PageInfo<AllProductsRouteArgs> page =
      PageInfo<AllProductsRouteArgs>(name);
}

class AllProductsRouteArgs {
  const AllProductsRouteArgs({
    this.key,
    this.isFromCategoryPage = false,
  });

  final Key? key;

  final bool isFromCategoryPage;

  @override
  String toString() {
    return 'AllProductsRouteArgs{key: $key, isFromCategoryPage: $isFromCategoryPage}';
  }
}

/// generated route for
/// [CartPage]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IndexPage]
class IndexRoute extends PageRouteInfo<void> {
  const IndexRoute({List<PageRouteInfo>? children})
      : super(
          IndexRoute.name,
          initialChildren: children,
        );

  static const String name = 'IndexRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InitialLoadingPage]
class InitialLoadingRoute extends PageRouteInfo<void> {
  const InitialLoadingRoute({List<PageRouteInfo>? children})
      : super(
          InitialLoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitialLoadingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InvoiceDetailsPage]
class InvoiceDetailsRoute extends PageRouteInfo<InvoiceDetailsRouteArgs> {
  InvoiceDetailsRoute({
    Key? key,
    required int invoiceId,
    List<PageRouteInfo>? children,
  }) : super(
          InvoiceDetailsRoute.name,
          args: InvoiceDetailsRouteArgs(
            key: key,
            invoiceId: invoiceId,
          ),
          initialChildren: children,
        );

  static const String name = 'InvoiceDetailsRoute';

  static const PageInfo<InvoiceDetailsRouteArgs> page =
      PageInfo<InvoiceDetailsRouteArgs>(name);
}

class InvoiceDetailsRouteArgs {
  const InvoiceDetailsRouteArgs({
    this.key,
    required this.invoiceId,
  });

  final Key? key;

  final int invoiceId;

  @override
  String toString() {
    return 'InvoiceDetailsRouteArgs{key: $key, invoiceId: $invoiceId}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapPage]
class MapRoute extends PageRouteInfo<void> {
  const MapRoute({List<PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnlinePaymentReceiverInfoPage]
class OnlinePaymentReceiverInfoRoute extends PageRouteInfo<void> {
  const OnlinePaymentReceiverInfoRoute({List<PageRouteInfo>? children})
      : super(
          OnlinePaymentReceiverInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnlinePaymentReceiverInfoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PhotoViewPage]
class PhotoViewRoute extends PageRouteInfo<PhotoViewRouteArgs> {
  PhotoViewRoute({
    Key? key,
    required String url,
    List<PageRouteInfo>? children,
  }) : super(
          PhotoViewRoute.name,
          args: PhotoViewRouteArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoViewRoute';

  static const PageInfo<PhotoViewRouteArgs> page =
      PageInfo<PhotoViewRouteArgs>(name);
}

class PhotoViewRouteArgs {
  const PhotoViewRouteArgs({
    this.key,
    required this.url,
  });

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'PhotoViewRouteArgs{key: $key, url: $url}';
  }
}

/// generated route for
/// [ProductDetailsPage]
class ProductDetailsRoute extends PageRouteInfo<void> {
  const ProductDetailsRoute({List<PageRouteInfo>? children})
      : super(
          ProductDetailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductDetailsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PurchaseHistoryPage]
class PurchaseHistoryRoute extends PageRouteInfo<void> {
  const PurchaseHistoryRoute({List<PageRouteInfo>? children})
      : super(
          PurchaseHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'PurchaseHistoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchingPage]
class SearchingRoute extends PageRouteInfo<void> {
  const SearchingRoute({List<PageRouteInfo>? children})
      : super(
          SearchingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
