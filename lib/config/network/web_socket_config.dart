import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketConfig {
  static void onConnect(StompFrame frame) {
    debugPrint('*** Web socket ***');
    debugPrint('Connected to Web socket successfully');
    debugPrint(frame.body);
    debugPrint(frame.headers.toString());
    debugPrint('\n*** Web socket ***');

    // stompClient.subscribe(
    //   destination:
    //       '/comment/product_id=${product.id}&product_color=${product.color}',
    //   callback: (frame) {
    //     debugPrint(frame.body);
    //   },
    // );
    //
    // stompClient.send(
    //   destination: '/commentWebsocket/addUser',
    //   body: json.encode({
    //     'sender': 'aaaa',
    //     'type': 'JOIN',
    //   }),
    // );
  }

  static Future<void> beforeConnect() async {}

  static void onStompError(StompFrame frame) {
    debugPrint('*** Web socket stomp error ***');
    debugPrint('Catch Stomp error: ${frame.body}');
    debugPrint('\n*** Web socket stomp error ***');
  }

  static void onWebSocketDone() {
    debugPrint('*** Web socket done ***');
    debugPrint('Closed connection to Web socket!');
    debugPrint('\n*** Web socket done ***');
  }

  static void onWebSocketDisconnect(StompFrame frame) {
    debugPrint('*** Web socket disconnect ***');
    debugPrint('Closed connection to Web socket!');
    debugPrint('\n*** Web socket disconnect ***');
  }

  static void onWebSocketError(dynamic error) {
    debugPrint('*** Web socket error ***');
    debugPrint('Can not to Web Socket, catch: $error');
    debugPrint('\n*** Web socket error ***');
  }
}
