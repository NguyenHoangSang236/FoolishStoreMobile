import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/data/static/global_variables.dart';
import 'package:fashionstore/presentation/components/gradient_button.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/entity/user.dart';
import '../layout/layout.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isPasswordHiddened = true;

  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.PROFILE.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      hintSearchBarText: 'What product are you looking for?',
      textEditingController: _textEditingController,
      needSearchBar: false,
      needBottomNavBar: false,
      body: RefreshIndicator(
        onRefresh: () async {},
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: MultiBlocListener(
          listeners: [
            BlocListener<UploadFileBloc, UploadFileState>(
              listener: (context, uploadFileState) {
                if (uploadFileState is UploadFileUploadingState) {
                  UiRender.showLoaderDialog(context);
                }

                if (uploadFileState is UploadFileUploadedState) {
                  context.router.pop();

                  UiRender.showDialog(
                    context,
                    '',
                    'Uploaded image successfully!',
                  ).then(
                    (value) {
                      context.read<AuthenticationBloc>().currentUser?.avatar =
                          ValueRender.getFileIdFromGoogleDriveViewUrl(
                        uploadFileState.url,
                      );
                    },
                  );
                }

                if (uploadFileState is UploadFileErrorState) {
                  UiRender.showDialog(context, '', uploadFileState.message);
                }
              },
            ),
          ],
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, authenState) {
              User? currentUser =
                  context.read<AuthenticationBloc>().currentUser;

              if (authenState is AuthenticationLoggedInState) {
                currentUser = authenState.currentUser;
              }

              if (currentUser != null) {
                setState(() {
                  _fullNameController.text = currentUser?.name ?? '';
                  _emailController.text = currentUser?.email ?? '';
                  _userNameController.text = currentUser?.userName ?? '';
                  _phoneNumberController.text = currentUser?.phoneNumber ?? '';
                  _addressController.text = currentUser?.address ?? '';
                  _cityController.text = currentUser?.city ?? '';
                  _countryController.text = currentUser?.country ?? '';
                });
              }
            },
            builder: (context, authenState) {
              User? currentUser =
                  context.read<AuthenticationBloc>().currentUser;

              if (authenState is AuthenticationLoggedInState) {
                currentUser = authenState.currentUser;
              }

              if (currentUser != null) {
                _fullNameController.text = currentUser.name;
                _emailController.text = currentUser.email ?? '';
                _userNameController.text = currentUser.userName;
                _phoneNumberController.text = currentUser.phoneNumber;
                _addressController.text = currentUser.address ?? '';
                _cityController.text = currentUser.city ?? '';
                _countryController.text = currentUser.country ?? '';

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.width,
                      vertical: 25.height,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _avatar(),
                        SizedBox(height: 35.height),
                        Text(
                          currentUser.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.size,
                            fontFamily: 'Work Sans',
                            color: const Color(0xff464646),
                          ),
                        ),
                        Text(
                          currentUser.email ?? 'UNKNOWN',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.size,
                            fontFamily: 'Work Sans',
                            color: const Color(0xff868686),
                            height: 2.height,
                          ),
                        ),
                        _textField('User name', _userNameController),
                        _textField('Full name', _fullNameController),
                        _textField('Email', _emailController),
                        _textField('Phone number', _phoneNumberController),
                        _textField('Address', _addressController),
                        _textField('City', _cityController),
                        _textField('Country', _countryController),
                        Center(
                          child: GradientElevatedButton(
                            borderRadiusIndex: 20.radius,
                            textSize: 18.size,
                            borderColor: Colors.black,
                            text: 'Update Profile',
                            textWeight: FontWeight.w600,
                            buttonWidth: 300.width,
                            buttonHeight: 45.height,
                            beginColor: Colors.black,
                            endColor: const Color(0xff727272),
                            textColor: Colors.white,
                            onPress: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      children: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenState) {
            String? fileId =
                context.read<AuthenticationBloc>().currentUser?.avatar;

            if (authenState is AuthenticationAvatarUpdatedState) {
              fileId = authenState.fileId;
            }

            return CircleAvatar(
              radius: 44.radius,
              backgroundImage: NetworkImage(
                ValueRender.getGoogleDriveImageUrl(fileId ?? ''),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              ImagePicker()
                  .pickImage(
                source: ImageSource.gallery,
              )
                  .then(
                (XFile? image) {
                  if (image != null) {
                    File file = File(image.path);

                    context.read<UploadFileBloc>().add(
                          OnUploadFileEvent(file, isCustomer: true),
                        );
                  }
                },
              );
            },
            child: Container(
              height: 23.height,
              width: 23.width,
              padding: EdgeInsets.all(3.size),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.radius),
                color: const Color(0xffbababa),
              ),
              child: Image.asset(
                'assets/icon/edit_icon.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _textField(
      String hintText, TextEditingController? textEditingController,
      {bool editable = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.width),
      margin: EdgeInsets.only(top: 25.height),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xff777676), width: 0.5.width),
      ),
      child: TextField(
        controller: textEditingController,
        enabled: editable,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w400,
            fontSize: 14.size,
            color: const Color(0xff868686),
          ),
          labelStyle: TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w400,
            fontSize: 14.size,
            color: const Color(0xff868686),
          ),
        ),
      ),
    );
  }
}
