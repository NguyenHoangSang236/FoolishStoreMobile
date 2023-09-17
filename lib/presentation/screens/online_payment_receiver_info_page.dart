import 'package:auto_route/annotations.dart';
import 'package:fashionstore/presentation/layout/layout.dart';
import 'package:flutter/material.dart';

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
      body: RefreshIndicator(
        color: Colors.orange,
        key: _refreshIndicatorKey,
        onRefresh: () async {},
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
