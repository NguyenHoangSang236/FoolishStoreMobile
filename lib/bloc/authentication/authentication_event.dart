part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class OnLoginAuthenticationEvent extends AuthenticationEvent {
  final String userName;
  final String password;

  const OnLoginAuthenticationEvent(this.userName, this.password);
}

class OnUpdateNewAvatarAuthenticationEvent extends AuthenticationEvent {
  final String newFileId;

  const OnUpdateNewAvatarAuthenticationEvent(this.newFileId);
}

class OnLogoutAuthenticationEvent extends AuthenticationEvent {}

class OnRegisterAuthenticationEvent extends AuthenticationEvent {
  final String userName;
  final String password;
  final String name;
  final String email;
  final String phoneNumber;

  const OnRegisterAuthenticationEvent(
    this.userName,
    this.password,
    this.name,
    this.email,
    this.phoneNumber,
  );
}

class OnUpdateProfileAuthenticationEvent extends AuthenticationEvent {
  final String address;
  final String city;
  final String country;
  final String name;
  final String email;
  final String phoneNumber;

  const OnUpdateProfileAuthenticationEvent(
    this.address,
    this.city,
    this.country,
    this.name,
    this.email,
    this.phoneNumber,
  );
}
