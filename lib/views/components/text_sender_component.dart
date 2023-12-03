import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';

class TextSenderComponent extends StatelessWidget {
  const TextSenderComponent({
    super.key,
    required this.controller,
    required this.sendAction,
  });

  final TextEditingController controller;
  final void Function() sendAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: TextField(
            controller: controller,
            minLines: null,
            maxLines: null,
            // expands: true,
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 12.size,
              color: const Color(0xFF979797),
            ),
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
            onPressed: sendAction,
          ),
        )
      ],
    );
  }
}
