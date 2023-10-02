import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/data/entity/cart_item.dart';
import 'package:fashionstore/presentation/components/gradient_button.dart';
import 'package:fashionstore/presentation/components/icon_button.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/cart_item_info.dart';
import '../../data/entity/product.dart';
import '../../utils/render/ui_render.dart';
import '../../utils/render/value_render.dart';

class CartItemDetails extends StatefulWidget {
  const CartItemDetails({Key? key, required this.selectedCartItem})
      : super(key: key);

  final CartItem selectedCartItem;

  @override
  State<StatefulWidget> createState() => _CartItemDetailsState();
}

class _CartItemDetailsState extends State<CartItemDetails> {
  late CartItem editedCartItem;
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    editedCartItem = CartItem.clone(widget.selectedCartItem);
    quantityController.text = widget.selectedCartItem.quantity.toString();

    super.initState();
  }

  @override
  void dispose() {
    quantityController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, productDetailsState) {
        List<Product> selectedProductDetails =
            BlocProvider.of<ProductDetailsBloc>(context).selectedProductDetails;
        // get list of products first image from different colors
        List<String> productColorImageUrlList = [];
        // get all colors of a product
        List<String> productColorList = [];
        // get list of products size using product color
        List<String> productSizeList = ValueRender.getProductSizeListByColor(
          editedCartItem.color,
          selectedProductDetails,
        );

        if (productDetailsState is ProductDetailsLoadingState) {}

        if (productDetailsState is ProductDetailsLoadedState) {
          selectedProductDetails = productDetailsState.productList;
          productColorList =
              ValueRender.getProductColorList(selectedProductDetails);
          productColorImageUrlList =
              ValueRender.getProductImagesFromDifferentColors(
                  selectedProductDetails);

          if (selectedProductDetails.isNotEmpty &&
              selectedProductDetails.isNotEmpty) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                30.width,
                35.height,
                30.width,
                MediaQuery.of(context).viewInsets.bottom + 20.height,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UiRender.buildCachedNetworkImage(
                        context,
                        selectedProductDetails
                                .where((element) =>
                                    element.color == editedCartItem.color)
                                .first
                                .image1 ??
                            '',
                        margin: EdgeInsets.only(right: 10.width),
                        width: 81.width,
                        height: 93.height,
                        borderRadius: BorderRadius.circular(8.radius),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                editedCartItem.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xff626262),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.size,
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                editedCartItem.brand.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xff868686),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.size,
                                  height: 1.5.height,
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: editedCartItem.discount > 0
                                        ? RichText(
                                            text: TextSpan(
                                              text:
                                                  ValueRender.getDiscountPrice(
                                                editedCartItem.sellingPrice,
                                                editedCartItem.discount,
                                              ).format.dollar,
                                              style: TextStyle(
                                                fontFamily: 'Sen',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.size,
                                                color: Colors.red,
                                                height: 1.5.height,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: editedCartItem
                                                      .sellingPrice
                                                      .format
                                                      .dollar,
                                                  style: TextStyle(
                                                    fontFamily: 'Sen',
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 9.size,
                                                    color: const Color(
                                                      0xffacacac,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(
                                            editedCartItem
                                                .sellingPrice.format.dollar,
                                            style: TextStyle(
                                              fontFamily: 'Sen',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.size,
                                              color: Colors.red,
                                              height: 1.5.height,
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                    child: _cartItemQuantityEditComponent(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  25.verticalSpace,
                  Text(
                    'Colors',
                    style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.size,
                        color: const Color(0xff979797)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.height),
                    height: 48.height,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productColorImageUrlList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              editedCartItem.color = productColorList[index];
                            });
                          },
                          child: UiRender.buildCachedNetworkImage(
                            context,
                            productColorImageUrlList[index],
                            height: 48.height,
                            width: 48.width,
                            borderRadius: BorderRadius.circular(8),
                            margin: const EdgeInsets.only(right: 10),
                            border:
                                productColorList[index] == editedCartItem.color
                                    ? Border.all(color: Colors.orange)
                                    : null,
                          ),
                        );
                      },
                    ),
                  ),
                  25.verticalSpace,
                  Text(
                    'Sizes',
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.size,
                      color: const Color(0xff979797),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30.height, top: 5.height),
                    height: 48.height,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productSizeList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              editedCartItem.size = productSizeList[index];
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.width),
                            alignment: Alignment.center,
                            height: 48.height,
                            width: 48.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.radius),
                              gradient:
                                  editedCartItem.size == productSizeList[index]
                                      ? UiRender.generalLinearGradient()
                                      : null,
                              border: Border.all(
                                color: const Color(0xffc4c4c4),
                              ),
                            ),
                            child: Text(
                              productSizeList[index].toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.size,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Work Sans',
                                color: editedCartItem.size ==
                                        productSizeList[index]
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: GradientElevatedButton(
                      text: 'UPDATE',
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      endColor: const Color(0xff000000),
                      beginColor: const Color(0xff8D8D8C),
                      textColor: Colors.white,
                      buttonHeight: 35.height,
                      buttonWidth: 150.width,
                      textWeight: FontWeight.w600,
                      textSize: 16.size,
                      borderRadiusIndex: 10.radius,
                      buttonMargin: EdgeInsets.zero,
                      onPress: () {
                        setState(() {
                          editedCartItem.quantity =
                              int.parse(quantityController.text);

                          BlocProvider.of<CartBloc>(context).add(
                            OnUpdateCartEvent(
                              [
                                CartItemInfo(
                                  editedCartItem.productId,
                                  editedCartItem.id,
                                  editedCartItem.quantity,
                                  editedCartItem.color,
                                  editedCartItem.size,
                                  editedCartItem.selectStatus,
                                )
                              ],
                              needReload: true,
                            ),
                          );

                          context.router.pop();
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          }
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: UiRender.loadingCircle(),
        );
      },
    );
  }

  Widget _cartItemQuantityEditComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButtonComponent(
          iconPath: 'assets/icon/minus_icon.png',
          onTap: () {
            setState(() {
              int quant = int.parse(quantityController.text);
              if (quant > 1) {
                quantityController.text = (quant - 1).toString();
              }
            });
          },
          borderRadius: BorderRadius.circular(50.radius),
          backgroundColor: const Color(0xffc4c4c4),
          splashColor: Colors.white,
          iconSize: 10.size,
        ),
        Container(
          width: 35.width,
          height: 25.height,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 3.width),
          child: TextField(
            showCursor: true,
            autofocus: true,
            onSubmitted: (value) {
              try {
                int quant = int.parse(value);

                if (quant > 0) {
                  quantityController.text = value;
                } else {
                  quantityController.text = '1';
                  UiRender.showDialog(
                      context, '', 'You must input a number higher than 0!');
                }
              } catch (e) {
                quantityController.text =
                    widget.selectedCartItem.quantity.toString();
                UiRender.showDialog(context, '', 'You must input a number!');
              }
            },
            enableInteractiveSelection: false,
            controller: quantityController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 15.size,
              color: const Color(0xff626262),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        IconButtonComponent(
          iconPath: 'assets/icon/plus_icon.png',
          onTap: () {
            setState(() {
              int quant = int.parse(quantityController.text);
              if (quant < 100) {
                quantityController.text = (quant + 1).toString();
              }
            });
          },
          borderRadius: BorderRadius.circular(50.radius),
          backgroundColor: const Color(0xffc4c4c4),
          splashColor: Colors.white,
          iconSize: 10.size,
        ),
      ],
    );
  }
}
