import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:flutter/foundation.dart';

import '../../data/entity/notification.dart';
import '../../data/repository/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  List<Notification> _currentNotificationList = [];
  int _currentPage = 1;

  DateTime _currentStartDate = DateTime(2023, 01, 01);
  DateTime _currentEndDate = DateTime.now();

  NotificationBloc(this._notificationRepository)
      : super(NotificationInitial()) {
    on<OnLoadNotificationList>((event, emit) async {
      emit(NotificationLoadingState());

      try {
        final response = await _notificationRepository.getNotificationList(
          {
            'filter': {
              'startDate': event.startDate.dateApiFormat,
              'endDate': event.endDate.dateApiFormat,
            },
            'pagination': {
              'page': event.page,
              'limit': event.limit,
            },
          },
        );

        response.fold(
          (failure) => emit(NotificationErrorState(failure.message)),
          (list) {
            _currentPage = event.page;
            _currentStartDate = event.startDate;
            _currentEndDate = event.endDate;

            _currentNotificationList = _removeDuplicate(
              [..._currentNotificationList, ...list],
            );

            emit(NotificationListLoadedState(_currentNotificationList));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(NotificationErrorState(e.toString()));
      }
    });
  }

  List<Notification> _removeDuplicate(List<Notification> invoiceList) {
    Set<int> set = {};
    List<Notification> uniqueList =
        invoiceList.where((element) => set.add(element.id)).toList();

    return uniqueList;
  }
}
