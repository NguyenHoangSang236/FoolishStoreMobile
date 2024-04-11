import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/comment/comment_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/dto/websocket_message.dart';
import 'package:fashionstore/data/entity/comment.dart';
import 'package:fashionstore/data/enum/websocket_enum.dart';
import 'package:fashionstore/main.dart';
import 'package:fashionstore/service/loading_service.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/views/components/comment_list.dart';
import 'package:fashionstore/views/components/product_component.dart';
import 'package:fashionstore/views/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import '../../bloc/productDetails/product_details_bloc.dart';
import '../../config/app_router/app_router_path.dart';
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
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final CarouselController _carouselController = CarouselController();
  String _selectedSize = '';
  String _selectedColor = '';
  late int _selectedProductId;
  bool _isTyping = false;
  List<String> _selectedImageUrlList = [];

  void _reloadCommentYouLikeIdList() {
    context.read<CommentBloc>().add(
          OnLoadCommentIdYouLikedListEvent(
            productColor: _selectedColor,
            productId: _selectedProductId,
          ),
        );
  }

  void _animateScroller() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    _selectedColor = context.read<ProductDetailsBloc>().selectedColor;
    _selectedProductId = context.read<ProductDetailsBloc>().selectedProductId;

    stompClient.activate();

    super.initState();
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  void _showTypingCommentIndicator() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          _isTyping = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      needAppBar: false,
      needProductDetailsBottomNavBar: true,
      scaffoldKey: _scaffoldKey,
      textEditingController: _textEditingController,
      onBack: () => context.read<ProductBloc>().add(OnDeselectProduct()),
      body: RefreshIndicator(
        onRefresh: () async => LoadingService(context).selectToViewProduct(
          context.read<ProductBloc>().selectedProductToView!,
        ),
        color: Colors.orange,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: MultiBlocListener(
            listeners: [
              BlocListener<CartBloc, CartState>(
                listener: (context, cartState) {
                  if (cartState is CartAddedState) {
                    UiRender.showDialog(context, '', cartState.message);
                    context
                        .read<CartBloc>()
                        .add(OnLoadTotalCartItemQuantityEvent());
                  }
                },
              ),
              BlocListener<ProductBloc, ProductState>(
                listener: (context, productState) {
                  if (productState is ProductRatedState) {
                    UiRender.showDialog(context, '', productState.message);
                  } else if (productState is ProductErrorState) {
                    UiRender.showDialog(context, '', productState.message);
                  }
                },
              ),
              BlocListener<CommentBloc, CommentState>(
                listener: (context, commentState) {
                  if (commentState is CommentAddedState) {
                    UiRender.showSnackBar(context, commentState.message);

                    // _reloadCommentList();
                    _animateScroller();

                    setState(() {
                      _commentController.clear();
                    });
                  } else if (commentState is CommentReactedState) {
                    _reloadCommentYouLikeIdList();
                  }
                },
              ),
            ],
            child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
              listener: (context, productState) {
                if (productState is ProductDetailsColorSelectedState) {
                  setState(() {
                    _selectedColor = productState.color;
                  });
                }
                if (productState is ProductDetailsLoadedState) {
                  setState(() {
                    _selectedImageUrlList =
                        ValueRender.getProductImageUrlListByColor(
                      _selectedColor,
                      productState.productList,
                    );

                    _selectedProductId =
                        productState.productList.first.productId!.toInt();
                  });

                  stompClient.subscribe(
                    destination:
                        '$websocketDestination/${productState.productList.first.productId}/$_selectedColor',
                    callback: (frame) {
                      debugPrint('Received web socket message: ${frame.body}');

                      if (frame.body != null) {
                        Map<String, dynamic> payload = json.decode(frame.body!);

                        if (payload['type'].isNotEmpty) {
                          if (payload['type'] ==
                                  WebsocketEnum.TYPING_COMMENT.name &&
                              payload['sender'] !=
                                  context
                                      .read<AuthenticationBloc>()
                                      .currentUser
                                      ?.userName) {
                            _showTypingCommentIndicator();
                          } else if (payload['type'] ==
                              WebsocketEnum.POST_COMMENT.name) {
                            Comment comment = Comment.fromJson(
                              payload['content'],
                            );

                            context
                                .read<CommentBloc>()
                                .add(OnLoadCommentFromWebsocketEvent(
                                  comment: comment,
                                ));
                          }
                        }
                      }
                    },
                  );

                  stompClient.send(
                    destination:
                        '$websocketDestinationPrefix/addUser/${productState.productList.first.productId}/$_selectedColor',
                    body: json.encode(
                      WebsocketMessage(
                        type: WebsocketEnum.JOIN,
                        sender: context
                            .read<AuthenticationBloc>()
                            .currentUser
                            ?.userName,
                      ).toJson(),
                    ),
                  );
                }
              },
              builder: (context, productState) {
                List<Product> selectedProductDetails = [];

                if (productState is ProductDetailsLoadingState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: UiRender.loadingCircle(),
                  );
                } else if (productState is ProductDetailsLoadedState) {
                  selectedProductDetails = productState.productList;
                }

                if (selectedProductDetails.isNotEmpty) {
                  // get list of products from selected color
                  List<Product> colorSelectedProductList =
                      selectedProductDetails
                          .where((element) => element.color == _selectedColor)
                          .toList();
                  // get list of products first image from different colors
                  List<String> productColorImageUrlList =
                      ValueRender.getProductImagesFromDifferentColors(
                    selectedProductDetails,
                  );
                  // get all colors of a product
                  List<String> productColorList =
                      ValueRender.getProductColorList(selectedProductDetails);
                  // get list of products size using product color
                  List<String> productSizeList =
                      ValueRender.getProductSizeListByColor(
                    _selectedColor,
                    selectedProductDetails,
                  );

                  return Column(
                    children: [
                      _productImagesSlider(_selectedImageUrlList),
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
                                  colorSelectedProductList,
                                ),
                                _productNameAndPrice(
                                  colorSelectedProductList,
                                ),
                                _productColors(
                                  productColorImageUrlList,
                                  productColorList,
                                  selectedProductDetails,
                                  colorSelectedProductList,
                                ),
                                productSizeList.first.toLowerCase() != 'none'
                                    ? _productSizes(productSizeList)
                                    : Container(),
                              ],
                            ),
                          ),
                          _itemDescription(
                            colorSelectedProductList[0].description ??
                                'No description',
                          ),
                          // _productRecommender(),
                          _commentList(),
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
        ),
      ),
    );
  }

  Widget _commentList() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12.height),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 18.width,
            vertical: 24.height,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.size,
                  color: Colors.black,
                ),
              ),
              15.verticalSpace,
              CommentList(
                productId: _selectedProductId,
                productColor: _selectedColor,
                replyOn: 0,
                page: context.read<CommentBloc>().page,
                controller: _commentController,
                isSomeoneTyping: _isTyping,
              ),
            ],
          ),
        ),
      ],
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

  Widget _productRecommender() {
    return Container(
      height: 400.height,
      margin: EdgeInsets.only(bottom: 12.height),
      padding: EdgeInsets.symmetric(horizontal: 18.width, vertical: 24.height),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recommend products',
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w600,
              fontSize: 16.size,
              color: Colors.black,
            ),
          ),
          10.verticalSpace,
          Flexible(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                List<Product> productList =
                    context.read<ProductBloc>().recommendedProductList;

                if (state is ProductLoadingState) {
                  return UiRender.loadingCircle();
                } else if (state is ProductRecommendedState) {
                  productList = state.productList;
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return ProductComponent(
                      product: productList[index],
                      onClick: () async {
                        await LoadingService(context)
                            .selectToViewProduct(productList[index])
                            .then(
                              (value) => context.router
                                  .pushNamed(AppRouterPath.productDetails),
                            );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return 15.horizontalSpace;
                  },
                );
              },
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
        GestureDetector(
          onTap: () {
            UiRender.showRatingDialog(
              context: context,
              title: 'Rate this product!',
            ).then((ratePoint) {
              if (ratePoint != null && ratePoint > 0) {
                context.read<ProductBloc>().add(
                      OnRateProduct(
                        _selectedProductId,
                        _selectedColor,
                        ratePoint,
                      ),
                    );
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: UiRender.buildRatingStars(
              colorSelectedProductList[0].overallRating.toInt(),
              size: 16.size,
            ),
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
            : const SizedBox(),
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
                  context.read<ProductAddToCartBloc>().add(
                        OnSelectProductAddToCartEvent(
                          color: productColorList[index],
                        ),
                      );

                  context.read<CommentBloc>().add(
                        OnLoadCommentListEvent(
                          productColor: productColorList[index],
                          productId: _selectedProductId,
                        ),
                      );

                  setState(() {
                    _selectedColor = productColorList[index];
                    _selectedSize = '';
                    _selectedImageUrlList =
                        ValueRender.getProductImageUrlListByColor(
                      _selectedColor,
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
                  context.read<ProductAddToCartBloc>().add(
                        OnSelectProductAddToCartEvent(
                          size: productSizeList[index],
                        ),
                      );

                  setState(() {
                    _selectedSize = productSizeList[index];
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
                    gradient: productSizeList[index] == _selectedSize
                        ? UiRender.generalLinearGradient()
                        : null,
                  ),
                  child: Text(
                    productSizeList[index].toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.size,
                      color: productSizeList[index] == _selectedSize
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
      carouselController: _carouselController,
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
