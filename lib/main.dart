import 'dart:io';

import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/repository/authentication_repository.dart';
import 'package:fashionstore/repository/cart_repository.dart';
import 'package:fashionstore/repository/category_repository.dart';
import 'package:fashionstore/repository/google_drive_repository.dart';
import 'package:fashionstore/repository/shop_repository.dart';
import 'package:fashionstore/repository/translator_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/productDetails/product_details_bloc.dart';
import 'bloc/productSearching/product_searching_bloc.dart';
import 'bloc/products/product_bloc.dart';
import 'config/app_router/app_router_config.dart';
import 'config/network/http_client_config.dart';

void main() {
  HttpOverrides.global = HttpClientConfig();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository()),
      RepositoryProvider<ShopRepository>(create: (context) => ShopRepository()),
      RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository()),
      RepositoryProvider<CartRepository>(create: (context) => CartRepository()),
      RepositoryProvider<TranslatorRepository>(
          create: (context) => TranslatorRepository()),
      RepositoryProvider<GoogleDriveRepository>(
          create: (context) => GoogleDriveRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
                RepositoryProvider.of<CategoryRepository>(context))),
        BlocProvider<ProductBloc>(
            create: (context) =>
                ProductBloc(RepositoryProvider.of<ShopRepository>(context))),
        BlocProvider<ProductSearchingBloc>(
            create: (context) => ProductSearchingBloc(
                RepositoryProvider.of<ShopRepository>(context))),
        BlocProvider<ProductDetailsBloc>(
            create: (context) => ProductDetailsBloc(
                RepositoryProvider.of<ShopRepository>(context))),
        BlocProvider<ProductAddToCartBloc>(
            create: (context) => ProductAddToCartBloc()),
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                RepositoryProvider.of<AuthenticationRepository>(context))),
        BlocProvider<CartBloc>(
            create: (context) =>
                CartBloc(RepositoryProvider.of<CartRepository>(context))),
        BlocProvider<TranslatorBloc>(
            create: (context) => TranslatorBloc(
                RepositoryProvider.of<TranslatorRepository>(context))),
        BlocProvider<UploadFileBloc>(
            create: (context) => UploadFileBloc(
                RepositoryProvider.of<GoogleDriveRepository>(context))),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: _appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}
