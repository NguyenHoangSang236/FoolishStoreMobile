import 'package:auto_route/annotations.dart';
import 'package:fashionstore/data/entity/online_payment_info.dart';
import 'package:fashionstore/data/enum/payment_enum.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/invoice/invoice_bloc.dart';

@RoutePage()
class OnlinePaymentReceiverInfoPage extends StatefulWidget {
  const OnlinePaymentReceiverInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _OnlinePaymentReceiverInfoPageState();
}

class _OnlinePaymentReceiverInfoPageState
    extends State<OnlinePaymentReceiverInfoPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: false,
      textEditingController: _textEditingController,
      pageName: 'Online Payment',
      needSearchBar: false,
      needBottomNavBar: false,
      body: RefreshIndicator(
        color: Colors.orange,
        key: _refreshIndicatorKey,
        onRefresh: () async => BlocProvider.of<InvoiceBloc>(context).add(
          OnLoadOnlinePaymentInfoEvent(
            BlocProvider.of<InvoiceBloc>(context).currentAddedInvoiceId,
            BlocProvider.of<InvoiceBloc>(context).currentCheckoutPaymentMethod,
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.height,
              horizontal: 20.width,
            ),
            child: BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                OnlinePaymentInfo? paymentInfo =
                    BlocProvider.of<InvoiceBloc>(context)
                        .currentOnlinePaymentInfo;

                if (state is InvoiceOnlinePaymentInfoLoadedState) {
                  paymentInfo = state.onlinePaymentInfo;
                } else if (state is InvoiceLoadingState) {
                  return UiRender.loadingCircle();
                }

                return Column(
                  children: [
                    Text(
                      'Please transfer money according to the following information',
                      style: TextStyle(
                        color: const Color(0xFF6C6B71),
                        fontFamily: 'Work Sans',
                        fontSize: 13.size,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    15.verticalSpace,
                    _onlinePaymentInfoComponent(
                      'Payment method',
                      PaymentMethodEnum.values
                          .firstWhere(
                            (element) =>
                                element.name == paymentInfo?.receiverInfo!.type,
                          )
                          .name
                          .formatEnumToUppercaseFirstLetter,
                      false,
                    ),
                    paymentInfo?.receiverInfo?.type ==
                            PaymentMethodEnum.BANK_TRANSFER.name
                        ? _onlinePaymentInfoComponent(
                            'Bank name',
                            paymentInfo?.receiverInfo!.additionalInfo ??
                                'ERROR',
                            true,
                          )
                        : const SizedBox(),
                    _onlinePaymentInfoComponent(
                      'Account number',
                      paymentInfo?.receiverInfo!.receiverAccount ?? 'ERROR',
                      true,
                    ),
                    _onlinePaymentInfoComponent(
                      'Receiver name',
                      paymentInfo?.receiverInfo!.receiverName ?? 'ERROR',
                      true,
                    ),
                    _onlinePaymentInfoComponent(
                      'Message',
                      paymentInfo?.content ?? '',
                      true,
                    ),
                    _onlinePaymentInfoComponent(
                      'Total money amount',
                      paymentInfo?.moneyAmount!.format.dollar ?? '0.00',
                      true,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _onlinePaymentInfoComponent(
    String title,
    String content,
    bool isCopyable,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF6C6B71),
              fontFamily: 'Work Sans',
              fontSize: 13.size,
              fontWeight: FontWeight.w300,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 6.height,
              horizontal: 10.width,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.radius),
              border: Border.all(
                color: const Color(0xFFD6D3E1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.orange,
                    fontFamily: 'Work Sans',
                    fontSize: 14.size,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                isCopyable
                    ? SizedBox(
                        height: 20.size,
                        width: 20.size,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 15.size,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: content))
                                .then(
                              (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        'Copied \'$content\'',
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 30.width,
                                      vertical: 10.height,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.radius),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Image.asset(
                            'assets/icon/copy_icon.png',
                            height: 15.size,
                            width: 15.size,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
