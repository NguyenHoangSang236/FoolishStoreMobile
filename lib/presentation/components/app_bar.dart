import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/data/static/global_variables.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

class AppBarComponent extends StatefulWidget {
  const AppBarComponent({
    Key? key,
    this.isChat = false,
    this.needSearchBar = true,
    this.title = '',
    this.forceCanNotBack = false,
    this.onBack,
    this.textEditingController,
    this.hintSearchBarText,
    this.onSearch,
    this.pageName = '',
    this.isSearchable = false,
    this.translatorEditingController,
  }) : super(key: key);

  final bool isChat;
  final bool needSearchBar;
  final String pageName;
  final String title;
  final bool forceCanNotBack;
  final bool isSearchable;
  final TextEditingController? textEditingController;
  final TextEditingController? translatorEditingController;
  final void Function()? onBack;
  final void Function(String text)? onSearch;
  final String? hintSearchBarText;

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  final List<Widget> _dropdownMenuList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dropdownMenuList.add(_dropdownItem('My Account', () {}));
      _dropdownMenuList.add(_dropdownItem('My profile', () {
        GlobalVariable.currentNavBarPage = NavigationNameEnum.PROFILE.name;

        context.router.replaceNamed(AppRouterPath.profile);
      }));
      _dropdownMenuList.add(_dropdownItem('Purchase history', () {}));
      _dropdownMenuList.add(_dropdownItem('Log out', () {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(OnLogoutAuthenticationEvent());

        context.router.replaceNamed(AppRouterPath.login);
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _appbarContent();
  }

  Widget _appbarContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          child: AppBar(
            toolbarHeight: 90,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: UiRender.generalLinearGradient(),
              ),
            ),
            elevation: 0,
            bottomOpacity: 0,
            titleSpacing: 0,
            leadingWidth: 48,
            automaticallyImplyLeading: false,
            leading: AutoRouter.of(context).canPop() &&
                    widget.forceCanNotBack == false
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        context.router.pop();
                      }
                    },
                  )
                : IconButton(
                    onPressed: () {
                      SideSheet.left(
                          context: context,
                          body: SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return null;
                                }),
                          ));
                    },
                    icon: const ImageIcon(
                      AssetImage('assets/icon/option_icon.png'),
                      size: 27,
                    )),
            actions: [
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return Dialog(
                            alignment: Alignment.topRight,
                            insetPadding: EdgeInsets.only(
                                top: 67,
                                left: MediaQuery.of(context).size.width / 3),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _dropdownMenuList.length,
                                itemBuilder: (context, index) {
                                  return _dropdownMenuList[index];
                                }),
                          );
                        });
                  },
                  child: UiRender.buildCachedNetworkImage(
                      context,
                      ValueRender.getGoogleDriveImageUrl(
                          BlocProvider.of<AuthenticationBloc>(context)
                                  .currentUser
                                  ?.avatar ??
                              ''),
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(100),
                      margin: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10))),
            ],
            title: _buildTitle(),
            centerTitle: true,
          ),
        ),
        Positioned(
            bottom: -25,
            right: 20,
            left: 20,
            child: widget.needSearchBar == true
                ? widget.isSearchable == false
                    ? GestureDetector(
                        onTap: () {
                          context.router.pushNamed(AppRouterPath.searching);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(right: 30, left: 20),
                            height: 44,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 1),
                                      blurRadius: 4.0,
                                      spreadRadius: 1.0,
                                      blurStyle: BlurStyle.outer),
                                ],
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.hintSearchBarText ?? '',
                                  style: const TextStyle(
                                      fontFamily: 'Sen',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xffacacac)),
                                ),
                                const ImageIcon(
                                  AssetImage('assets/icon/translator_icon.png'),
                                  color: Colors.grey,
                                ),
                              ],
                            )),
                      )
                    : Container(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        height: 44,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  blurStyle: BlurStyle.outer),
                            ],
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.white),
                        child: TextField(
                          controller: widget.textEditingController,
                          onChanged: widget.onSearch,
                          onSubmitted: widget.onSearch,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                tooltip: "Translator",
                                onPressed: () {
                                  BlocProvider.of<TranslatorBloc>(context)
                                      .add(OnLoadLanguageListTranslatorEvent());

                                  UiRender.showSingleTextFieldDialog(context,
                                          widget.translatorEditingController,
                                          title: 'Translator',
                                          hintText: "Search...",
                                          isTranslator: true)
                                      .then((value) {
                                    if (value == true) {
                                      if (widget.translatorEditingController
                                                  ?.text !=
                                              null &&
                                          BlocProvider.of<TranslatorBloc>(
                                                      context)
                                                  .selectedLanguage
                                                  ?.languageCode !=
                                              null) {
                                        BlocProvider.of<TranslatorBloc>(context)
                                            .add(OnTranslateEvent(
                                                widget.translatorEditingController
                                                        ?.text ??
                                                    '',
                                                BlocProvider.of<TranslatorBloc>(
                                                            context)
                                                        .selectedLanguage
                                                        ?.languageCode ??
                                                    ''));
                                      }
                                      widget.translatorEditingController
                                          ?.clear();
                                    }
                                  });
                                },
                                icon: const ImageIcon(
                                  AssetImage('assets/icon/translator_icon.png'),
                                  color: Colors.grey,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: widget.hintSearchBarText,
                              hintStyle: const TextStyle(
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xffacacac))),
                        ),
                      )
                : Container()),
      ]),
    );
  }

  Widget _buildTitle() {
    return widget.pageName == ''
        ? RichText(
            text: const TextSpan(children: [
            TextSpan(
                text: 'Foolish ',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFF7A00),
                  fontSize: 20,
                )),
            TextSpan(
                text: 'Store',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFFffff),
                  fontSize: 20,
                )),
          ]))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: 'Foolish ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Color(0xffFF7A00),
                      fontSize: 12,
                    )),
                TextSpan(
                    text: 'Store',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 12,
                    )),
              ])),
              Text(
                widget.pageName,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18,
                ),
              )
            ],
          );
  }

  Widget _dropdownItem(String name, void Function() action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(
          name,
          maxLines: 2,
          style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff464646)),
        ),
      ),
    );
  }
}
