import 'package:fashionstore/views/components/product_details_bottom_navigation_bar.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';

import '../components/app_bar.dart';
import '../components/bottom_navigation_bar.dart';

class Layout extends StatefulWidget {
  const Layout({
    Key? key,
    this.useSafeArea = true,
    this.isChat = false,
    this.title = '',
    this.forceCanNotBack = false,
    this.onBack,
    required this.body,
    this.bottomNavigateBarItemData,
    this.textEditingController,
    this.hintSearchBarText,
    this.onSearch,
    this.scaffoldKey,
    this.pageName = '',
    this.needAppBar = true,
    this.needSearchBar = true,
    this.needProductDetailsBottomNavBar = false,
    this.isSearchable = false,
    this.needBottomNavBar = true,
    this.translatorEditingController,
  }) : super(key: key);

  final bool useSafeArea;
  final bool needAppBar;
  final bool needProductDetailsBottomNavBar;
  final bool isChat;
  final bool isSearchable;
  final bool needBottomNavBar;
  final bool needSearchBar;
  final String title;
  final String pageName;
  final String? hintSearchBarText;
  final bool forceCanNotBack;
  final void Function()? onBack;
  final void Function(String text)? onSearch;
  final Widget body;
  final TextEditingController? textEditingController;
  final TextEditingController? translatorEditingController;
  final Map<String, dynamic>? bottomNavigateBarItemData;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: widget.needAppBar == true
          ? PreferredSize(
              preferredSize: Size.fromHeight(110.height),
              child: AppBarComponent(
                title: widget.title,
                needSearchBar: widget.needSearchBar,
                isSearchable: widget.isSearchable,
                pageName: widget.pageName,
                isChat: widget.isChat,
                forceCanNotBack: widget.forceCanNotBack,
                onBack: widget.onBack,
                textEditingController: widget.textEditingController,
                translatorEditingController: widget.translatorEditingController,
                onSearch: widget.onSearch,
                hintSearchBarText: widget.hintSearchBarText,
              ),
            )
          : null,
      backgroundColor: const Color(0xfff3f3f3),
      body: widget.body,
      bottomNavigationBar: widget.needBottomNavBar == true
          ? widget.needProductDetailsBottomNavBar == false
              ? const BottomNavigationBarComponent()
              : ProductDetailsBottomNavigationBarComponent(
                  textEditingController: widget.textEditingController,
                )
          : null,
    );
  }
}
