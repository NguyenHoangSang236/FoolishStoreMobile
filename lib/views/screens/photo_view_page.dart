import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({super.key, required this.url});

  final String url;

  @override
  State<StatefulWidget> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  void _comeBack() {
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(
          imageProvider: NetworkImage(widget.url),
        ),
        Positioned(
          top: 10.height,
          right: 10.width,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: _comeBack,
          ),
        ),
      ],
    );
  }
}
