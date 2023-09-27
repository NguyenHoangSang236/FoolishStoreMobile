import 'dart:async';

import 'package:fashionstore/main.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketConfig {
  static void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/unauthen/notification/showAllNotifications',
      callback: (frame) {
        print('subscribe');
        print(frame.body);
      },
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient.send(
        destination: '/app/sendNotification',
        body: '',
      );
    });
  }
}
