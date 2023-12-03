import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/data/dto/invoice_filter.dart';
import 'package:fashionstore/data/entity/invoice.dart';
import 'package:fashionstore/service/loading_service.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/views/components/calendar.dart';
import 'package:fashionstore/views/components/invoice_component.dart';
import 'package:fashionstore/views/components/invoice_filter_component.dart';
import 'package:fashionstore/views/layout/layout.dart';
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
        context.read<InvoiceBloc>().currentInvoiceFilter.copyValues;

    if (isFromDate) {
      invoiceFilter.startInvoiceDate = selectedDate.dateOnly;
    } else {
      invoiceFilter.endInvoiceDate = selectedDate.dateOnly;
    }

    context.read<InvoiceBloc>().add(
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

  @override
  void initState() {
    _toDate = context.read<InvoiceBloc>().currentInvoiceFilter.endInvoiceDate ??
        DateTime.now();
    _fromDate =
        context.read<InvoiceBloc>().currentInvoiceFilter.startInvoiceDate ??
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
          physics: const AlwaysScrollableScrollPhysics(),
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
                      child: BlocConsumer<InvoiceBloc, InvoiceState>(
                        listener: (context, state) {
                          if (state is InvoiceErrorState) {
                            UiRender.showDialog(context, '', state.message);
                          } else if (state is InvoiceCanceledState) {
                            UiRender.showDialog(context, '', state.message);
                          }
                        },
                        builder: (context, state) {
                          bool isInvoiceFilterClear = context
                              .read<InvoiceBloc>()
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
                        context.read<InvoiceBloc>().currentInvoiceList;

                    if (state is InvoiceListFilteredState) {
                      invoiceList = state.invoiceList;
                    } else if (state is InvoiceLoadingState) {
                      return UiRender.loadingCircle();
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        invoiceList.length,
                        (index) =>
                            InvoiceComponent(invoice: invoiceList[index]),
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
}
