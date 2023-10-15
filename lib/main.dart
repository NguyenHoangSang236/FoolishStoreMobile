import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/bloc/delivery/delivery_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/config/network/dio_config.dart';
import 'package:fashionstore/repository/authentication_repository.dart';
import 'package:fashionstore/repository/cart_repository.dart';
import 'package:fashionstore/repository/category_repository.dart';
import 'package:fashionstore/repository/comment_repository.dart';
import 'package:fashionstore/repository/delivery_repository.dart';
import 'package:fashionstore/repository/google_drive_repository.dart';
import 'package:fashionstore/repository/invoice_repository.dart';
import 'package:fashionstore/repository/shop_repository.dart';
import 'package:fashionstore/repository/translator_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stomp_dart_client/stomp.dart';

import 'bloc/invoice/invoice_bloc.dart';
import 'bloc/productDetails/product_details_bloc.dart';
import 'bloc/productSearching/product_searching_bloc.dart';
import 'bloc/products/product_bloc.dart';
import 'config/app_router/app_router_config.dart';
import 'config/network/http_client_config.dart';

final appRouter = AppRouter();
final Dio dio = Dio();

const String domain = '192.168.1.9';
// const String domain = '192.168.1.22';

late StompClient stompClient;

void main() async {
  HttpOverrides.global = HttpClientConfig();

  DioConfig.configBasicOptions(dio);
  DioConfig.configInterceptors(dio);

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
            create: (context) => CategoryRepository()),
        RepositoryProvider<ShopRepository>(
            create: (context) => ShopRepository()),
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository()),
        RepositoryProvider<CartRepository>(
            create: (context) => CartRepository()),
        RepositoryProvider<TranslatorRepository>(
            create: (context) => TranslatorRepository()),
        RepositoryProvider<CommentRepository>(
            create: (context) => CommentRepository()),
        RepositoryProvider<GoogleDriveRepository>(
            create: (context) => GoogleDriveRepository()),
        RepositoryProvider<InvoiceRepository>(
            create: (context) => InvoiceRepository()),
        RepositoryProvider<DeliveryRepository>(
            create: (context) => DeliveryRepository()),
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
          BlocProvider<CommentBloc>(
              create: (context) => CommentBloc(
                  RepositoryProvider.of<CommentRepository>(context))),
          BlocProvider<UploadFileBloc>(
              create: (context) => UploadFileBloc(
                  RepositoryProvider.of<GoogleDriveRepository>(context))),
          BlocProvider<InvoiceBloc>(
              create: (context) => InvoiceBloc(
                  RepositoryProvider.of<InvoiceRepository>(context))),
          BlocProvider<DeliveryBloc>(
              create: (context) => DeliveryBloc(
                  RepositoryProvider.of<DeliveryRepository>(context))),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}
