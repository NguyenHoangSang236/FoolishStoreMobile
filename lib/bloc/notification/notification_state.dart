part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadingState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationListLoadedState extends NotificationState {
  final List<Notification> notificationList;

  const NotificationListLoadedState(this.notificationList);

  @override
  List<Object> get props => [notificationList];
}

class NotificationSeenState extends NotificationState {
  final String message;

  const NotificationSeenState(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState(this.message);

  @override
  List<Object> get props => [message];
}
