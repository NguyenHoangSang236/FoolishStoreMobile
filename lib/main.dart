import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/bloc/map/map_bloc.dart';
import 'package:fashionstore/bloc/notification/notification_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/config/network/dio_config.dart';
import 'package:fashionstore/config/network/web_socket_config.dart';
import 'package:fashionstore/data/repository/authentication_repository.dart';
import 'package:fashionstore/data/repository/cart_repository.dart';
import 'package:fashionstore/data/repository/category_repository.dart';
import 'package:fashionstore/data/repository/comment_repository.dart';
import 'package:fashionstore/data/repository/google_drive_repository.dart';
import 'package:fashionstore/data/repository/invoice_repository.dart';
import 'package:fashionstore/data/repository/notification_repository.dart';
import 'package:fashionstore/data/repository/shop_repository.dart';
import 'package:fashionstore/data/repository/translator_repository.dart';
import 'package:fashionstore/service/firebase_messaging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

import 'bloc/invoice/invoice_bloc.dart';
import 'bloc/productDetails/product_details_bloc.dart';
import 'bloc/productSearching/product_searching_bloc.dart';
import 'bloc/products/product_bloc.dart';
import 'config/app_router/app_router_config.dart';
import 'config/network/http_client_config.dart';
import 'data/repository/map_repository.dart';
import 'firebase_options.dart';

final appRouter = AppRouter();
final Dio dio = Dio();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// const String domainIP = '103.200.20.153';
const String domainIP = '192.168.1.100';
const String websocketDestinationPrefix = '/commentWebSocket';
const String websocketDestination = '/comment';
const String apiKey = 'AIzaSyB81Tx01sQmpvx8VV7jKi7rE_4WZnoE0_g';
const String serverKey =
    'AAAAH7hqSWE:APA91bGqmPdUdqwem730s38CXslW7ayoQLke4NQ9OXEGLAvAKodv7_PBXhlvHnc8g4g35uj3lGv_rU6war90LHk74luKiFSvpK0GuVK4_gZXSUHF4yMnLzcy8bZoi8RZYIfvKbWaAxuC';

final StompClient stompClient = StompClient(
  config: const StompConfig(
    url: 'wss://$domainIP:8080/websocket',
    onConnect: WebSocketConfig.onConnect,
    onStompError: WebSocketConfig.onStompError,
    onWebSocketError: WebSocketConfig.onWebSocketError,
    onWebSocketDone: WebSocketConfig.onWebSocketDone,
    onDisconnect: WebSocketConfig.onWebSocketDisconnect,
  ),
);

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
  // await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');

  stompClient.activate();

  FirebaseMessagingService.initializeLocalNotifications(debug: true);
  FirebaseMessagingService.initializeRemoteNotifications(debug: true);

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: message.hashCode,
      channelKey: "high_importance_channel",
      title: message.data['title'],
      body: message.data['body'],
      bigPicture: message.data['image'],
      notificationLayout: NotificationLayout.BigPicture,
      largeIcon: message.data['image'],
      payload: Map<String, String>.from(message.data),
      hideLargeIconOnExpand: true,
    ),
  );
}

void main() async {
  HttpOverrides.global = HttpClientConfig();

  DioConfig.configBasicOptions(dio);
  DioConfig.configInterceptors(dio);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  FirebaseMessagingService.initializeLocalNotifications(debug: true);
  FirebaseMessagingService.initializeRemoteNotifications(debug: true);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
        RepositoryProvider<ShopRepository>(
          create: (context) => ShopRepository(),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
        ),
        RepositoryProvider<CartRepository>(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider<TranslatorRepository>(
          create: (context) => TranslatorRepository(),
        ),
        RepositoryProvider<CommentRepository>(
          create: (context) => CommentRepository(),
        ),
        RepositoryProvider<GoogleDriveRepository>(
          create: (context) => GoogleDriveRepository(),
        ),
        RepositoryProvider<InvoiceRepository>(
          create: (context) => InvoiceRepository(),
        ),
        RepositoryProvider<MapRepository>(
          create: (context) => MapRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              RepositoryProvider.of<CategoryRepository>(context),
            ),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
              RepositoryProvider.of<ShopRepository>(context),
            ),
          ),
          BlocProvider<ProductSearchingBloc>(
            create: (context) => ProductSearchingBloc(
              RepositoryProvider.of<ShopRepository>(context),
            ),
          ),
          BlocProvider<ProductDetailsBloc>(
            create: (context) => ProductDetailsBloc(
              RepositoryProvider.of<ShopRepository>(context),
            ),
          ),
          BlocProvider<ProductAddToCartBloc>(
              create: (context) => ProductAddToCartBloc()),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              RepositoryProvider.of<AuthenticationRepository>(context),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              RepositoryProvider.of<CartRepository>(context),
            ),
          ),
          BlocProvider<TranslatorBloc>(
            create: (context) => TranslatorBloc(
              RepositoryProvider.of<TranslatorRepository>(context),
            ),
          ),
          BlocProvider<CommentBloc>(
            create: (context) => CommentBloc(
              RepositoryProvider.of<CommentRepository>(context),
            ),
          ),
          BlocProvider<UploadFileBloc>(
            create: (context) => UploadFileBloc(
              RepositoryProvider.of<GoogleDriveRepository>(context),
            ),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(
              RepositoryProvider.of<NotificationRepository>(context),
            ),
          ),
          BlocProvider<InvoiceBloc>(
            create: (context) => InvoiceBloc(
              RepositoryProvider.of<InvoiceRepository>(context),
            ),
          ),
          BlocProvider<MapBloc>(
            create: (context) => MapBloc(
              RepositoryProvider.of<MapRepository>(context),
            ),
          ),
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
  void initState() {
    FirebaseMessagingService.checkPermission();
    FirebaseMessagingService.requestFirebaseToken();
    FirebaseMessagingService.startListeningNotificationEvents();

    super.initState();
  }

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
