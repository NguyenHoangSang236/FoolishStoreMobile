part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadNotificationListEvent extends NotificationEvent {
  final int limit;
  final int page;
  final DateTime startDate;
  final DateTime endDate;

  const OnLoadNotificationListEvent(
    this.limit,
    this.page,
    this.startDate,
    this.endDate,
  );
}

class OnLoadNextPageEvent extends NotificationEvent {}

class OnSeenNotificationEvent extends NotificationEvent {
  final int notificationId;

  const OnSeenNotificationEvent(this.notificationId);
}
