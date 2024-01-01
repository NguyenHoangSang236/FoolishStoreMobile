import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/data/entity/invoice_item.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/views/layout/layout.dart';
import 'package:fashionstore/views/screens/photo_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/entity/invoice_details.dart';
import '../../data/entity/refund.dart';

@RoutePage()
class InvoiceDetailsPage extends StatefulWidget {
  const InvoiceDetailsPage({
    super.key,
    required this.invoiceId,
  });

  final int invoiceId;

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
          OnLoadInvoiceDetailsEvent(
            widget.invoiceId,
          ),
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
                'Invoice ID: ${widget.invoiceId}',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 30.size,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
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
        if (state is InvoiceDetailsLoadedState) {
          InvoiceDetails invoiceDetails = state.invoiceDetails;
          List<InvoiceItem> invoiceItemList = invoiceDetails.invoiceProducts;

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
                invoiceDetails.invoice.invoiceDate.dateTime,
              ),
              invoiceDetails.invoice.address != null &&
                      invoiceDetails.invoice.address!.isNotEmpty
                  ? _invoiceDataLine('Address', invoiceDetails.invoice.address!)
                  : const SizedBox(),
              invoiceDetails.invoice.delivery != null
                  ? _invoiceDataLine(
                      'Expected delivery time',
                      invoiceDetails
                          .invoice.delivery!.expectedDeliveryTime!.dateTime,
                    )
                  : const SizedBox(),
              invoiceDetails.invoice.delivery != null &&
                      invoiceDetails.invoice.delivery!.shipDate != null
                  ? _invoiceDataLine(
                      'Delivery date',
                      invoiceDetails.invoice.delivery!.shipDate!.dateTime,
                    )
                  : const SizedBox(),
              Divider(
                height: 30.height,
                color: Colors.grey,
              ),
              _invoiceDataLine(
                "Admin acceptance",
                invoiceDetails
                    .invoice.adminAcceptance.formatEnumToUppercaseFirstLetter,
              ),
              _invoiceDataLine(
                "Order status",
                invoiceDetails
                    .invoice.orderStatus!.formatEnumToUppercaseFirstLetter,
              ),
              _invoiceDataLine(
                "Payment method",
                invoiceDetails
                    .invoice.paymentMethod.formatEnumToUppercaseFirstLetter,
              ),
              _invoiceDataLine(
                "Payment status",
                invoiceDetails
                    .invoice.paymentStatus.formatEnumToUppercaseFirstLetter,
              ),
              invoiceDetails.invoice.reason != null &&
                      invoiceDetails.invoice.reason!.isNotEmpty
                  ? _invoiceDataLine(
                      'Reason',
                      invoiceDetails.invoice.reason ?? '',
                    )
                  : const SizedBox(),
              Divider(
                height: 30.height,
                color: Colors.grey,
              ),
              _invoiceDataLine(
                'Total items ($totalQuantity)',
                totalPrice.format.dollar,
              ),
              _invoiceDataLine(
                'Shipping price',
                invoiceDetails.invoice.deliveryFee.format.dollar,
              ),
              _invoiceDataLine(
                'Total price (${invoiceItemList.length})',
                invoiceDetails.invoice.totalPrice.format.dollar,
              ),
              invoiceDetails.invoice.payDate != null
                  ? _invoiceDataLine(
                      'Paid date',
                      invoiceDetails.invoice.payDate!.dateTime,
                    )
                  : const SizedBox(),
              invoiceDetails.invoice.refund != null
                  ? _refundSection(invoiceDetails.invoice.refund!)
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

  Widget _refundSection(Refund refund) {
    return Column(
      children: [
        Divider(
          height: 30.height,
          color: Colors.grey,
        ),
        _invoiceDataLine(
          'Refund status',
          refund.status.formatEnumToUppercaseFirstLetter,
        ),
        _invoiceDataLine(
          'Refund money',
          refund.refundMoney.format.dollar,
        ),
        refund.date != null
            ? _invoiceDataLine(
                'Refund date',
                refund.date!.dateTime,
              )
            : const SizedBox(),
        refund.evidentImage != null && refund.evidentImage!.isNotEmpty
            ? _invoiceDataLine(
                'Refund image',
                refund.evidentImage!,
                isImage: true,
              )
            : const SizedBox(),
      ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    // height: 150.height,
                    // width: 115.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.radius),
                    ),
                    child: UiRender.buildCachedNetworkImage(
                      context,
                      invoiceItem.image1,
                      height: 150.height,
                      borderRadius: BorderRadius.circular(8.radius),
                    ),
                  ),
                ),
                22.horizontalSpace,
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
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
                      Flexible(
                        child: Text(
                          _getColorAndSize(
                            invoiceItem.color,
                            invoiceItem.size,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.size,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF797780),
                          ),
                        ),
                      ),
                      Flexible(
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
                                      fontSize: 25.size,
                                      color: Colors.red,
                                    ),
                                  ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'x',
                                  style: TextStyle(
                                    fontSize: 17.size,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Imprima',
                                  ),
                                ),
                                Text(
                                  '${invoiceItem.quantity}',
                                  style: TextStyle(
                                    fontSize: 26.size,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _invoiceDataLine(
    String title,
    String content, {
    bool isImage = false,
  }) {
    if (isImage) print(content);

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
            child: isImage
                ? GestureDetector(
                    onTap: () => context.router.pushWidget(
                      PhotoViewPage(url: content),
                    ),
                    child: UiRender.buildCachedNetworkImage(
                      context,
                      content,
                      height: 200.height,
                    ),
                  )
                : Text(
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
