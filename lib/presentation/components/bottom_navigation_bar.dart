import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/categories/category_bloc.dart';
import '../../data/static/global_variables.dart';
import '../../utils/render/ui_render.dart';

class BottomNavigationBarComponent extends StatefulWidget {
  const BottomNavigationBarComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarComponentState();
}

class _BottomNavigationBarComponentState
    extends State<BottomNavigationBarComponent> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int _selectedNavIndex = 0;
  final List<String> _navNameList = [
    NavigationNameEnum.HOME.name,
    NavigationNameEnum.NOTIFICATION.name,
    NavigationNameEnum.CLOTHINGS.name,
    NavigationNameEnum.CATEGORIES.name,
  ];
  late List<Widget> _navList;

  @override
  void initState() {
    _navList = [
      _navBarButton(
        'assets/icon/home_icon.png',
        'Home',
        onTap: () {
          if (context.router.current.name != AppRouterPath.index) {
            context.router.replaceNamed(AppRouterPath.index);

            GlobalVariable.currentNavBarPage = NavigationNameEnum.HOME.name;
          }
        },
      ),
      _navBarButton(
        'assets/icon/notification_icon.png',
        'Notification',
        onTap: () {
          if (context.router.current.name != AppRouterPath.notification) {
            context.router.replaceNamed(AppRouterPath.notification);

            GlobalVariable.currentNavBarPage =
                NavigationNameEnum.NOTIFICATION.name;
          }
        },
      ),
      _navBarButton(
        'assets/icon/clothing_icon.png',
        'Clothings',
        onTap: () {
          if (context.router.current.name != AppRouterPath.allProducts) {
            context.router.replaceNamed(AppRouterPath.allProducts);

            GlobalVariable.currentNavBarPage =
                NavigationNameEnum.CLOTHINGS.name;
            BlocProvider.of<CategoryBloc>(context).add(
              const OnSelectedCategoryEvent('All'),
            );
          }
        },
      ),
      _navBarButton(
        'assets/icon/category_icon.png',
        'Categories',
        onTap: () {
          if (context.router.current.name != AppRouterPath.allCategories) {
            context.router.replaceNamed(AppRouterPath.allCategories);

            GlobalVariable.currentNavBarPage =
                NavigationNameEnum.CATEGORIES.name;
          }
        },
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GlobalVariable.currentNavBarPage != NavigationNameEnum.CART.name) {
        _selectedNavIndex =
            _navNameList.indexOf(GlobalVariable.currentNavBarPage);

        Future.delayed(const Duration(milliseconds: 500), () {
          _itemScrollController.scrollTo(
            index: _selectedNavIndex,
            duration: const Duration(milliseconds: 1000),
          );
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70.height,
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 18.width, right: 18.width),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.radius),
              topRight: Radius.circular(24.radius),
            ),
            color: Colors.white,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 140.width,
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _navNameList.length,
              itemBuilder: (context, index) {
                return _navList[index];
              },
            ),
          ),
        ),
        Positioned(
          top: -15.height,
          right: 0,
          child: _cartButton(
            onTap: () {
              if (context.router.current.name != AppRouterPath.cart) {
                context.router.replaceNamed(AppRouterPath.cart);

                GlobalVariable.currentNavBarPage = NavigationNameEnum.CART.name;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _navBarButton(
    String iconUrl,
    String name, {
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 25.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconUrl,
              height: 20.height,
              width: 20.width,
              fit: BoxFit.fill,
              color: GlobalVariable.currentNavBarPage != name.toUpperCase()
                  ? const Color(0xffa4a4a4)
                  : Colors.orange,
            ),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12.size,
                color: GlobalVariable.currentNavBarPage != name.toUpperCase()
                    ? const Color(0xffa4a4a4)
                    : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartButton({required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 54,
        width: 120,
        decoration: BoxDecoration(
          color: context.router.current.path == AppRouterPath.cart
              ? Colors.orange
              : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.radius),
            bottomLeft: Radius.circular(40.radius),
          ),
          gradient: context.router.current.path == AppRouterPath.cart
              ? null
              : UiRender.generalLinearGradient(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/cart_icon.png',
              width: 30.width,
              height: 30.height,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
            4.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'My Cart',
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 12.size,
                    color: Colors.white,
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    int totalItems = BlocProvider.of<CartBloc>(context)
                        .totalCartItemQuantity;
                    if (cartState is TotalCartItemQuantityLoadedState) {
                      totalItems = cartState.totalQuantity;
                    }

                    return Text(
                      '$totalItems items',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.size,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
