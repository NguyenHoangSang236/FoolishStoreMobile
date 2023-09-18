import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enum/local_storage_key_enum.dart';
import '../../utils/local_storage/local_storage_service.dart';

@RoutePage()
class InitialLoadingPage extends StatefulWidget {
  const InitialLoadingPage({super.key});

  @override
  State<StatefulWidget> createState() => _InitialLoadingState();
}

class _InitialLoadingState extends State<InitialLoadingPage> {
  String _savedUserName = '';
  String _savedPassword = '';

  Future<void> _loginEvent() async {
    _savedUserName = await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_USER_NAME.name,
    ) as String;
    _savedPassword = await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_PASSWORD.name,
    ) as String;

    BlocProvider.of<AuthenticationBloc>(context).add(
      OnLoginAuthenticationEvent(
        _savedUserName,
        _savedPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loginEvent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, authenState) {
                if (authenState is AuthenticationLoggedInState) {
                  context.router.replaceNamed(AppRouterPath.index);
                } else if (authenState is AuthenticationErrorState) {
                  context.router.replaceNamed(AppRouterPath.login);
                }
              },
              child: SizedBox(
                height: 130.size,
                width: 130.size,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 130.size,
                        width: 130.size,
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
                          strokeWidth: 6.width,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Foolish',
                        style: TextStyle(
                          fontFamily: 'Trebuchet MS',
                          fontWeight: FontWeight.w900,
                          fontSize: 25.size,
                          height: 1.5.height,
                          color: const Color(0xffff8401),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
