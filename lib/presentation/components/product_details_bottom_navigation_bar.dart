import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/productDetails/product_details_bloc.dart';
import 'package:fashionstore/presentation/components/gradient_button.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/render/ui_render.dart';
import '../../utils/render/value_render.dart';

class ProductDetailsBottomNavigationBarComponent extends StatefulWidget {
  const ProductDetailsBottomNavigationBarComponent({
    Key? key,
    this.textEditingController,
  }) : super(key: key);

  final TextEditingController? textEditingController;

  @override
  State<StatefulWidget> createState() =>
      _ProductDetailsBottomNavigationBarComponentState();
}

class _ProductDetailsBottomNavigationBarComponentState
    extends State<ProductDetailsBottomNavigationBarComponent> {
  void onPressAddToCartButton() {
    String color = context.read<ProductAddToCartBloc>().color;
    String productName = context.read<ProductAddToCartBloc>().productName;
    int productId = context
        .read<ProductDetailsBloc>()
        .selectedProductDetails
        .first
        .productId;
    String size = context.read<ProductAddToCartBloc>().size;
    int quantity = context.read<ProductAddToCartBloc>().quantity;

    if (color != '' && productName != '' && size != '' && quantity > 0) {
      UiRender.showConfirmDialog(
        context,
        needCenterMessage: false,
        '',
        ValueRender.getAddToCartPopupContent(
          productName,
          color,
          size,
          quantity,
        ),
      ).then((value) {
        if (value == true) {
          context.read<CartBloc>().add(
                OnAddCartItemEvent(productId, color, size, quantity),
              );
        }
      });
    } else {
      UiRender.showDialog(
        context,
        '',
        'Please check color, quantity and size again!',
      );
    }
  }

  void onPressQuantityButton() {
    UiRender.showSingleTextFieldDialog(
      context,
      textInputType: TextInputType.number,
      hintText: 'Your quantity...',
      needCenterText: true,
      title: 'Input the quantity you want to purchase!',
      widget.textEditingController,
    ).then((value) {
      if (value) {
        try {
          if (int.parse(widget.textEditingController?.text ?? '0') > 0) {
            context.read<ProductAddToCartBloc>().add(
                  OnSelectProductAddToCartEvent(
                    quantity:
                        int.parse(widget.textEditingController?.text ?? '0'),
                  ),
                );
          } else {
            UiRender.showDialog(
              context,
              '',
              'Must be higher than 0!',
            );
            widget.textEditingController?.text = '';
          }
        } catch (e) {
          UiRender.showDialog(context, '', 'Not accepted!');
          widget.textEditingController?.text = '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 14.height, horizontal: 12.width),
      height: 65.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.radius),
          topRight: Radius.circular(24.radius),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 20,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xffa4a4a4),
            ),
            onPressed: () {
              context
                  .read<ProductAddToCartBloc>()
                  .add(OnClearProductAddToCartEvent());
              context.router.pop();
            },
          ),
          GradientElevatedButton(
            text: 'Add to cart',
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            buttonHeight: 50.height,
            buttonWidth: 160.width,
            textWeight: FontWeight.w600,
            textSize: 17.size,
            borderRadiusIndex: 5.radius,
            buttonMargin: EdgeInsets.zero,
            onPress: onPressAddToCartButton,
          ),
          GradientElevatedButton(
            text: widget.textEditingController?.text != ''
                ? 'Quantity: ${widget.textEditingController?.text}'
                : 'Input Quantity',
            textSize: 12.size,
            buttonWidth: 70.width,
            buttonHeight: 40.height,
            borderRadiusIndex: 5.radius,
            buttonMargin: EdgeInsets.zero,
            onPress: onPressQuantityButton,
          )
        ],
      ),
    );
  }
}
