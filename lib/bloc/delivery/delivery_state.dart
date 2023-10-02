part of 'delivery_bloc.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();
}

class DeliveryInitial extends DeliveryState {
  @override
  List<Object> get props => [];
}

class DeliveryLoadingState extends DeliveryState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DeliveryTypeListLoadedState extends DeliveryState {
  final List<DeliveryType> deliveryTypeList;

  const DeliveryTypeListLoadedState(this.deliveryTypeList);

  @override
// TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DeliveryErrorState extends DeliveryState {
  final String message;

  const DeliveryErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
