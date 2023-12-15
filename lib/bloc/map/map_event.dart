part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnSuggestAddressEvent extends MapEvent {
  final String address;

  const OnSuggestAddressEvent(this.address);
}
