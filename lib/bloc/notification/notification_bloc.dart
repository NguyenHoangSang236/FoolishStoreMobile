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

  List<Notification> currentNotificationList = [];
  int currentPage = 1;
  int currentLimit = 10;
  int currentSeenNotificationId = 0;

  DateTime currentStartDate = DateTime(2023, 01, 01);
  DateTime currentEndDate = DateTime.now();

  NotificationBloc(this._notificationRepository)
      : super(NotificationInitial()) {
    on<OnLoadNotificationListEvent>((event, emit) async {
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
            if (currentEndDate == event.endDate &&
                currentStartDate == event.startDate) {
              currentNotificationList = List.of(list);

              // currentNotificationList = _removeDuplicate(
              //   [...currentNotificationList, ...list],
              // );
            } else {
              currentStartDate = event.startDate;
              currentEndDate = event.endDate;

              currentNotificationList = list;
            }

            currentPage = event.page;
            currentLimit = event.limit;

            emit(NotificationListLoadedState(currentNotificationList));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(NotificationErrorState(e.toString()));
      }
    });

    on<OnLoadNextPageEvent>((event, emit) async {
      emit(NotificationLoadingState());

      try {
        final response = await _notificationRepository.getNotificationList(
          {
            'filter': {
              'startDate': currentStartDate.dateApiFormat,
              'endDate': currentEndDate.dateApiFormat,
            },
            'pagination': {
              'page': currentPage + 1,
              'limit': currentLimit,
            },
          },
        );

        response.fold(
          (failure) => emit(NotificationErrorState(failure.message)),
          (list) {
            currentPage++;

            currentNotificationList = _removeDuplicate(
              [...currentNotificationList, ...list],
            );

            emit(NotificationListLoadedState(currentNotificationList));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(NotificationErrorState(e.toString()));
      }
    });

    on<OnSeenNotificationEvent>((event, emit) async {
      emit(NotificationLoadingState());

      try {
        final response = await _notificationRepository.seenNotification(
          event.notificationId,
        );

        response.fold(
          (failure) => emit(NotificationErrorState(failure.message)),
          (success) {
            currentSeenNotificationId = event.notificationId;

            emit(NotificationSeenState(success));
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
