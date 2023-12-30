import 'package:auto_route/annotations.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/data/entity/invoice.dart';
import 'package:fashionstore/data/entity/invoice_item.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/views/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class InvoiceDetailsPage extends StatefulWidget {
  const InvoiceDetailsPage({
    super.key,
    required this.invoice,
  });

  final Invoice invoice;

  @override
  State<StatefulWidget> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetailsPage>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _getColorAndSize(String? color, String? size) {
    String rsColor =
        (color != null && color.isNotEmpty && color.toLowerCase() != 'none')
            ? 'Color: $color'
            : '';
    String rsSize =
        (size != null && size.isNotEmpty && size.toLowerCase() != 'none')
            ? 'Size: ${size.toUpperCase()} '
            : '';

    return '$rsColor\n$rsSize';
  }

  @override
  void initState() {
    context.read<InvoiceBloc>().add(
          OnLoadInvoiceDetailsEvent(widget.invoice.id),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      textEditingController: _textEditingController,
      pageName: 'Invoice Details',
      needSearchBar: false,
      needBottomNavBar: false,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice ID: ${widget.invoice.id}',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 30.size,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _invoiceItemListAndOtherData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceItemListAndOtherData() {
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        if (state is InvoiceErrorState) {
          UiRender.showDialog(context, '', state.message);
        }
      },
      builder: (context, state) {
        if (state is InvoiceItemListLoadedState) {
          List<InvoiceItem> invoiceItemList = state.invoiceItemList;

          double totalPrice = 0;
          int totalQuantity = 0;

          for (InvoiceItem item in invoiceItemList) {
            totalPrice += item.totalPriceAfterDiscount();
            totalQuantity += item.quantity;
          }

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: invoiceItemList.length,
                itemBuilder: (context, index) {
                  return _invoiceItem(invoiceItemList[index]);
                },
              ),
              const Divider(
                color: Color(0xFFE3E3E3),
                thickness: 1,
              ),
              20.verticalSpace,
              _invoiceDataLine(
                "Invoice date",
                widget.invoice.invoiceDate.dateTime,
              ),
              _invoiceDataLine(
                "Payment method",
                widget.invoice.paymentMethod.formatEnumToUppercaseFirstLetter,
              ),
              _invoiceDataLine(
                "Payment status",
                widget.invoice.paymentStatus.formatEnumToUppercaseFirstLetter,
              ),
              widget.invoice.reason != null && widget.invoice.reason!.isNotEmpty
                  ? _invoiceDataLine(
                      'Reason',
                      widget.invoice.reason ?? '',
                    )
                  : const SizedBox(),
              _invoiceDataLine(
                'Total items ($totalQuantity)',
                totalPrice.format.dollar,
              ),
              _invoiceDataLine(
                'Shipping price',
                widget.invoice.deliveryFee.format.dollar,
              ),
              _invoiceDataLine(
                'Total price (${invoiceItemList.length})',
                widget.invoice.totalPrice.format.dollar,
              ),
              widget.invoice.address != null &&
                      widget.invoice.address!.isNotEmpty
                  ? _invoiceDataLine('Address', widget.invoice.address!)
                  : const SizedBox(),
            ],
          );
        } else if (state is InvoiceLoadingState) {
          return UiRender.loadingCircle();
        }

        return const SizedBox();
      },
    );
  }

  Widget _invoiceItem(InvoiceItem invoiceItem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 18.height),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.orange,
          borderRadius: BorderRadius.circular(16.radius),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(10.size),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 150.height,
                  width: 115.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.radius),
                  ),
                  child: UiRender.buildCachedNetworkImage(
                    context,
                    invoiceItem.image1,
                    margin: EdgeInsets.only(right: 10.width),
                    width: 81.width,
                    height: 93.height,
                    borderRadius: BorderRadius.circular(8.radius),
                  ),
                ),
                22.horizontalSpace,
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 150.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            invoiceItem.name,
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18.size,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _getColorAndSize(
                                invoiceItem.color, invoiceItem.size),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.size,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF797780),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              invoiceItem.discount > 0
                                  ? RichText(
                                      text: TextSpan(
                                        text: invoiceItem
                                            .priceAfterDiscount()
                                            .format
                                            .dollar,
                                        style: TextStyle(
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 25.size,
                                          color: Colors.red,
                                        ),
                                        children: [
                                          const TextSpan(text: ' '),
                                          TextSpan(
                                            text: invoiceItem
                                                .sellingPrice.format.dollar,
                                            style: TextStyle(
                                              fontFamily: 'Sen',
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.size,
                                              color: const Color(0xffacacac),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      invoiceItem.sellingPrice.format.dollar,
                                      style: TextStyle(
                                        fontFamily: 'Sen',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 26.size,
                                        color: Colors.red,
                                        height: 1.5.height,
                                      ),
                                    ),
                              // Text(
                              //   invoiceItem.sellingPrice.format.dollar,
                              //   style: TextStyle(
                              //     fontSize: 26.size,
                              //     fontWeight: FontWeight.w500,
                              //     fontFamily: 'Imprima',
                              //     color: Colors.red,
                              //   ),
                              // ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${invoiceItem.quantity}',
                                    style: TextStyle(
                                      fontSize: 26.size,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Imprima',
                                    ),
                                  ),
                                  Text(
                                    'x',
                                    style: TextStyle(
                                      height: 0.8,
                                      fontSize: 17.size,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Imprima',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _invoiceDataLine(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.size,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF797780),
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 18.size,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
