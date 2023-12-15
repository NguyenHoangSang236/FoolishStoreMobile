part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

class MapLoadingState extends MapState {
  @override
  List<Object> get props => [];
}

class AddressSuggestedState extends MapState {
  final List<Place> suggestionAddressList;

  const AddressSuggestedState(this.suggestionAddressList);

  @override
  List<Object> get props => [suggestionAddressList];
}

class MapErrorState extends MapState {
  final String message;

  const MapErrorState(this.message);

  @override
  List<Object> get props => [message];
}
