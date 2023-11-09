import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/data/entity/category.dart';
import 'package:fashionstore/data/enum/product_list_type_enum.dart';
import 'package:fashionstore/data/static/global_variables.dart';
import 'package:fashionstore/presentation/components/gradient_button.dart';
import 'package:fashionstore/presentation/components/product_component.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productSearching/product_searching_bloc.dart';
import '../../config/app_router/app_router_path.dart';
import '../../data/entity/product.dart';
import '../../data/enum/navigation_name_enum.dart';
import '../../utils/render/ui_render.dart';

@RoutePage()
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    GlobalVariable.currentNavBarPage = NavigationNameEnum.HOME.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadIndexPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      forceCanNotBack: true,
      hintSearchBarText: 'What product are you looking for?',
      textEditingController: _textEditingController,
      body: RefreshIndicator(
        onRefresh: () async {
          LoadingService(context).reloadIndexPage();
        },
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.all(20.size),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  'Categories',
                  true,
                  action: () {
                    context.router.replaceNamed(AppRouterPath.allCategories);

                    GlobalVariable.currentNavBarPage =
                        NavigationNameEnum.CATEGORIES.name;
                  },
                ),
                _categoryListComponent(),
                _header('New Arrivals', false),
                _productList(ProductListTypeEnum.NEW_ARRIVAL.name),
                _header('Best Sellers', false),
                _productList(ProductListTypeEnum.TOP_BEST_SELLERS.name),
                _header('Hot Discount', false),
                _productList(ProductListTypeEnum.HOT_DISCOUNT.name),
                Align(
                  alignment: Alignment.center,
                  child: GradientElevatedButton(
                    text: 'View all products',
                    beginColor: const Color(0xff000000),
                    endColor: const Color(0xff8D8D8C),
                    textColor: Colors.white,
                    onPress: () {
                      context.router.pushNamed(AppRouterPath.allProducts);

                      context.read<CategoryBloc>().add(
                            const OnSelectedCategoryEvent('All'),
                          );

                      GlobalVariable.currentNavBarPage =
                          NavigationNameEnum.CLOTHINGS.name;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryComponent(Category category) {
    return GestureDetector(
      onTap: () {
        LoadingService(context).selectCategory(category);
      },
      child: UiRender.buildCachedNetworkImage(
        context,
        ValueRender.getGoogleDriveImageUrl(category.image),
        width: 90.width,
        height: 90.height,
        margin: EdgeInsets.only(right: 13.width),
        borderRadius: BorderRadius.circular(8.radius),
        content: Text(
          category.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontSize: 15.size,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _header(String headerContent, bool canViewAll,
      {void Function()? action}) {
    return Container(
      margin: EdgeInsets.only(top: 10.height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerContent,
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 18.size,
              fontWeight: FontWeight.w600,
              height: 1.5.height,
            ),
          ),
          canViewAll
              ? TextButton(
                  onPressed: action,
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 12.size,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffacacac),
                        ),
                      ),
                      ImageIcon(
                        size: 18.size,
                        color: const Color(0xffacacac),
                        const AssetImage(
                          'assets/icon/right_dash_arrow_icon.png',
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _categoryListComponent() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        List<Category> categoryList = context.read<CategoryBloc>().categoryList;

        if (categoryState is CategoryLoadingState) {
          return UiRender.loadingCircle();
        }

        if (categoryState is CategoryLoadedState) {
          categoryList = categoryState.categoryList;
        }

        return Container(
          height: 90.height,
          margin: EdgeInsets.only(top: 20.height, bottom: 35.height),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return _categoryComponent(categoryList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _productList(String type) {
    return BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
      List<Product> productList = (type == 'HOT_DISCOUNT'
          ? context.read<ProductBloc>().hotDiscountProductList
          : type == 'NEW_ARRIVAL'
              ? context.read<ProductBloc>().newArrivalProductList
              : context.read<ProductBloc>().top8BestSellerProductList);
      if (productState is ProductLoadingState) {
        return UiRender.loadingCircle();
      }

      if (productState is! ProductErrorState &&
          productState is! ProductSearchingListLoadedState &&
          productState is! ProductLoadingState) {
        switch (type) {
          case 'HOT_DISCOUNT':
            {
              productList =
                  List.from(context.read<ProductBloc>().hotDiscountProductList);
              break;
            }
          case 'NEW_ARRIVAL':
            {
              productList =
                  List.from(context.read<ProductBloc>().newArrivalProductList);
              break;
            }
          case 'TOP_BEST_SELLERS':
            {
              productList = List.from(
                  context.read<ProductBloc>().top8BestSellerProductList);
              break;
            }
        }
      }

      if (productList.isEmpty) {
        return const Center(
          child: Text('NOT AVAILABLE!!'),
        );
      } else {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.65,
            crossAxisCount: 2,
            crossAxisSpacing: 20.height,
            mainAxisSpacing: 25.width,
          ),
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
        );
      }
    });
  }
}
