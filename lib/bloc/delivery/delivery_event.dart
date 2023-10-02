part of 'delivery_bloc.dart';

abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class OnLoadDeliveryTypeEvent extends DeliveryEvent {}
