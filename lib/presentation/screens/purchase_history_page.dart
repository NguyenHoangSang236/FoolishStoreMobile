import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_config.dart';
import 'package:fashionstore/data/dto/invoice_filter.dart';
import 'package:fashionstore/data/entity/invoice.dart';
import 'package:fashionstore/presentation/components/calendar.dart';
import 'package:fashionstore/presentation/components/invoice_filter_component.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:side_sheet/side_sheet.dart';

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
  late DateTime _toDate;
  late DateTime _fromDate;

  void _onPressFilterButton() {
    SideSheet.left(
      context: context,
      width: MediaQuery.of(context).size.width * 3 / 5,
      body: const InvoiceFilterComponent(),
    );
  }

  void _onSelectFromDate(DateTime newSelectedDate) {
    setState(() {
      _fromDate = newSelectedDate;
    });

    _filterWithSelectedDate(newSelectedDate, true);
  }

  void _onSelectToDate(DateTime newSelectedDate) {
    setState(() {
      _toDate = newSelectedDate;
    });

    _filterWithSelectedDate(newSelectedDate, false);
  }

  void _filterWithSelectedDate(DateTime selectedDate, bool isFromDate) {
    InvoiceFilter invoiceFilter =
        BlocProvider.of<InvoiceBloc>(context).currentInvoiceFilter.copyValues;

    if (isFromDate) {
      invoiceFilter.startInvoiceDate = selectedDate.dateOnly;
    } else {
      invoiceFilter.endInvoiceDate = selectedDate.dateOnly;
    }

    BlocProvider.of<InvoiceBloc>(context).add(
      OnFilterInvoiceEvent(invoiceFilter),
    );
  }

  bool _isNewDateUpdatable(
      DateTime fromDate, DateTime toDate, String errorMessage) {
    if (fromDate.isBefore(toDate)) {
      return true;
    } else {
      UiRender.showDialog(context, '', errorMessage);

      return false;
    }
  }

  void _onTapInvoice(Invoice invoice) {
    context.router.push(InvoiceDetailsRoute(invoice: invoice));
  }

  @override
  void initState() {
    _toDate = BlocProvider.of<InvoiceBloc>(context)
            .currentInvoiceFilter
            .endInvoiceDate ??
        DateTime.now();
    _fromDate = BlocProvider.of<InvoiceBloc>(context)
            .currentInvoiceFilter
            .startInvoiceDate ??
        DateTime.parse('2020-01-01');

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
      needBottomNavBar: false,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.orange,
        onRefresh: () async =>
            LoadingService(context).reloadAndClearPurchaseHistoryPage(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.width,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20.size,
                      width: 20.size,
                      child: BlocBuilder<InvoiceBloc, InvoiceState>(
                        builder: (context, state) {
                          bool isInvoiceFilterClear =
                              BlocProvider.of<InvoiceBloc>(context)
                                  .currentInvoiceFilter
                                  .isClear();

                          return IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: _onPressFilterButton,
                            icon: ImageIcon(
                              const AssetImage(
                                'assets/icon/filter_icon.png',
                              ),
                              color: isInvoiceFilterClear
                                  ? const Color(0xff626262)
                                  : Colors.orange,
                              size: 20.size,
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Text('From'),
                            3.horizontalSpace,
                            Calendar(
                              selectedDate: _fromDate,
                              onSelectDate: _onSelectFromDate,
                              isNewDateUpdatable: (newDate) =>
                                  _isNewDateUpdatable(
                                newDate,
                                _toDate,
                                'This date must be before ${_toDate.date}',
                              ),
                            ),
                          ],
                        ),
                        3.verticalSpace,
                        Row(
                          children: [
                            const Text('to'),
                            3.horizontalSpace,
                            Calendar(
                              selectedDate: _toDate,
                              onSelectDate: _onSelectToDate,
                              isNewDateUpdatable: (newDate) =>
                                  _isNewDateUpdatable(
                                _fromDate,
                                newDate,
                                'This date must be after ${_fromDate.date}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                BlocConsumer<InvoiceBloc, InvoiceState>(
                  listener: (context, state) {
                    if (state is InvoiceErrorState) {
                      UiRender.showDialog(context, '', state.message);
                    }
                  },
                  builder: (context, state) {
                    List<Invoice> invoiceList =
                        BlocProvider.of<InvoiceBloc>(context)
                            .currentInvoiceList;

                    if (state is InvoiceListFilteredState) {
                      invoiceList = state.invoiceList;
                    } else if (state is InvoiceLoadingState) {
                      return UiRender.loadingCircle();
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _invoiceComponent(Invoice invoice) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.height),
      child: Material(
        borderRadius: BorderRadius.circular(10.radius),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.radius),
          splashColor: Colors.orange,
          onTap: () => _onTapInvoice(invoice),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                EdgeInsets.fromLTRB(10.width, 8.height, 10.width, 20.height),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.radius),
              color: Colors.transparent,
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
                  data: invoice.paymentStatus.formatEnumToUppercaseFirstLetter,
                ),
                _invoiceData(
                  title: 'Payment method',
                  data: invoice
                      .getPaymentMethod()
                      .formatEnumToUppercaseFirstLetter,
                ),
                _invoiceData(
                  title: 'Total price',
                  isPrice: true,
                  data: invoice.totalPrice.format.dollar,
                ),
              ],
            ),
          ),
        ),
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
