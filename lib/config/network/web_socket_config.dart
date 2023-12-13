import 'dart:async';

import 'package:fashionstore/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketConfig {
  static void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/unauthen/topic/messages',
      callback: (frame) {
        debugPrint('subscribe');
        debugPrint(frame.body);
      },
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient.send(
        destination: '/app/sendNotification',
        body: 'hello',
      );
    });
  }

  static Future<void> beforeConnect() async {}

  static void onStompError(StompFrame frame) {
    debugPrint('Catch Stomp error: ${frame.body}');
  }

  static void onWebSocketDone() {
    debugPrint('Connected to Web socket!');
  }

  static void onWebSocketError(dynamic error) {
    debugPrint('Can not to Web Socket, catch: $error');
  }
}
