import 'dart:convert';

import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/data/dto/websocket_message.dart';
import 'package:fashionstore/data/enum/websocket_enum.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';

class TextSenderComponent extends StatefulWidget {
  const TextSenderComponent({
    super.key,
    required this.controller,
    required this.sendAction,
    required this.productId,
    required this.productColor,
  });

  final TextEditingController controller;
  final void Function() sendAction;
  final int productId;
  final String productColor;

  @override
  State<StatefulWidget> createState() => _TextSenderComponentState();
}

class _TextSenderComponentState extends State<TextSenderComponent> {
  void _onCommentInput(String text) {
    stompClient.send(
      destination:
          '$websocketDestinationPrefix/typingComment/${widget.productId}/${widget.productColor}',
      body: jsonEncode(
        WebsocketMessage(
          type: WebsocketEnum.TYPING_COMMENT,
          sender: context.read<AuthenticationBloc>().currentUser?.userName,
        ).toJson(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: TextField(
            controller: widget.controller,
            minLines: null,
            maxLines: null,
            // expands: true,
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 12.size,
              color: const Color(0xFF979797),
            ),
            onChanged: _onCommentInput,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.radius),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              hintText: 'Type your comment here...',
              hintStyle: TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                fontSize: 12.size,
                color: const Color(0xFF979797),
              ),
              filled: true,
              fillColor: const Color(0xfff3f3f3),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Image.asset(
              'assets/icon/send_icon.png',
              height: 20.size,
              width: 20.size,
              filterQuality: FilterQuality.medium,
            ),
            onPressed: widget.sendAction,
          ),
        )
      ],
    );
  }
}
