import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/data/entity/invoice.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadAndClearPurchaseHistoryPage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: false,
      textEditingController: _textEditingController,
      pageName: 'Purchase History',
      needSearchBar: false,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async =>
            LoadingService(context).reloadAndClearPurchaseHistoryPage(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: BlocConsumer<InvoiceBloc, InvoiceState>(
            listener: (context, state) {
              if (state is InvoiceLoadingState) {
                UiRender.showLoaderDialog(context);
              } else if (state is InvoiceListFilteredState) {
                context.router.pop();
              }
            },
            builder: (context, state) {
              List<Invoice> invoiceList =
                  BlocProvider.of<InvoiceBloc>(context).currentInvoiceList;

              if (state is InvoiceListFilteredState) {
                invoiceList = state.invoiceList;
              }

              return Column(
                children: [],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _invoiceComponent(Invoice invoice) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.width, 8.height, 10.width, 20.height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.radius),
        color: Colors.white,
      ),
    );
  }
}
