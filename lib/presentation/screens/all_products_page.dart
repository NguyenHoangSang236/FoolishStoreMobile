import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/products/product_bloc.dart';
import '../../config/app_router/app_router_path.dart';
import '../../data/entity/category.dart';
import '../../data/entity/product.dart';
import '../../data/static/global_variables.dart';
import '../../utils/service/loading_service.dart';
import '../components/product_component.dart';

@RoutePage()
class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key, this.isFromCategoryPage = false});

  final bool isFromCategoryPage;

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ItemScrollController _itemScrollController = ItemScrollController();
  int selectedCategoryIndex = 0;

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (BlocProvider.of<CategoryBloc>(context).selectedCategoryName ==
          'All') {
        BlocProvider.of<ProductBloc>(context).add(OnLoadAllProductListEvent(
            BlocProvider.of<ProductBloc>(context).currentAllProductListPage + 1,
            8));
      }
    }
  }

  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.CLOTHINGS.name;

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFromCategoryPage == false) {
        BlocProvider.of<ProductBloc>(context)
            .add(const OnLoadAllProductListEvent(1, 8));
      } else {
        selectedCategoryIndex = BlocProvider.of<CategoryBloc>(context)
            .categoryList
            .indexOf(BlocProvider.of<CategoryBloc>(context)
                .categoryList
                .where((element) =>
                    element.name ==
                    BlocProvider.of<CategoryBloc>(context).selectedCategoryName)
                .first);

        Future.delayed(const Duration(milliseconds: 500), () {
          _itemScrollController.scrollTo(
              index: selectedCategoryIndex,
              duration: const Duration(milliseconds: 1000));
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: false,
      textEditingController: _textEditingController,
      pageName: 'Clothings',
      hintSearchBarText: 'What product are you looking for?',
      body: RefreshIndicator(
        onRefresh: () async {},
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: Column(children: [
          _categoryList(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _productsList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _categoryItem(String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          BlocProvider.of<CategoryBloc>(context)
              .add(OnSelectedCategoryEvent(name));
        });

        if (name == 'All') {
          BlocProvider.of<ProductBloc>(context)
              .add(const OnLoadAllProductListEvent(1, 8));
        } else {
          BlocProvider.of<ProductBloc>(context)
              .add(OnLoadFilterProductListEvent(1, 8, categoryList: [name]));
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: BlocProvider.of<CategoryBloc>(context).selectedCategoryName !=
                  name
              ? Colors.white
              : null,
          gradient:
              BlocProvider.of<CategoryBloc>(context).selectedCategoryName ==
                      name
                  ? UiRender.generalLinearGradient()
                  : null,
        ),
        child: Text(
          name,
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w400,
              color:
                  BlocProvider.of<CategoryBloc>(context).selectedCategoryName ==
                          name
                      ? Colors.white
                      : Colors.black),
        ),
      ),
    );
  }

  Widget _categoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
      List<Category> categoryList =
          List.from(BlocProvider.of<CategoryBloc>(context).categoryList);

      if (categoryState is CategoryLoadingState) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        );
      }

      if (categoryState is CategoryLoadedState) {
        categoryList = List.from(categoryState.categoryList);
      }

      if (categoryList[0].name != 'All') {
        categoryList.insert(0, Category(0, 'All', ''));
      }

      return Container(
        height: 25,
        margin: const EdgeInsets.only(bottom: 20, top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ScrollablePositionedList.builder(
          itemScrollController: _itemScrollController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return _categoryItem(categoryList[index].name);
          },
        ),
      );
    });
  }

  Widget _productsList() {
    return BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
      List<Product> productList = [];

      // if(productState is ProductLoadingState) {
      //   return const Center(
      //     child: CircularProgressIndicator(
      //       color: Colors.orange,
      //     ),
      //   );
      // }

      if (productState is ProductAllListLoadedState) {
        productList = productState.productList;
      } else if (productState is ProductFilteredListLoadedState) {
        productList = productState.productList;
      }

      if (productList.isNotEmpty) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productList.length,
          dragStartBehavior: DragStartBehavior.down,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.65,
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 25,
          ),
          itemBuilder: (context, index) {
            return ProductComponent(
              product: productList[index],
              onClick: () {
                LoadingService(context).selectToViewProduct(productList[index]);

                context.router.pushNamed(AppRouterPath.productDetails);
              },
            );
          },
        );
      } else {
        return const Center(
          child: Text('NOT AVAILABLE!!'),
        );
      }
    });
  }
}
