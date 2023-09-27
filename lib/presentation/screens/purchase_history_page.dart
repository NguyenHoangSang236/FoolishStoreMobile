import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/data/entity/invoice.dart';
import 'package:fashionstore/presentation/components/gradient_button.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.width,
              vertical: 10.height,
            ),
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
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    invoiceList.length,
                    (index) => _invoiceComponent(invoiceList[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _invoiceComponent(Invoice invoice) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10.width, 8.height, 10.width, 20.height),
      margin: EdgeInsets.symmetric(vertical: 10.height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.radius),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _invoiceData(
            title: "Order ID",
            data: invoice.id.toString(),
            isHeader: true,
          ),
          10.verticalSpace,
          _invoiceData(
            title: 'Invoice date',
            data: invoice.invoiceDate.dateTime,
          ),
          _invoiceData(
            title: 'Payment status',
            data: invoice.paymentStatus,
          ),
          _invoiceData(
            title: 'Payment method',
            data: invoice.getPaymentMethod(),
          ),
          _invoiceData(
            title: 'Total price',
            isPrice: true,
            data: invoice.totalPrice.format.dollar,
          ),
          GradientElevatedButton(
            buttonMargin: EdgeInsets.only(top: 20.height),
            text: 'View details',
            onPress: () {},
          ),
        ],
      ),
    );
  }

  Widget _invoiceData({
    required String title,
    required String data,
    bool isHeader = false,
    bool isPrice = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.height),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontSize: isHeader ? 14.size : 12.size,
              fontWeight: FontWeight.w400,
              color: isHeader ? Colors.orange : Colors.black,
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontSize: isHeader ? 14.size : 12.size,
              fontWeight: FontWeight.w700,
              color: isHeader
                  ? Colors.orange
                  : isPrice
                      ? Colors.red
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoiceDataRow({required List<Widget> children}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
