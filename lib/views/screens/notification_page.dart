import 'package:auto_route/annotations.dart';
import 'package:fashionstore/data/entity/notification.dart' as noti;
import 'package:fashionstore/service/loading_service.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/views/components/notification_component.dart';
import 'package:fashionstore/views/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/notification/notification_bloc.dart';
import '../../utils/render/ui_render.dart';
import '../components/calendar.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late DateTime _toDate;
  late DateTime _fromDate;

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      _scrollController.jumpTo(_scrollController.offset - 10.height);

      Future.delayed(
        const Duration(milliseconds: 700),
        () => context.read<NotificationBloc>().add(OnLoadNextPageEvent()),
      );
    }
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
    context.read<NotificationBloc>().add(
          OnLoadNotificationListEvent(
            10,
            1,
            isFromDate ? selectedDate : _fromDate,
            isFromDate ? _toDate : selectedDate,
          ),
        );
  }

  @override
  void initState() {
    _toDate = context.read<NotificationBloc>().currentEndDate;
    _fromDate = context.read<NotificationBloc>().currentStartDate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);

      LoadingService(context).reloadNotificationPage();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: true,
      pageName: 'Notification',
      needSearchBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          LoadingService(context).reloadNotificationPage();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('From'),
                  5.horizontalSpace,
                  Calendar(
                    selectedDate: _fromDate,
                    onSelectDate: _onSelectFromDate,
                    isNewDateUpdatable: (newDate) => _isNewDateUpdatable(
                      newDate,
                      _toDate,
                      'This date must be before ${_toDate.date}',
                    ),
                  ),
                  5.verticalSpace,
                  const Text(' to'),
                  5.horizontalSpace,
                  Calendar(
                    selectedDate: _toDate,
                    onSelectDate: _onSelectToDate,
                    isNewDateUpdatable: (newDate) => _isNewDateUpdatable(
                      _fromDate,
                      newDate,
                      'This date must be after ${_fromDate.date}',
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              BlocConsumer<NotificationBloc, NotificationState>(
                listener: (context, state) {},
                builder: (context, state) {
                  List<noti.Notification> notiList =
                      context.read<NotificationBloc>().currentNotificationList;

                  if (state is NotificationListLoadedState) {
                    notiList = state.notificationList;
                  }

                  return Column(
                    children: List.generate(
                      notiList.length,
                      (index) => NotificationComponent(
                        notification: notiList[index],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
