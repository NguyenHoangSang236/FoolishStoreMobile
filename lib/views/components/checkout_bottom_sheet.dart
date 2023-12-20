import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../config/app_router/app_router_path.dart';
import '../../data/entity/address_code.dart';
import '../../data/enum/payment_enum.dart';
import '../../service/loading_service.dart';
import '../../utils/render/ui_render.dart';
import 'gradient_button.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() => _CheckoutBottomSheet();
}

class _CheckoutBottomSheet extends State<CheckoutBottomSheet> {
  late Widget _selectedPaymentMethodIcon;
  late PaymentMethodEnum _selectedPaymentMethod;

  final List<PaymentMethodEnum> _paymentMethodList = [
    PaymentMethodEnum.BANK_TRANSFER,
    PaymentMethodEnum.MOMO,
    PaymentMethodEnum.PAYPAL,
    PaymentMethodEnum.COD,
  ];

  final List<Widget> _paymentImageIconList = [
    Image.asset('assets/icon/master_card_icon.png'),
    Image.asset('assets/icon/momo_icon.png'),
    Image.asset('assets/icon/paypal_icon.png'),
    Image.asset('assets/icon/cod_icon.png'),
  ];

  void resetCheckoutInfo() {
    setState(() {
      _selectedPaymentMethodIcon = _paymentImageIconList.first;
      _selectedPaymentMethod = _paymentMethodList.first;
    });
  }

  void onPressCheckoutCancelButton() {
    resetCheckoutInfo();
    context.router.pop();
  }

  void onPressPlaceOrderButton() {
    AddressCode? currentAddressCode =
        context.read<CartBloc>().currentAddressCode;

    if (currentAddressCode == null) {
      UiRender.showDialog(
        context,
        '',
        'Please choose your location before placing an order!',
      );
    } else {
      context.read<InvoiceBloc>().add(
            OnAddNewOrderEvent(
              _selectedPaymentMethod.name,
              currentAddressCode!,
              context.read<CartBloc>().currentServiceId,
            ),
          );
    }
  }

  void onPressPaymentMethodRadioButton(
    PaymentMethodEnum? paymentEnum,
    Widget paymentIcon,
  ) {
    setState(() {
      _selectedPaymentMethod = paymentEnum!;
      _selectedPaymentMethodIcon = paymentIcon;

      context.router.pop();
    });
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
          content: _paymentMethodPopup(),
        );
      },
    );
  }

  @override
  void initState() {
    _selectedPaymentMethodIcon = _paymentImageIconList.first;
    _selectedPaymentMethod = _paymentMethodList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoiceBloc, InvoiceState>(
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
        } else if (invoiceState is InvoiceOnlinePaymentInfoLoadedState) {
          context.router.pushNamed(
            AppRouterPath.onlinePaymentReceiverInfo,
          );

          LoadingService(context).reloadCartPage();
        }
      },
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _paymentMethodPopup() {
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
}
