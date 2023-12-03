import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/config/app_router/app_router_path.dart';
import 'package:fashionstore/data/enum/local_storage_key_enum.dart';
import 'package:fashionstore/views/components/gradient_button.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/local_storage/local_storage_service.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _fullNameTextEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  bool isPasswordHiden = true;
  bool isConfirmPasswordHiden = true;
  bool isLogin = true;
  bool isRememberPassword = false;

  Future<void> _initLocalStorageValues() async {
    _userNameTextEditingController.text =
        await LocalStorageService.getLocalStorageData(
            LocalStorageKeyEnum.SAVED_USER_NAME.name) as String;
    _passwordTextEditingController.text =
        await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_PASSWORD.name,
    ) as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_userNameTextEditingController.text != '' &&
            _passwordTextEditingController.text != '') {
          isRememberPassword = true;
        }
      });
    });
  }

  @override
  void initState() {
    _initLocalStorageValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.width, 35.height, 20.width, 25.height),
        child: Container(
          height: MediaQuery.of(context).size.height - 60.height,
          padding:
              EdgeInsets.fromLTRB(30.width, 20.height, 30.width, 25.height),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.radius),
          ),
          child: isLogin
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image/login_image.png',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontFamily: 'Trebuchet MS',
                          fontWeight: FontWeight.w400,
                          fontSize: 21.size,
                          height: 4.height,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Foolish',
                        style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.5,
                            color: Colors.orange),
                      ),
                      _textField(
                        'User Name',
                        false,
                        _userNameTextEditingController,
                      ),
                      _textField(
                        'Password',
                        true,
                        _passwordTextEditingController,
                        isShowed: isPasswordHiden,
                      ),
                      10.verticalSpace,
                      _radioTextButton('Remember password'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientElevatedButton(
                            borderRadiusIndex: 25.radius,
                            borderColor:
                                isLogin ? Colors.transparent : Colors.black,
                            text: 'Login',
                            textWeight: FontWeight.w400,
                            buttonWidth: 125.width,
                            buttonHeight: 45.height,
                            beginColor: isLogin ? Colors.black : Colors.white,
                            endColor: isLogin
                                ? const Color(0xff727272)
                                : Colors.white,
                            textColor: isLogin ? Colors.white : Colors.black,
                            onPress: () {
                              setState(
                                () {
                                  if (isLogin == false) {
                                    isLogin = true;
                                  } else {
                                    if (_userNameTextEditingController
                                            .text.isNotEmpty &&
                                        _passwordTextEditingController
                                            .text.isNotEmpty) {
                                      LocalStorageService.setLocalStorageData(
                                        LocalStorageKeyEnum
                                            .SAVED_USER_NAME.name,
                                        _userNameTextEditingController.text,
                                      );
                                      LocalStorageService.setLocalStorageData(
                                        LocalStorageKeyEnum.SAVED_PASSWORD.name,
                                        _passwordTextEditingController.text,
                                      );
                                      context.router.replaceNamed(
                                          AppRouterPath.initialLoading);
                                    } else {
                                      UiRender.showDialog(
                                        context,
                                        '',
                                        'User Name or Password is empty, please fill in all the boxes !!',
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          GradientElevatedButton(
                              borderRadiusIndex: 25.radius,
                              borderColor:
                                  !isLogin ? Colors.transparent : Colors.black,
                              text: 'Register',
                              textWeight: FontWeight.w400,
                              buttonWidth: 125.width,
                              buttonHeight: 45.height,
                              beginColor: !isLogin ? Colors.black : null,
                              endColor:
                                  !isLogin ? const Color(0xff727272) : null,
                              backgroundColor: isLogin ? Colors.white : null,
                              textColor: !isLogin ? Colors.white : Colors.black,
                              onPress: () {
                                setState(() {
                                  if (isLogin == true) {
                                    _userNameTextEditingController.clear();
                                    _passwordTextEditingController.clear();
                                    isPasswordHiden = true;
                                    isLogin = false;
                                  }
                                });
                              })
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontSize: 14.size,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, authenState) {
                    if (authenState is AuthenticationLoadingState) {
                      UiRender.showLoaderDialog(context);
                    } else if (authenState is AuthenticationRegisteredState) {
                      context.router.pop();
                      UiRender.showDialog(context, '', authenState.message)
                          .then((value) {
                        UiRender.showDialog(context, '',
                            'Please sign in to enjoy our application!');
                        setState(() {
                          isLogin = true;
                        });
                      });
                    } else if (authenState is AuthenticationErrorState) {
                      context.router.pop();
                      UiRender.showDialog(context, '', authenState.message);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 3,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Welcome new customer of',
                                style: TextStyle(
                                  fontFamily: 'Trebuchet MS',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 21.size,
                                  height: 4.height,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Foolish',
                                style: TextStyle(
                                  fontFamily: 'Trebuchet MS',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25.size,
                                  height: 1.5.height,
                                  color: Colors.orange,
                                ),
                              ),
                              _textField(
                                'Full Name',
                                false,
                                _fullNameTextEditingController,
                              ),
                              _textField(
                                'Email',
                                false,
                                _emailTextEditingController,
                              ),
                              _textField(
                                'Phone Number',
                                false,
                                _phoneNumberTextEditingController,
                              ),
                              _textField(
                                'User Name',
                                false,
                                _userNameTextEditingController,
                              ),
                              _textField(
                                'Password',
                                true,
                                _passwordTextEditingController,
                                isShowed: isPasswordHiden,
                              ),
                              _textField(
                                'Confirm Password',
                                true,
                                _confirmPasswordTextEditingController,
                                isShowed: isConfirmPasswordHiden,
                              ),
                              10.verticalSpace
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientElevatedButton(
                            borderRadiusIndex: 25.radius,
                            borderColor:
                                isLogin ? Colors.transparent : Colors.black,
                            text: 'Login',
                            textWeight: FontWeight.w400,
                            buttonWidth: 125.width,
                            buttonHeight: 45.height,
                            beginColor: isLogin ? Colors.black : null,
                            endColor: isLogin ? const Color(0xff727272) : null,
                            backgroundColor: !isLogin ? Colors.white : null,
                            textColor: isLogin ? Colors.white : Colors.black,
                            onPress: () {
                              setState(
                                () {
                                  if (isLogin == false) {
                                    _userNameTextEditingController.clear();
                                    _passwordTextEditingController.clear();
                                    isPasswordHiden = true;
                                    isLogin = true;
                                  }
                                },
                              );
                            },
                          ),
                          GradientElevatedButton(
                            borderRadiusIndex: 25.radius,
                            borderColor:
                                !isLogin ? Colors.transparent : Colors.black,
                            text: 'Register',
                            textWeight: FontWeight.w400,
                            buttonWidth: 125.width,
                            buttonHeight: 45.height,
                            beginColor: !isLogin ? Colors.black : Colors.white,
                            endColor: !isLogin
                                ? const Color(0xff727272)
                                : Colors.white,
                            textColor: !isLogin ? Colors.white : Colors.black,
                            onPress: () {
                              setState(
                                () {
                                  if (isLogin == true) {
                                    isLogin = false;
                                  } else {
                                    if ((_userNameTextEditingController.text != '' &&
                                            _passwordTextEditingController
                                                    .text !=
                                                '' &&
                                            _fullNameTextEditingController
                                                    .text !=
                                                '' &&
                                            _emailTextEditingController.text !=
                                                '' &&
                                            _phoneNumberTextEditingController
                                                    .text !=
                                                '' &&
                                            _confirmPasswordTextEditingController
                                                    .text !=
                                                '') &&
                                        (_confirmPasswordTextEditingController
                                                .text ==
                                            _passwordTextEditingController
                                                .text)) {
                                      context.read<AuthenticationBloc>().add(
                                            OnRegisterAuthenticationEvent(
                                              _userNameTextEditingController
                                                  .text,
                                              _passwordTextEditingController
                                                  .text,
                                              _fullNameTextEditingController
                                                  .text,
                                              _emailTextEditingController.text,
                                              _phoneNumberTextEditingController
                                                  .text,
                                            ),
                                          );
                                    } else if (_confirmPasswordTextEditingController
                                            .text !=
                                        _passwordTextEditingController.text) {
                                      UiRender.showDialog(
                                        context,
                                        '',
                                        'Confirm Password is incorrect, please confirm your password again!',
                                      );
                                    } else {
                                      UiRender.showDialog(
                                        context,
                                        '',
                                        'Must fill in all boxes!',
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _radioTextButton(String content) {
    return Row(
      children: [
        SizedBox(
          width: 24.width,
          height: 24.height,
          child: Checkbox(
              activeColor: Colors.white,
              checkColor: Colors.orange,
              value: isRememberPassword,
              onChanged: (value) {
                setState(() {
                  if (value == true &&
                      (_userNameTextEditingController.text != '' &&
                          _passwordTextEditingController.text != '')) {
                    LocalStorageService.setLocalStorageData(
                      LocalStorageKeyEnum.SAVED_USER_NAME.name,
                      _userNameTextEditingController.text,
                    );

                    LocalStorageService.setLocalStorageData(
                      LocalStorageKeyEnum.SAVED_PASSWORD.name,
                      _passwordTextEditingController.text,
                    );

                    isRememberPassword = true;
                  } else if (_userNameTextEditingController.text == '' ||
                      _passwordTextEditingController.text == '') {
                    UiRender.showDialog(
                        context, '', 'Please input User Name and Password!');
                    isRememberPassword = false;
                  } else {
                    isRememberPassword = false;

                    LocalStorageService.removeLocalStorageData(
                      LocalStorageKeyEnum.SAVED_USER_NAME.name,
                    );

                    LocalStorageService.removeLocalStorageData(
                      LocalStorageKeyEnum.SAVED_PASSWORD.name,
                    );
                  }
                });
              }),
        ),
        Text(
          ' $content',
          style: TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w400,
            fontSize: 15.size,
            color: const Color(0xffc4c4c4),
          ),
        )
      ],
    );
  }

  Widget _textField(String hintText, bool isPassword,
      TextEditingController textEditingController,
      {bool isShowed = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.height),
      child: TextField(
        controller: textEditingController,
        obscureText: isShowed,
        decoration: InputDecoration(
          suffixIcon: isPassword == true
              ? IconButton(
                  onPressed: () {
                    if (isShowed == true) {
                      setState(() {
                        if (hintText == 'Password') {
                          isPasswordHiden = false;
                        } else if (hintText == 'Confirm Password') {
                          isConfirmPasswordHiden = false;
                        }
                      });
                    } else {
                      setState(() {
                        if (hintText == 'Password') {
                          isPasswordHiden = true;
                        } else if (hintText == 'Confirm Password') {
                          isConfirmPasswordHiden = true;
                        }
                      });
                    }
                  },
                  icon: Icon(
                    isShowed ? Icons.visibility : Icons.visibility_off_outlined,
                    color: const Color(0xffc4c4c4),
                  ),
                )
              : const SizedBox(),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w400,
            fontSize: 15.size,
            color: const Color(0xffc4c4c4),
          ),
        ),
      ),
    );
  }
}
