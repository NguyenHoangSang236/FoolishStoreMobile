import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/invoice/invoice_bloc.dart';
import 'package:fashionstore/data/enum/admin_acceptance_enum.dart';
import 'package:fashionstore/data/enum/delivery_enum.dart';
import 'package:fashionstore/data/enum/payment_enum.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/views/components/checkbox_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dto/invoice_filter.dart';
import '../../service/loading_service.dart';
import 'gradient_button.dart';

class InvoiceFilterComponent extends StatefulWidget {
  const InvoiceFilterComponent({super.key});

  @override
  State<StatefulWidget> createState() => _InvoiceFilterState();
}

class _InvoiceFilterState extends State<InvoiceFilterComponent> {
  List<AdminAcceptanceEnum> adminAcceptanceEnumList =
      AdminAcceptanceEnum.values;
  List<PaymentMethodEnum> paymentMethodEnumList = PaymentMethodEnum.values;
  List<PaymentStatusEnum> paymentStatusEnumList = PaymentStatusEnum.values;
  List<DeliveryEnum> deliveryEnumList = DeliveryEnum.values;
  late InvoiceFilter invoiceFilter;

  void onPressCheckBox(Enum filterEnum) {
    setState(() {
      if (filterEnum is AdminAcceptanceEnum) {
        invoiceFilter.adminAcceptance = filterEnum.name;
      } else if (filterEnum is PaymentMethodEnum) {
        invoiceFilter.paymentMethod = filterEnum.name;
      } else if (filterEnum is PaymentStatusEnum) {
        invoiceFilter.paymentStatus = filterEnum.name;
      } else if (filterEnum is DeliveryEnum) {
        invoiceFilter.deliveryStatus = filterEnum.name;
      }
    });
  }

  void onPressFilterButton() {
    context.router.pop().then(
          (value) => context.read<InvoiceBloc>().add(
                OnFilterInvoiceEvent(invoiceFilter),
              ),
        );
  }

  void onPressClearFilterButton() {
    context.router.pop().then((value) {
      context.read<InvoiceBloc>().add(
            const OnClearInvoiceFilterEvent(),
          );

      LoadingService(context).reloadAndClearPurchaseHistoryPage();
    });
  }

  @override
  void initState() {
    invoiceFilter =
        context.read<InvoiceBloc>().currentInvoiceFilter?.copyValues ??
            InvoiceFilter();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.width, vertical: 20.height),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _invoiceFilterSection(
              'Admin\'s acceptance',
              adminAcceptanceEnumList,
              invoiceFilter.adminAcceptance ?? '',
            ),
            _invoiceFilterSection(
              'Payment status',
              paymentStatusEnumList,
              invoiceFilter.paymentStatus ?? '',
            ),
            _invoiceFilterSection(
              'Payment method',
              paymentMethodEnumList,
              invoiceFilter.paymentMethod ?? '',
            ),
            _invoiceFilterSection(
              'Delivery method',
              deliveryEnumList,
              invoiceFilter.deliveryStatus ?? '',
            ),
            GradientElevatedButton(
              text: 'Filter',
              textColor: Colors.white,
              onPress: onPressFilterButton,
              buttonMargin: EdgeInsets.only(bottom: 5.height, top: 30.height),
            ),
            GradientElevatedButton(
              border: Border.all(color: Colors.orange),
              borderColor: Colors.orange,
              backgroundColor: Colors.white,
              text: 'Clear filter',
              textColor: Colors.orange,
              onPress: onPressClearFilterButton,
              buttonMargin: EdgeInsets.only(bottom: 5.height, top: 10.height),
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceFilterSection(
    String title,
    List<Enum> contentEnumList,
    String filterSelection,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Sen',
              fontWeight: FontWeight.w600,
              fontSize: 16.size,
              color: const Color(0xFF464646),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: contentEnumList.length,
            itemBuilder: (context, index) {
              return CheckBoxSelection(
                checkValue: filterSelection == contentEnumList[index].name,
                onChanged: (value) => onPressCheckBox(contentEnumList[index]),
                content: contentEnumList[index]
                    .name
                    .formatEnumToUppercaseFirstLetter,
              );
            },
          ),
        ],
      ),
    );
  }

  List<bool> _generateBoolList(int length) {
    return List<bool>.generate(length, (index) => false);
  }
}
