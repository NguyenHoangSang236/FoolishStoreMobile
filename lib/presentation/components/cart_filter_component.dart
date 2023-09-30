import 'package:fashionstore/presentation/components/checkbox_selection.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../data/enum/cart_enum.dart';
import 'gradient_button.dart';

class CartFilterComponent extends StatefulWidget {
  const CartFilterComponent({super.key});

  @override
  State<StatefulWidget> createState() => _CartFilterState();
}

class _CartFilterState extends State<CartFilterComponent> {
  final TextEditingController brandFilterController = TextEditingController();
  final List<String> filterOptionList = [
    CartEnum.SELECTED.name,
    CartEnum.DISCOUNT.name,
  ];
  final List<String> filterOptionTextList = [
    'Items you selected',
    'Items with discount',
  ];
  List<bool> checkBoxValueList = [
    false,
    false,
  ];
  List<String> resultFilterList = [];

  void onPressFilterButton() {
    BlocProvider.of<CartBloc>(context).add(
      OnFilterCartEvent(
        status: resultFilterList,
        brand: brandFilterController.text,
      ),
    );
  }

  void onPressClearFilterButton() {
    setState(() {
      resultFilterList.clear();
      brandFilterController.clear();
      checkBoxValueList = [false, false];
    });
    LoadingService(context).reloadCartPage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.width),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.width),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.radius),
              color: const Color(0xFFF1F1F1),
            ),
            child: TextField(
              controller: brandFilterController,
              style: TextStyle(
                fontFamily: 'Sen',
                fontWeight: FontWeight.w400,
                fontSize: 13.size,
                color: const Color(0xFF464646),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type the brand you want...',
                hintStyle: TextStyle(
                  fontFamily: 'Sen',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.size,
                  color: const Color(0xFFACACAC),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: filterOptionList.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  CheckBoxSelection(
                    checkValue: checkBoxValueList[index],
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          resultFilterList.add(filterOptionList[index]);
                        } else {
                          resultFilterList.removeWhere(
                            (element) => element == filterOptionList[index],
                          );
                        }

                        checkBoxValueList[index] = value!;
                      });
                    },
                    content: filterOptionTextList[index],
                  ),
                ],
              );
            },
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
    );
  }
}
