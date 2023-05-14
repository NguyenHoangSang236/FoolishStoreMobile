import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/data/entity/CartItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/render/ValueRender.dart';

class CartItemComponent extends StatefulWidget {
  const CartItemComponent({super.key, required this.cartItem, required this.onTap, required this.onClear});

  final CartItem cartItem;
  final void Function() onTap;
  final void Function() onClear;

  @override
  State<StatefulWidget> createState() => _CartItemComponentState();
}

class _CartItemComponentState extends State<CartItemComponent> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: const Color(0xff868686)
              ),
            ),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.cartItem.image1,
                  imageBuilder: (context, imageProvider)
                  => Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cartItem.name +
                                  (widget.cartItem.size.toLowerCase() != 'none'
                                      ? ' - Size: ${widget.cartItem.size.toUpperCase()} '
                                      : ''),
                              maxLines: 2,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff464646),
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.cartItem.brand.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xff626262),
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  height: 1.5
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.cartItem.discount > 0
                                ? RichText(
                                text: TextSpan(
                                    text: '\$${ValueRender.getDiscountPrice(widget.cartItem.sellingPrice, widget.cartItem.discount)}  ',
                                    style: const TextStyle(
                                        fontFamily: 'Sen',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.red,
                                        height: 1.5
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '\$${widget.cartItem.sellingPrice.toString()}',
                                        style: const TextStyle(
                                            fontFamily: 'Sen',
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 9,
                                            color: Color(0xffacacac)
                                        ),
                                      )
                                    ]
                                )
                            )
                                : Text(
                              '\$ ${widget.cartItem.sellingPrice}',
                              style: const TextStyle(
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.red,
                                  height: 1.5
                              ),
                            ),
                            Text(
                              'Quantity: ${widget.cartItem.quantity}',
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff464646),
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            )
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
              top: -8,
              right: -20,
              child: Container(
                color: const Color(0xfff3f3f3),
                child: IconButton(
                  onPressed: () {

                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    'assets/icon/x_icon.png',
                    color: Colors.black45,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}