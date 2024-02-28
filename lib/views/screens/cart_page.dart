import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/productDetails/product_details_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/entity/cart_item.dart';
import 'package:fashionstore/service/loading_service.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/views/components/cart_filter_component.dart';
import 'package:fashionstore/views/components/cart_item_component.dart';
import 'package:fashionstore/views/components/cart_item_details.dart';
import 'package:fashionstore/views/components/checkout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../data/entity/address_code.dart';
import '../../data/enum/navigation_name_enum.dart';
import '../../data/static/global_variables.dart';
import '../../utils/render/value_render.dart';
import '../components/gradient_button.dart';
import '../layout/layout.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<StatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late AnimationController _bottomSheetAnimation;
  double currentOffset = 0;

  late AddressCode _currentSelectedAddressCode;

  void onPressCheckoutButton() {
    context.router.pushNamed(AppRouterPath.map);
  }

  void onPressCartItem(CartItem cartItem) {
    setState(() {
      context.read<ProductDetailsBloc>().add(
            OnSelectProductEvent(cartItem.productId),
          );

      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.radius),
            topLeft: Radius.circular(15.radius),
          ),
        ),
        transitionAnimationController: _bottomSheetAnimation,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CartItemDetails(
            selectedCartItem: cartItem,
          );
        },
      );
    });
  }

  void onPressFilterButton() {
    SideSheet.left(
      context: context,
      width: MediaQuery.of(context).size.width * 3 / 5,
      body: const CartFilterComponent(),
    );
  }

  void paginationScrollEvent() {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !_scrollController.position.outOfRange &&
        context.read<CartBloc>().cartItemList.length <
            context.read<CartBloc>().totalCartItemQuantity) {
      setState(() {
        currentOffset = _scrollController.offset;
      });

      List<String> filterOptions = context.read<CartBloc>().currentFilterOption;
      String filterBrand = context.read<CartBloc>().currentBrandFilter;
      String filterName = context.read<CartBloc>().currentNameFilter;
      int currentPage = context.read<CartBloc>().currentPage;

      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          context.read<CartBloc>().add(
                filterOptions.isEmpty &&
                        filterBrand.isEmpty &&
                        filterName.isEmpty
                    ? OnLoadAllCartListEvent(currentPage + 1, 10)
                    : OnFilterCartEvent(
                        page: currentPage + 1,
                        limit: 10,
                        status: filterOptions,
                        brand: filterBrand,
                        name: filterName,
                      ),
              );
        },
      );
    }
  }

  @override
  void dispose() {
    _bottomSheetAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (context.read<CartBloc>().cartItemList.isEmpty) {
      LoadingService(context).reloadCartPage();
    }

    GlobalVariable.currentNavBarPage = NavigationNameEnum.CART.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAnimationController();
      _scrollController.addListener(paginationScrollEvent);
    });

    super.initState();
  }

  void initAnimationController() {
    _bottomSheetAnimation = BottomSheet.createAnimationController(this);
    _bottomSheetAnimation.duration = const Duration(milliseconds: 700);
    _bottomSheetAnimation.reverseDuration = const Duration(milliseconds: 700);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: true,
      textEditingController: _textEditingController,
      pageName: 'My Cart',
      hintSearchBarText: 'What item are you looking for?',
      onSearch: (text) {},
      body: RefreshIndicator(
        color: Colors.orange,
        key: _refreshIndicatorKey,
        onRefresh: () async {
          LoadingService(context).reloadCartPage();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<CartBloc, CartState>(
              listener: (context, cartState) {
                if (cartState is CartErrorState) {
                  UiRender.showDialog(context, '', cartState.message);
                } else if (cartState is AllCartListLoadedState ||
                    cartState is CartFilteredState) {
                  _scrollController.jumpTo(currentOffset);
                } else if (cartState is AddressCodeRequestLoadedState) {
                  context.read<CartBloc>().add(
                        OnLoadGhnAddressCodeEvent(cartState.addressCodeRequest),
                      );
                } else if (cartState is AddressCodeLoadedState) {
                  setState(() {
                    _currentSelectedAddressCode = cartState.addressCode;
                  });

                  context.read<CartBloc>().add(
                        OnLoadGhnAvailableShippingServicesEvent(
                          cartState.addressCode.fromDistrictId!,
                          cartState.addressCode.toDistrictId!,
                        ),
                      );
                } else if (cartState is GhnShippingServiceListLoadedState) {
                  context.read<CartBloc>().add(
                        OnCheckoutEvent(
                          _currentSelectedAddressCode,
                          cartState.serviceList.first.service_id,
                        ),
                      );
                } else if (cartState is CartCheckoutState) {
                  showModalBottomSheet(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      minHeight: MediaQuery.of(context).size.height / 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.radius),
                        topLeft: Radius.circular(15.radius),
                      ),
                    ),
                    transitionAnimationController: _bottomSheetAnimation,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return const CheckoutBottomSheet();
                    },
                  );
                }
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _totalCartPriceComponent(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _scrollController.hasClients
                      ? _scrollController.position.maxScrollExtent > 0
                          ? const BouncingScrollPhysics()
                          : const AlwaysScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.width),
                    child: Column(
                      children: [
                        _cartItemList(),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: GradientElevatedButton(
                  buttonMargin: EdgeInsets.symmetric(vertical: 5.height),
                  borderRadiusIndex: 20.radius,
                  borderColor: Colors.transparent,
                  text: 'Checkout',
                  textWeight: FontWeight.w600,
                  buttonWidth: 200.width,
                  buttonHeight: 45.height,
                  textColor: Colors.white,
                  textSize: 16.size,
                  onPress: onPressCheckoutButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalCartPriceComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPressFilterButton,
          icon: ImageIcon(
            const AssetImage(
              'assets/icon/filter_icon.png',
            ),
            color: const Color(0xff626262),
            size: 20.size,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            5.width,
            15.height,
            25.width,
            15.height,
          ),
          height: 50.height,
          child: Row(
            children: [
              Text(
                'Total cart price: ',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(0xff464646),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.size,
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  List<CartItem> cartItemList =
                      context.read<CartBloc>().cartItemList;

                  if (cartState is CartLoadingState) {
                    return SizedBox(
                      height: 10.height,
                      width: 10.width,
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                        strokeWidth: 2.width,
                      ),
                    );
                  } else if (cartState is AllCartListLoadedState) {
                    cartItemList = cartState.cartItemList;
                  }

                  return Text(
                    ValueRender.totalCartPrice(cartItemList).format.dollar,
                    style: TextStyle(
                      fontFamily: 'Sen',
                      fontWeight: FontWeight.w700,
                      fontSize: 16.size,
                      color: Colors.orange,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _cartItemList() {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, cartState) {
        if (cartState is CartRemovedState) {
          UiRender.showDialog(context, '', cartState.message);
          LoadingService(context).reloadCartPage();
        } else if (cartState is CartUpdatedState) {
          UiRender.showDialog(context, '', cartState.message);
          LoadingService(context).reloadCartPage();
        } else if (cartState is AllCartListLoadedState) {
          _scrollController.animateTo(
            _scrollController.offset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      },
      builder: (context, cartState) {
        List<CartItem> cartItemList = context.read<CartBloc>().cartItemList;

        if (cartState is CartLoadingState) {
          return UiRender.loadingCircle();
        } else if (cartState is AllCartListLoadedState) {
          cartItemList = List.from(cartState.cartItemList);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItemList.length,
          itemBuilder: (context, index) {
            return CartItemComponent(
              cartItem: cartItemList[index],
              onTap: () => onPressCartItem(cartItemList[index]),
            );
          },
        );
      },
    );
  }
}
