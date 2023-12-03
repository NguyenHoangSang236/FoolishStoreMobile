import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';

class SideSheetContent extends StatefulWidget {
  const SideSheetContent({super.key});

  @override
  State<StatefulWidget> createState() => _SideSheetContentState();
}

class _SideSheetContentState extends State<SideSheetContent> {
  final List<String> _sideSheetOptionList = [
    'Purchase history',
    'Notification sound',
    'About us',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 30.height),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sideSheetOption(
              title: 'Notification sound',
              onPress: () {},
            ),
            _sideSheetOption(
              title: 'Purchase history',
              onPress: () =>
                  context.router.pushNamed(AppRouterPath.purchaseHistory),
            ),
            _sideSheetOption(
              title: 'About us',
              onPress: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _sideSheetOption({
    required String title,
    required void Function() onPress,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        splashColor: Colors.orange,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.height),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            vertical: 7.height,
            horizontal: 13.width,
          ),
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
