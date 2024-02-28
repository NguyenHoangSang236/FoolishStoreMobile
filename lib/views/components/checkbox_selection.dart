import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';

class CheckBoxSelection extends StatefulWidget {
  const CheckBoxSelection({
    super.key,
    required this.checkValue,
    required this.onChanged,
    required this.content,
  });

  final bool checkValue;
  final void Function(bool? value) onChanged;
  final String content;

  @override
  State<StatefulWidget> createState() => _CheckBoxSelectionState();
}

class _CheckBoxSelectionState extends State<CheckBoxSelection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.height,
      child: Row(
        children: [
          Checkbox(
            activeColor: Colors.orange,
            checkColor: Colors.white,
            value: widget.checkValue,
            shape: const CircleBorder(),
            onChanged: widget.onChanged,
          ),
          Expanded(
            child: Text(
              widget.content,
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'Sen',
                fontWeight: FontWeight.w400,
                fontSize: 15.size,
                color: const Color(0xFF464646),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
