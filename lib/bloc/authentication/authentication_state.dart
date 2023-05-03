part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoadingState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoggedInState extends AuthenticationState {
  final User currentUser;

  const AuthenticationLoggedInState(this.currentUser);

  @override
  List<Object> get props => [currentUser];
}

class AuthenticationRegisteredState extends AuthenticationState {
  final String message;

  const AuthenticationRegisteredState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthenticationErrorState extends AuthenticationState {
  final String message;

  const AuthenticationErrorState(this.message);

  @override
  List<Object> get props => [message];
}