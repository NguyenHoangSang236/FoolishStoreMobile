import 'package:fashionstore/data/entity/product.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/material.dart';

class ProductComponent extends StatefulWidget {
  const ProductComponent({Key? key, required this.product, this.onClick})
      : super(key: key);

  final Product product;
  final void Function()? onClick;

  @override
  State<StatefulWidget> createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 34.width,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: UiRender.buildCachedNetworkImage(
                    context,
                    widget.product.image1 ?? '',
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: UiRender.buildRatingStars(
                          widget.product.overallRating.toInt(),
                        ),
                      ),
                      Text(
                        widget.product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 13.size,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff464646),
                        ),
                      ),
                      widget.product.discount > 0
                          ? RichText(
                              text: TextSpan(
                                text: ValueRender.getDiscountPrice(
                                  widget.product.sellingPrice,
                                  widget.product.discount,
                                ).format.dollar,
                                style: TextStyle(
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.size,
                                  color: Colors.red,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: widget
                                        .product.sellingPrice.format.dollar,
                                    style: TextStyle(
                                      fontFamily: 'Sen',
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9.size,
                                      color: const Color(0xffacacac),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              widget.product.sellingPrice.format.dollar,
                              style: TextStyle(
                                fontFamily: 'Sen',
                                fontWeight: FontWeight.w700,
                                fontSize: 14.size,
                                color: Colors.red,
                                height: 1.5.height,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            widget.product.discount > 0
                ? Positioned(
                    left: 0,
                    top: 23.height,
                    child: Container(
                      alignment: Alignment.center,
                      width: 50.width,
                      height: 23.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.radius),
                          bottomRight: Radius.circular(20.radius),
                        ),
                        gradient: UiRender.generalLinearGradient(),
                      ),
                      child: Text(
                        '-${widget.product.discount.format}%',
                        style: TextStyle(
                          fontFamily: 'Sen',
                          fontWeight: FontWeight.w700,
                          fontSize: 11.size,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
