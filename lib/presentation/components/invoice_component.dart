import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_router/app_router_config.dart';
import '../../data/entity/invoice.dart';
import 'gradient_button.dart';

class InvoiceComponent extends StatefulWidget {
  const InvoiceComponent({super.key, required this.invoice});

  final Invoice invoice;

  @override
  State<StatefulWidget> createState() => _InvoiceComponentState();
}

class _InvoiceComponentState extends State<InvoiceComponent> {
  double _compHeight = 0;
  bool _isPressed = false;

  void _onPressViewDetails(Invoice invoice) {
    context.router.push(InvoiceDetailsRoute(invoice: invoice));
  }

  void _scaleUp() {
    setState(() {
      _compHeight = 60.height;
      _isPressed = true;
    });
  }

  void _scaleDown() {
    setState(() {
      _compHeight = 0;
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.height),
      child: Material(
        borderRadius: BorderRadius.circular(10.radius),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.radius),
          splashColor: Colors.orange,
          onTap: (_isPressed == true) ? _scaleDown : _scaleUp,
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
                  data: widget.invoice.id.toString(),
                  isHeader: true,
                ),
                10.verticalSpace,
                _invoiceData(
                  title: 'Invoice date',
                  data: widget.invoice.invoiceDate.dateTime,
                ),
                _invoiceData(
                  title: 'Payment status',
                  data: widget
                      .invoice.paymentStatus.formatEnumToUppercaseFirstLetter,
                ),
                _invoiceData(
                  title: 'Payment method',
                  data: widget.invoice
                      .getPaymentMethod()
                      .formatEnumToUppercaseFirstLetter,
                ),
                _invoiceData(
                  title: 'Total price',
                  isPrice: true,
                  data: widget.invoice.totalPrice.format.dollar,
                ),
                AnimatedSize(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: _compHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientElevatedButton(
                          text: 'View details',
                          buttonMargin: EdgeInsets.zero,
                          buttonWidth: 133.width,
                          buttonHeight: 35.height,
                          onPress: () => _onPressViewDetails(widget.invoice),
                        ),
                        GradientElevatedButton(
                          text: 'Cancel order',
                          buttonMargin: EdgeInsets.zero,
                          buttonWidth: 130.width,
                          buttonHeight: 35.height,
                          onPress: () {},
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
}
