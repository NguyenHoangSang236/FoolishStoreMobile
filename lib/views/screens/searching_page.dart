import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/productSearching/product_searching_bloc.dart';
import '../../data/entity/product.dart';
import '../../utils/render/ui_render.dart';
import '../../utils/service/loading_service.dart';
import '../layout/layout.dart';

@RoutePage()
class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final TextEditingController _searchingController = TextEditingController();
  final TextEditingController _translateController = TextEditingController();

  @override
  void dispose() {
    _searchingController.dispose();
    _translateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<ProductSearchingBloc>().add(OnClearProductResultsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      textEditingController: _searchingController,
      translatorEditingController: _translateController,
      pageName: "Product Searching",
      needBottomNavBar: false,
      isSearchable: true,
      hintSearchBarText: "What product do you want to search?",
      onSearch: (text) {
        if (text.isNotEmpty) {
          context
              .read<ProductSearchingBloc>()
              .add(OnSearchProductEvent(text, 1, 10));
        }

        if (_searchingController.text.isEmpty) {
          context
              .read<ProductSearchingBloc>()
              .add(const OnSearchProductEvent('', 1, 10));
        }
      },
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocListener<TranslatorBloc, TranslatorState>(
          listener: (context, translateState) {
            if (translateState is TranslatorLoadingState) {
              UiRender.showLoaderDialog(context);
            }

            if (translateState is TranslatorLoadedState) {
              context.router.pop();

              context
                  .read<ProductSearchingBloc>()
                  .add(OnSearchProductEvent(translateState.content, 1, 10));

              setState(() {
                _searchingController.text = translateState.content;
              });
            }
          },
          child: BlocBuilder<ProductSearchingBloc, ProductSearchingState>(
            builder: (context, productState) {
              List<Product> productList =
                  context.read<ProductSearchingBloc>().searchingProductList;

              if (productState is ProductSearchingListLoadedState) {
                productList = productState.productList;
              }

              if (productState is ProductSearchingLoadingState) {
                return UiRender.loadingCircle();
              }

              if (productList.isNotEmpty) {
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: productList.length,
                    padding: EdgeInsets.symmetric(horizontal: 10.width),
                    itemBuilder: (context, index) {
                      return _searchingResultComponent(productList[index]);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No result!'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _searchingResultComponent(Product product) {
    return GestureDetector(
      onTap: () {
        LoadingService(context).selectToViewProduct(product);

        context.router.pushNamed(AppRouterPath.productDetails);
      },
      child: Container(
        height: 90.height,
        padding: EdgeInsets.all(5.size),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: Row(
          children: [
            UiRender.buildCachedNetworkImage(
              context,
              product.image1 ?? '',
              height: 80.height,
              width: 75.width,
              margin: EdgeInsets.only(right: 8.width),
              borderRadius: BorderRadius.circular(8.radius),
            ),
            Expanded(
              child: Text(
                '${product.name} - Color: ${product.color}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xff868686),
                  fontFamily: 'Work Sans',
                  fontSize: 14.size,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
