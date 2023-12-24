import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/user.dart';
import '../../data/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  User? currentUser;
  String registerMessage = '';
  String logoutMessage = '';

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<OnLoginAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      try {
        final response = await _authenticationRepository.login(
          event.userName,
          event.password,
        );

        // final jwtFromStorage = await LocalStorageService.getLocalStorageData(
        //   LocalStorageKeyEnum.SAVED_JWT.name,
        // ) as String;

        response.fold(
          (failure) => emit(AuthenticationErrorState(failure.message)),
          (user) async {
            currentUser = user;

            // stompClient = StompClient(
            //   config: StompConfig(
            //     useSockJS: true,
            //     url: 'https://$domain:8080/wsNotificationEndPoint',
            //     onConnect: WebSocketConfig.onConnect,
            //     beforeConnect: WebSocketConfig.beforeConnect,
            //     onStompError: WebSocketConfig.onStompError,
            //     // onWebSocketDone: WebSocketConfig.onWebSocketDone,
            //     onWebSocketError: WebSocketConfig.onWebSocketError,
            //     stompConnectHeaders: {
            //       "Authorization": "Bearer $jwtFromStorage",
            //       "Upgrade": "websocket",
            //     },
            //     webSocketConnectHeaders: {
            //       "Authorization": "Bearer $jwtFromStorage",
            //       "Upgrade": "websocket",
            //     },
            //   ),
            // );
            //
            // stompClient.activate();

            emit(AuthenticationLoggedInState(user));
          },
        );
      } catch (e) {
        emit(AuthenticationErrorState(e.toString()));
      }
    });

    on<OnRegisterAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      try {
        final response = await _authenticationRepository.register(
          event.userName,
          event.password,
          event.name,
          event.email,
          event.phoneNumber,
        );

        response.fold(
          (failure) {
            registerMessage = failure.message;
            emit(AuthenticationRegisteredState(failure.message));
          },
          (success) {
            registerMessage = success;
            emit(AuthenticationErrorState(success));
          },
        );
      } catch (e) {
        emit(AuthenticationErrorState(e.toString()));
      }
    });

    on<OnUpdateNewAvatarAuthenticationEvent>((event, emit) {
      currentUser?.avatar = event.newFileId;
      emit(AuthenticationAvatarUpdatedState(event.newFileId));
    });

    on<OnLogoutAuthenticationEvent>((event, emit) async {
      emit(AuthenticationLoadingState());

      final response = await _authenticationRepository.logout();

      response.fold(
        (failure) {
          registerMessage = failure.message;
          emit(AuthenticationErrorState(failure.message));
        },
        (success) async {
          registerMessage = success;
          currentUser = null;

          emit(AuthenticationLoggedOutState(success));
        },
      );
    });
  }
}
