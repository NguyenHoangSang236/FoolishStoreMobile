import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/data/static/global_variables.dart';
import 'package:fashionstore/presentation/components/side_sheet.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
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
  final Function? onBack;
  final void Function(String text)? onSearch;
  final String? hintSearchBarText;

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  final List<Widget> _dropdownMenuList = [];

  void showSideSheet() {
    SideSheet.left(
      width: MediaQuery.of(context).size.width * 2 / 3,
      context: context,
      body: const SideSheetContent(),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dropdownMenuList.add(_dropdownItem('My Account', () {}));
      _dropdownMenuList.add(_dropdownItem('My profile', () {
        GlobalVariable.currentNavBarPage = NavigationNameEnum.PROFILE.name;
        context.router.pushNamed(AppRouterPath.profile);
      }));
      _dropdownMenuList.add(_dropdownItem('Log out', () {
        BlocProvider.of<AuthenticationBloc>(context).add(
          OnLogoutAuthenticationEvent(),
        );
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: AppBar(
              toolbarHeight: 90.height,
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
                        widget.onBack?.call();
                        context.router.pop();
                      },
                    )
                  : IconButton(
                      onPressed: showSideSheet,
                      icon: ImageIcon(
                        const AssetImage('assets/icon/option_icon.png'),
                        size: 27.size,
                      ),
                    ),
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
                                top: 67.height,
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
                          '',
                    ),
                    width: 40.height,
                    height: 40.height,
                    borderRadius: BorderRadius.circular(100),
                    margin: EdgeInsets.symmetric(
                      vertical: 25.height,
                      horizontal: 10.width,
                    ),
                  ),
                ),
              ],
              title: _buildTitle(),
              centerTitle: true,
            ),
          ),
          Positioned(
              bottom: -25.height,
              right: 20.width,
              left: 20.width,
              child: widget.needSearchBar == true
                  ? widget.isSearchable == false
                      ? GestureDetector(
                          onTap: () {
                            context.router.pushNamed(AppRouterPath.searching);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 30.width,
                              left: 20.width,
                            ),
                            height: 44.height,
                            width: MediaQuery.of(context).size.width - 40.width,
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
                                  style: TextStyle(
                                    fontFamily: 'Sen',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.size,
                                    color: const Color(0xffacacac),
                                  ),
                                ),
                                const ImageIcon(
                                  AssetImage('assets/icon/translator_icon.png'),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(
                            right: 20.width,
                            left: 20.width,
                          ),
                          height: 44.height,
                          width: MediaQuery.of(context).size.width - 40.width,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 1),
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(40.radius),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: widget.textEditingController,
                            onChanged: widget.onSearch,
                            onSubmitted: widget.onSearch,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                tooltip: "Translator",
                                onPressed: () {
                                  BlocProvider.of<TranslatorBloc>(context).add(
                                    OnLoadLanguageListTranslatorEvent(),
                                  );

                                  UiRender.showSingleTextFieldDialog(
                                    context,
                                    widget.translatorEditingController,
                                    title: 'Translator',
                                    hintText: "Search...",
                                    isTranslator: true,
                                  ).then((value) {
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
                                            .add(
                                          OnTranslateEvent(
                                            widget.translatorEditingController
                                                    ?.text ??
                                                '',
                                            BlocProvider.of<TranslatorBloc>(
                                                        context)
                                                    .selectedLanguage
                                                    ?.languageCode ??
                                                '',
                                          ),
                                        );
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
                              hintStyle: TextStyle(
                                fontFamily: 'Sen',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.size,
                                color: const Color(0xffacacac),
                              ),
                            ),
                          ),
                        )
                  : Container()),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return widget.pageName == ''
        ? RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Foolish ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffFF7A00),
                    fontSize: 20.size,
                  ),
                ),
                TextSpan(
                  text: 'Store',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffFFffff),
                    fontSize: 20.size,
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Foolish ',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF7A00),
                        fontSize: 12.size,
                      ),
                    ),
                    TextSpan(
                      text: 'Store',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 12.size,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.pageName,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18.size,
                ),
              )
            ],
          );
  }

  Widget _dropdownItem(String name, void Function() action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: 100.width,
        padding: EdgeInsets.symmetric(
          vertical: 20.height,
          horizontal: 20.width,
        ),
        child: Text(
          name,
          maxLines: 2,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontSize: 14.size,
            fontWeight: FontWeight.w400,
            color: const Color(0xff464646),
          ),
        ),
      ),
    );
  }
}
