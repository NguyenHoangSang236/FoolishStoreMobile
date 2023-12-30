part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadNotificationList extends NotificationEvent {
  final int limit;
  final int page;
  final DateTime startDate;
  final DateTime endDate;

  const OnLoadNotificationList(
    this.limit,
    this.page,
    this.startDate,
    this.endDate,
  );
}

class OnSeenNotification extends NotificationEvent {
  final int notificationId;

  const OnSeenNotification(this.notificationId);
}
