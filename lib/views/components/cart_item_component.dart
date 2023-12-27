import 'package:fashionstore/data/entity/cart_item.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../data/entity/cart_item_info.dart';
import '../../utils/render/value_render.dart';

class CartItemComponent extends StatefulWidget {
  const CartItemComponent({
    super.key,
    required this.cartItem,
    required this.onTap,
  });

  final CartItem cartItem;
  final void Function() onTap;

  @override
  State<StatefulWidget> createState() => _CartItemComponentState();
}

class _CartItemComponentState extends State<CartItemComponent> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.cartItem.isSelected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 15.height,
          width: 15.width,
          child: Checkbox(
              activeColor: Colors.orange,
              checkColor: Colors.white,
              value: isSelected,
              shape: const CircleBorder(),
              onChanged: (bool? value) {
                setState(() {
                  isSelected = value ?? false;
                });

                int selectStatus = 0;

                if (isSelected == true) {
                  selectStatus = 1;
                }

                context.read<CartBloc>().add(
                      OnUpdateCartEvent(
                        [
                          CartItemInfo(
                              widget.cartItem.productId,
                              widget.cartItem.id,
                              widget.cartItem.quantity,
                              widget.cartItem.color,
                              widget.cartItem.size,
                              selectStatus)
                        ],
                        needReload: false,
                      ),
                    );
              }),
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: 150.height,
                ),
                width: MediaQuery.of(context).size.width - 50.width,
                margin: EdgeInsets.fromLTRB(8.width, 12.height, 0, 12.height),
                padding: EdgeInsets.all(10.size),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.radius),
                  border: Border.all(color: const Color(0xff868686)),
                ),
                child: Row(
                  children: [
                    UiRender.buildCachedNetworkImage(
                      context,
                      widget.cartItem.image1,
                      margin: EdgeInsets.only(right: 10.width),
                      width: 100.width,
                      height: 80.height,
                      borderRadius: BorderRadius.circular(8.radius),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cartItem.name +
                                    (widget.cartItem.size.toLowerCase() !=
                                            'none'
                                        ? ' - Size: ${widget.cartItem.size.toUpperCase()} '
                                        : ''),
                                maxLines: 2,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: const Color(0xff626262),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.size,
                                ),
                              ),
                              Text(
                                widget.cartItem.brand.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xff868686),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.size,
                                  height: 1.5.height,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 27.height,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.cartItem.discount > 0
                                    ? RichText(
                                        text: TextSpan(
                                          text: ValueRender.getDiscountPrice(
                                            widget.cartItem.sellingPrice,
                                            widget.cartItem.discount,
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
                                              text: widget.cartItem.sellingPrice
                                                  .format.dollar,
                                              style: TextStyle(
                                                fontFamily: 'Sen',
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 9.size,
                                                color: const Color(0xffacacac),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        widget.cartItem.sellingPrice.format
                                            .dollar,
                                        style: TextStyle(
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.size,
                                          color: Colors.red,
                                          height: 1.5.height,
                                        ),
                                      ),
                                Text(
                                  'Quantity: ${widget.cartItem.quantity}',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: const Color(0xff626262),
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.size,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: -8.height,
                right: -20.width,
                child: Container(
                  color: const Color(0xfff3f3f3),
                  child: IconButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            OnRemoveCartItemEvent(
                              [widget.cartItem.id],
                            ),
                          );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Image.asset(
                      'assets/icon/x_icon.png',
                      color: Colors.black45,
                      scale: 3.size,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
