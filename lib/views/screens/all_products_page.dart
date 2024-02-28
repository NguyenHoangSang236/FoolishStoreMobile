import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/views/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/products/product_bloc.dart';
import '../../config/app_router/app_router_path.dart';
import '../../data/entity/category.dart';
import '../../data/entity/product.dart';
import '../../data/static/global_variables.dart';
import '../../service/loading_service.dart';
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
  bool _isLoaded = false;
  double currentOffset = 0;

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (context.read<CategoryBloc>().selectedCategoryName == 'All' &&
          _isLoaded == false) {
        setState(() {
          _isLoaded = true;
          currentOffset = _scrollController.position.pixels - 10;

          context.read<ProductBloc>().add(
                OnLoadAllProductListEvent(
                  context.read<ProductBloc>().currentAllProductListPage + 1,
                  8,
                ),
              );
        });
      } else if (context.read<CategoryBloc>().selectedCategoryName != 'All' &&
          _isLoaded == false) {
        setState(() {
          _isLoaded = true;
          currentOffset = _scrollController.position.pixels - 10;

          context.read<ProductBloc>().add(
                OnLoadFilterProductListEvent(
                  context.read<ProductBloc>().currentAllProductListPage + 1,
                  8,
                  categoryList: [
                    context.read<CategoryBloc>().selectedCategoryName
                  ],
                ),
              );
        });
      }
    }
  }

  void _reloadPage() {
    setState(() {
      String currentCateName =
          context.read<CategoryBloc>().selectedCategoryName;

      _isLoaded = false;
      currentOffset = 0;

      if (currentCateName == "All") {
        selectedCategoryIndex = 0;
        context.read<ProductBloc>().add(
              const OnLoadAllProductListEvent(1, 8),
            );
      } else {
        selectedCategoryIndex = context
            .read<CategoryBloc>()
            .categoryList
            .indexWhere((element) => element.name == currentCateName);

        context.read<ProductBloc>().add(
              OnLoadFilterProductListEvent(1, 8,
                  categoryList: [currentCateName]),
            );
      }
    });
  }

  void onPressCategoryButton(String name) {
    setState(() {
      _isLoaded = false;
      currentOffset = 0;

      context.read<CategoryBloc>().add(OnSelectedCategoryEvent(name));
    });

    if (name == 'All') {
      context.read<ProductBloc>().add(const OnLoadAllProductListEvent(1, 8));
    } else {
      context.read<ProductBloc>().add(OnClearProductListEvent());
      context.read<ProductBloc>().add(
            OnLoadFilterProductListEvent(1, 8, categoryList: [name]),
          );
    }
  }

  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.CLOTHINGS.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);

      if (widget.isFromCategoryPage == false) {
        context.read<ProductBloc>().add(
              const OnLoadAllProductListEvent(1, 8),
            );
      } else {
        selectedCategoryIndex =
            context.read<CategoryBloc>().categoryList.indexOf(
                  context
                      .read<CategoryBloc>()
                      .categoryList
                      .where(
                        (element) =>
                            element.name ==
                            context.read<CategoryBloc>().selectedCategoryName,
                      )
                      .first,
                );

        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            _itemScrollController.scrollTo(
                index: selectedCategoryIndex,
                duration: const Duration(milliseconds: 1000));
          },
        );
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
      forceCanNotBack: true,
      textEditingController: _textEditingController,
      pageName: 'Clothings',
      hintSearchBarText: 'What product are you looking for?',
      body: RefreshIndicator(
        onRefresh: () async {
          _reloadPage();
        },
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: Column(children: [
          _categoryList(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.all(20.size),
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
      onTap: () => onPressCategoryButton(name),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 6.width),
        padding: EdgeInsets.symmetric(horizontal: 10.width, vertical: 5.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.radius),
          color: context.read<CategoryBloc>().selectedCategoryName != name
              ? Colors.white
              : null,
          gradient: context.read<CategoryBloc>().selectedCategoryName == name
              ? UiRender.generalLinearGradient()
              : null,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w400,
            color: context.read<CategoryBloc>().selectedCategoryName == name
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _categoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
      List<Category> categoryList =
          List.from(context.read<CategoryBloc>().categoryList);

      if (categoryState is CategoryLoadingState) {
        return UiRender.loadingCircle();
      }

      if (categoryState is CategoryLoadedState) {
        categoryList = List.from(categoryState.categoryList);
      }

      if (categoryList[0].name != 'All') {
        categoryList.insert(0, Category(0, 'All', ''));
      }

      return Container(
        constraints: BoxConstraints(
          maxHeight: 30.height,
        ),
        margin: EdgeInsets.only(bottom: 20.height, top: 15.height),
        padding: EdgeInsets.symmetric(horizontal: 20.width),
        child: ScrollablePositionedList.builder(
          itemScrollController: _itemScrollController,
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
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, productState) {
        if (productState is ProductLoadingState) {
          UiRender.showLoaderDialog(context);
        } else if (productState is ProductAllListLoadedState ||
            productState is ProductFilteredListLoadedState) {
          context.router.pop();
          _scrollController.jumpTo(currentOffset);
        }
      },
      builder: (context, productState) {
        List<Product> productList = [];

        if (productState is ProductAllListLoadedState) {
          productList = context.read<ProductBloc>().allProductList;
          _isLoaded = false;
        } else if (productState is ProductFilteredListLoadedState) {
          productList = context.read<ProductBloc>().filteredProductList;
          _isLoaded = false;
        }

        if (productList.isNotEmpty) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productList.length,
            // dragStartBehavior: DragStartBehavior.down,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.65,
              crossAxisCount: 2,
              crossAxisSpacing: 20.height,
              mainAxisSpacing: 25.width,
            ),
            itemBuilder: (context, index) {
              return ProductComponent(
                product: productList[index],
                onClick: () {
                  LoadingService(context)
                      .selectToViewProduct(productList[index]);

                  context.router.pushNamed(AppRouterPath.productDetails);
                },
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
