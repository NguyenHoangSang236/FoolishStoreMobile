import 'package:auto_route/annotations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import '../../bloc/productDetails/product_details_bloc.dart';
import '../../data/entity/product.dart';
import '../../utils/render/value_render.dart';

@RoutePage()
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  CarouselController carouselController = CarouselController();
  String selectedSize = '';
  String selectedColor = '';
  List<String> selectedImageUrlList = [];

  @override
  void initState() {
    setState(() {
      selectedColor =
          BlocProvider.of<ProductDetailsBloc>(context).selectedColor;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      needAppBar: false,
      needProductDetailsBottomNavBar: true,
      scaffoldKey: _scaffoldKey,
      textEditingController: _textEditingController,
      body: RefreshIndicator(
        onRefresh: () async {},
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              BlocListener<CartBloc, CartState>(
                listener: (context, cartState) {
                  if (cartState is CartAddedState) {
                    UiRender.showDialog(context, '', cartState.message);
                    BlocProvider.of<CartBloc>(context)
                        .add(OnLoadTotalCartItemQuantityEvent());
                  }
                },
                child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
                  listener: (context, productState) {
                    if (productState is ProductDetailsLoadedState) {
                      setState(() {
                        selectedImageUrlList =
                            ValueRender.getProductImageUrlListByColor(
                                selectedColor, productState.productList);
                      });
                    }
                  },
                  builder: (context, productState) {
                    List<Product> selectedProductDetails = [];

                    if (productState is ProductLoadingState) {
                      return UiRender.loadingCircle();
                    }

                    if (productState is ProductDetailsLoadedState) {
                      selectedProductDetails = productState.productList;
                    }

                    if (selectedProductDetails.isNotEmpty) {
                      // get list of products from selected color
                      List<Product> colorSelectedProductList =
                          selectedProductDetails
                              .where(
                                  (element) => element.color == selectedColor)
                              .toList();
                      // get list of products first image from different colors
                      List<String> productColorImageUrlList =
                          ValueRender.getProductImagesFromDifferentColors(
                              selectedProductDetails);
                      // get all colors of a product
                      List<String> productColorList =
                          ValueRender.getProductColorList(
                              selectedProductDetails);
                      // get list of products size using product color
                      List<String> productSizeList =
                          ValueRender.getProductSizeListByColor(
                              selectedColor, selectedProductDetails);

                      return Column(
                        children: [
                          _productImagesSlider(selectedImageUrlList),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 12.height),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.width,
                                  vertical: 24.height,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8.radius),
                                      bottomLeft: Radius.circular(8.radius),
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _ratingStarsAndProductStatus(
                                        colorSelectedProductList),
                                    _productNameAndPrice(
                                        colorSelectedProductList),
                                    _productColors(
                                        productColorImageUrlList,
                                        productColorList,
                                        selectedProductDetails,
                                        colorSelectedProductList),
                                    productSizeList.first.toLowerCase() !=
                                            'none'
                                        ? _productSizes(productSizeList)
                                        : Container(),
                                  ],
                                ),
                              ),
                              _itemDescription(
                                colorSelectedProductList[0].description,
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemDescription(String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.height),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 18.width, vertical: 24.height),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w600,
              fontSize: 16.size,
              color: Colors.black,
            ),
          ),
          10.verticalSpace,
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w400,
              fontSize: 11.size,
              color: const Color(0xff868686),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingStarsAndProductStatus(List<Product> colorSelectedProductList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: UiRender.buildRatingStars(
            colorSelectedProductList[0].overallRating.toInt(),
            size: 16.size,
          ),
        ),
        colorSelectedProductList[0].availableQuantity > 0
            ? Text(
                'In Stock',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.size,
                  color: const Color(0xff03A600),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Widget _productNameAndPrice(List<Product> colorSelectedProductList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          colorSelectedProductList[0].name,
          maxLines: 2,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w500,
            fontSize: 18.size,
            height: 1.5.height,
          ),
        ),
        colorSelectedProductList[0].discount > 0
            ? RichText(
                text: TextSpan(
                  text: ValueRender.getDiscountPrice(
                    colorSelectedProductList[0].sellingPrice,
                    colorSelectedProductList[0].discount,
                  ).format.dollar,
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.size,
                    color: const Color(0xff464646),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: colorSelectedProductList[0]
                          .sellingPrice
                          .format
                          .dollar,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.size,
                        color: const Color(0xffacacac),
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                colorSelectedProductList[0].sellingPrice.format.dollar,
                style: TextStyle(
                  fontFamily: 'Sen',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.size,
                  color: Colors.red,
                  height: 1.5.height,
                ),
              ),
      ],
    );
  }

  Widget _productColors(
    List<String> productColorImageUrlList,
    List<String> productColorList,
    List<Product> selectedProductDetails,
    List<Product> colorSelectedProductList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        25.verticalSpace,
        Text(
          'Colors',
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w500,
            fontSize: 14.size,
            color: const Color(0xffa4a4a4),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List<Widget>.generate(
            productColorImageUrlList.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<ProductAddToCartBloc>(context).add(
                    OnSelectProductAddToCartEvent(
                      color: productColorList[index],
                    ),
                  );

                  setState(() {
                    selectedColor = productColorList[index];
                    selectedSize = '';
                    selectedImageUrlList =
                        ValueRender.getProductImageUrlListByColor(
                      selectedColor,
                      selectedProductDetails,
                    );
                  });
                },
                child: UiRender.buildCachedNetworkImage(
                  context,
                  productColorImageUrlList[index],
                  height: 50.height,
                  width: 50.width,
                  margin: EdgeInsets.only(right: 11.width, top: 14.height),
                  borderRadius: BorderRadius.circular(8.radius),
                  border: productColorList[index] ==
                          colorSelectedProductList.first.color
                      ? Border.all(color: Colors.orange)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _productSizes(List<String> productSizeList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        25.verticalSpace,
        Text(
          'Sizes',
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w500,
            fontSize: 14.size,
            color: const Color(0xffa4a4a4),
          ),
        ),
        SizedBox(
          height: 50.height,
          child: ListView.builder(
            itemCount: productSizeList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<ProductAddToCartBloc>(context).add(
                    OnSelectProductAddToCartEvent(
                      size: productSizeList[index],
                    ),
                  );

                  setState(() {
                    selectedSize = productSizeList[index];
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.height,
                  width: 50.width,
                  margin: EdgeInsets.only(right: 11.width),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.radius),
                    border: Border.all(
                      color: const Color(0xffc4c4c4),
                    ),
                    gradient: productSizeList[index] == selectedSize
                        ? UiRender.generalLinearGradient()
                        : null,
                  ),
                  child: Text(
                    productSizeList[index].toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.size,
                      color: productSizeList[index] == selectedSize
                          ? Colors.white
                          : const Color(0xff626262),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _productImagesSlider(List<String> imageUrlList) {
    return CarouselSlider(
      carouselController: carouselController,
      items: _imageComponentList(imageUrlList),
      options: CarouselOptions(
        autoPlay: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayCurve: Curves.easeInOutCubicEmphasized,
        enableInfiniteScroll: true,
        height: MediaQuery.of(context).size.height * 3 / 5,
        viewportFraction: 1,
      ),
    );
  }

  List<Widget> _imageComponentList(List<String> imageUrlList) {
    List<Widget> resultList = [];

    for (int i = 0; i < imageUrlList.length; i++) {
      resultList.add(_imageComponent(imageUrlList[i]));
    }

    return resultList;
  }

  Widget _imageComponent(String imageUrl) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: UiRender.buildCachedNetworkImage(
        context,
        imageUrl,
      ),
    );
  }
}
