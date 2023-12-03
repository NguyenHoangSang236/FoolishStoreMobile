import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../data/enum/navigation_name_enum.dart';
import '../../data/enum/payment_enum.dart';
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
  final List<Widget> _paymentImageIconList = [
    Image.asset('assets/icon/master_card_icon.png'),
    Image.asset('assets/icon/momo_icon.png'),
    Image.asset('assets/icon/paypal_icon.png'),
    Image.asset('assets/icon/cod_icon.png'),
  ];
  final List<PaymentMethodEnum> _paymentMethodList = [
    PaymentMethodEnum.BANK_TRANSFER,
    PaymentMethodEnum.MOMO,
    PaymentMethodEnum.PAYPAL,
    PaymentMethodEnum.COD,
  ];

  late Widget _selectedPaymentMethodIcon;
  late PaymentMethodEnum _selectedPaymentMethod;

  void resetCheckoutInfo() {
    setState(() {
      _selectedPaymentMethodIcon = _paymentImageIconList.first;
      _selectedPaymentMethod = _paymentMethodList.first;
    });
  }

  void onPressCheckoutButton() {
    context.read<CartBloc>().add(
          OnCheckoutEvent(),
        );

    context.router.pop().then(
          (value) => showModalBottomSheet(
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
              return _checkoutBottomSheet();
            },
          ),
        );
  }

  void onPressCartItem(CartItem cartItem) {
    setState(
      () {
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
      },
    );
  }

  void onPressFilterButton() {
    SideSheet.left(
      context: context,
      width: MediaQuery.of(context).size.width * 3 / 5,
      body: const CartFilterComponent(),
    );
  }

  void onPressCheckoutCancelButton() {
    resetCheckoutInfo();
    context.router.pop();
  }

  void onPressPlaceOrderButton() {
    context.read<InvoiceBloc>().add(
          OnAddNewOrderEvent(
            _selectedPaymentMethod.name,
          ),
        );
  }

  void onSelectPaymentMethod() {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Choose delivery payment method',
          ),
          content: _checkoutPopupContent(),
        );
      },
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

  void onPressPaymentMethodRadioButton(
    PaymentMethodEnum? paymentEnum,
    Widget paymentIcon,
  ) {
    context.router.pop();

    context.read<CartBloc>().add(const OnCheckoutEvent());

    setState(() {
      _selectedPaymentMethod = paymentEnum!;
      _selectedPaymentMethodIcon = paymentIcon;
    });
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
    _selectedPaymentMethodIcon = _paymentImageIconList.first;
    // _selectedDeliveryType = _deliveryTypeList.first;
    _selectedPaymentMethod = _paymentMethodList.first;

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
      forceCanNotBack: false,
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
                }
              },
            ),
            BlocListener<InvoiceBloc, InvoiceState>(
              listener: (context, invoiceState) {
                if (invoiceState is InvoiceErrorState) {
                  UiRender.showDialog(context, '', invoiceState.message);
                } else if (invoiceState is InvoiceAddedState) {
                  UiRender.showDialog(context, '', invoiceState.message).then(
                    (value) => {
                      context.read<InvoiceBloc>().add(
                            OnLoadOnlinePaymentInfoEvent(
                              context.read<InvoiceBloc>().currentAddedInvoiceId,
                              _selectedPaymentMethod.name,
                            ),
                          ),
                      context.router.pop(),
                    },
                  );
                } else if (invoiceState
                    is InvoiceOnlinePaymentInfoLoadedState) {
                  context.router.pushNamed(
                    AppRouterPath.onlinePaymentReceiverInfo,
                  );

                  LoadingService(context).reloadCartPage();
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

  Widget _checkoutBottomSheet() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.width,
          vertical: 30.height,
        ),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartErrorState) {
              UiRender.showDialog(context, '', state.message);
            }
          },
          builder: (context, state) {
            if (state is CartCheckoutState) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.height),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Checkout',
                          style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 18.size,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: onPressCheckoutCancelButton,
                          child: Image.asset(
                            'assets/icon/x_icon.png',
                            width: 32.size,
                            height: 32.size,
                            color: const Color(0xFFA1A1A1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _checkoutBottomSheetContent(
                    title: 'Payment Method',
                    onPress: onSelectPaymentMethod,
                    isPayment: true,
                  ),
                  _checkoutBottomSheetContent(
                    title: 'Subtotal',
                    content: state.cartCheckout.subtotal.format,
                  ),
                  _checkoutBottomSheetContent(
                    title: 'Delivery Fee',
                    content: state.cartCheckout.shippingFee.format,
                  ),
                  _checkoutBottomSheetContent(
                    title: 'Total',
                    content: state.cartCheckout.total.format,
                  ),
                  20.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'By placing an order you agree to our',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 10.size,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFA1A1A1),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Terms and Conditions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 10.size,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA1A1A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  GradientElevatedButton(
                    text: 'Place Order',
                    textSize: 15.size,
                    textWeight: FontWeight.w700,
                    buttonMargin: EdgeInsets.zero,
                    buttonWidth: MediaQuery.of(context).size.width,
                    buttonHeight: 50.height,
                    onPress: onPressPlaceOrderButton,
                  ),
                ],
              );
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _checkoutBottomSheetContent({
    required String title,
    String? content,
    bool isPayment = false,
    void Function()? onPress,
  }) {
    return Material(
      child: InkWell(
        splashColor: Colors.orange,
        onTap: onPress,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.height),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 14.size,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPress == null
                  ? Text(
                      content!.dollar,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 14.size,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isPayment
                            ? SizedBox(
                                height: 23.height,
                                width: 35.width,
                                child: _selectedPaymentMethodIcon,
                              )
                            : Text(
                                content!,
                                style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 14.size,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange,
                                ),
                              ),
                        15.horizontalSpace,
                        SizedBox(
                          height: 21.height,
                          width: 15.width,
                          child: Image.asset(
                            'assets/icon/right_dash_arrow_icon.png',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethodOption(
    PaymentMethodEnum paymentEnum,
    Widget paymentMethodIcon,
  ) {
    return RadioListTile(
      title: Row(
        children: [
          SizedBox(
            height: 33.height,
            width: 50.width,
            child: paymentMethodIcon,
          ),
          7.horizontalSpace,
          Expanded(
            child: Text(
              paymentEnum.name.formatEnumToUppercaseFirstLetter,
              maxLines: 2,
            ),
          ),
        ],
      ),
      value: paymentEnum,
      groupValue: _selectedPaymentMethod,
      activeColor: Colors.orange,
      onChanged: (value) => onPressPaymentMethodRadioButton(
        value,
        paymentMethodIcon,
      ),
    );
  }

  Widget _checkoutPopupContent() {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: List<Widget>.generate(
          _paymentMethodList.length,
          (index) => _paymentMethodOption(
            _paymentMethodList[index],
            _paymentImageIconList[index],
          ),
        ),
      ),
    );
  }
}
