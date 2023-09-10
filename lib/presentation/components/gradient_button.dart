import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';

class GradientElevatedButton extends StatefulWidget {
  const GradientElevatedButton({
    Key? key,
    required this.text,
    this.borderColor = Colors.transparent,
    this.borderRadiusIndex = 20,
    this.beginColor = Colors.black,
    this.endColor = const Color(0xff727272),
    this.textColor = Colors.white,
    this.buttonHeight = 30,
    this.buttonWidth = 178,
    this.textWeight = FontWeight.w700,
    this.textSize = 13,
    this.buttonElevation = 0,
    this.borderWidth = 1,
    this.buttonMargin = const EdgeInsets.only(top: 35),
    this.isLoading = false,
    required this.onPress,
    this.textFontStyle = FontStyle.normal,
    this.begin = Alignment.centerRight,
    this.end = Alignment.centerLeft,
    this.border,
  }) : super(key: key);

  final Color textColor;
  final FontWeight textWeight;
  final double textSize;
  final Color beginColor;
  final Color endColor;
  final Color borderColor;
  final String text;
  final double borderRadiusIndex;
  final double buttonHeight;
  final double buttonWidth;
  final double buttonElevation;
  final double borderWidth;
  final EdgeInsets buttonMargin;
  final bool isLoading;
  final FontStyle textFontStyle;
  final Alignment begin;
  final Alignment end;
  final void Function() onPress;
  final BoxBorder? border;

  @override
  State<StatefulWidget> createState() => _GradientElevatedButtonState();
}

class _GradientElevatedButtonState extends State<GradientElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.buttonMargin,
      width: widget.buttonWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadiusIndex),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          )),
      child: SizedBox(
        height: widget.buttonHeight,
        child: ElevatedButton(
          onPressed: widget.onPress,
          style: ElevatedButton.styleFrom(
            elevation: widget.buttonElevation,
            splashFactory: InkRipple.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadiusIndex),
            ),
            padding: EdgeInsets.zero,
          ),
          child: InkWell(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.orange),
            child: Container(
              height: widget.buttonHeight,
              decoration: BoxDecoration(
                border: widget.border,
                borderRadius: BorderRadius.circular(widget.borderRadiusIndex),
                gradient: LinearGradient(
                  begin: widget.begin,
                  end: widget.end,
                  colors: [
                    widget.beginColor,
                    widget.endColor,
                  ],
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                height: widget.buttonHeight,
                child: widget.isLoading
                    ? SizedBox(
                        height: 20.height,
                        width: 20.width,
                        child: CircularProgressIndicator(
                          color: widget.textColor,
                        ),
                      )
                    : Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Be Vietnam Pro',
                            color: widget.textColor,
                            fontSize: widget.textSize,
                            fontWeight: widget.textWeight,
                            fontStyle: widget.textFontStyle),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
