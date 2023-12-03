import 'package:flutter/material.dart';

class IconButtonComponent extends StatefulWidget {
  const IconButtonComponent({
    Key? key,
    this.materialType = MaterialType.transparency,
    required this.iconPath,
    this.padding = const EdgeInsets.all(8),
    this.border,
    this.borderRadius,
    this.backgroundColor,
    this.splashColor,
    this.iconSize = 15,
    required this.onTap,
  }) : super(key: key);

  final MaterialType materialType;
  final String iconPath;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? splashColor;
  final double iconSize;
  final void Function() onTap;


  @override
  State<StatefulWidget> createState() => _IconButtonComponentState();
}

class _IconButtonComponentState extends State<IconButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: widget.materialType,
      child: Ink(
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.borderRadius,
          color: widget.backgroundColor
        ),
        child: InkWell(
          borderRadius: widget.borderRadius,
          splashColor: widget.splashColor,
          onTap: widget.onTap,
          child: Padding(
            padding: widget.padding,
            child: ImageIcon(
              AssetImage(widget.iconPath),
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }

}