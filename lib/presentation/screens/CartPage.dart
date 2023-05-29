import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/productDetails/product_details_bloc.dart';
import 'package:fashionstore/data/entity/CartItem.dart';
import 'package:fashionstore/presentation/components/CartItemComponent.dart';
import 'package:fashionstore/presentation/components/CartItemDetails.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:fashionstore/util/service/LoadingService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/entity/Product.dart';
import '../../data/enum/NavigationNameEnum.dart';
import '../../data/static/GlobalVariable.dart';
import '../../util/render/ValueRender.dart';
import '../layout/Layout.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});


  @override
  State<StatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.CART.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadCartPage();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: false,
      textEditingController: _textEditingController,
      pageName: 'My Cart',
      hintSearchBarText: 'What item are you looking for?',
      onSearch: (text) {

      },
      body: RefreshIndicator(
        color: Colors.orange,
        key: _refreshIndicatorKey,
        onRefresh: () async {
          LoadingService(context).reloadCartPage();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalCartPriceComponent(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics:  _scrollController.hasClients
                  ? _scrollController.position.maxScrollExtent > 0
                    ? const BouncingScrollPhysics()
                    : const AlwaysScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      _cartItemList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalCartPriceComponent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total cart price: ',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Color(0xff464646),
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                List<CartItem> cartItemList = BlocProvider.of<CartBloc>(context).cartItemList;

                if(cartState is CartLoadingState) {
                  return UiRender.loadingCircle();
                }

                if(cartState is AllCartListLoadedState) {
                  cartItemList = cartState.cartItemList;
                }

                return Text(
                  '\$ ${ValueRender.totalCartPrice(cartItemList)}',
                  style: const TextStyle(
                    fontFamily: 'Sen',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  Widget _cartItemList() {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, cartState) {
        if(cartState is CartRemovedState) {
          UiRender.showDialog(context, '', cartState.message);
          LoadingService(context).reloadCartPage();
        }

        if(cartState is CartUpdatedState) {
          UiRender.showDialog(context, '', cartState.message);
          LoadingService(context).reloadCartPage();
        }

        if(cartState is CartErrorState) {
          UiRender.showDialog(context, '', cartState.message);
        }
      },
      builder: (context, cartState) {
        List<CartItem> cartItemList = BlocProvider.of<CartBloc>(context).cartItemList;

        if(cartState is CartLoadingState) {
          return UiRender.loadingCircle();
        }

        if(cartState is AllCartListLoadedState) {
          cartItemList = List.from(cartState.cartItemList);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItemList.length,
          itemBuilder: (context, index) {
            return CartItemComponent(
              cartItem: cartItemList[index],
              onTap: () {
                setState(() {
                  BlocProvider.of<ProductDetailsBloc>(context).add(OnSelectProductEvent(cartItemList[index].productId));

                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CartItemDetails(selectedCartItem: cartItemList[index]);
                    }
                  );
                });
              },
            );
          }
        );
      }
    );
  }
}