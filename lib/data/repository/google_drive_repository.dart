import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fashionstore/data/enum/google_drive_folder_name_enum.dart';
import 'package:fashionstore/utils/network/failure.dart';
import 'package:fashionstore/utils/render/value_render.dart';
import 'package:http_parser/http_parser.dart';

import '../../utils/network/network_service.dart';

class GoogleDriveRepository {
  String type = 'googleDrive';

  Future<Either<Failure, String>> uploadFileToGoogleDrive(File file,
      {bool isCustomer = false, bool isDelivery = false}) async {
    MultipartFile multipartFile = await MultipartFile.fromFile(
      file.path,
      contentType: MediaType('image', 'jpg'),
    );

    return NetworkService.getMessageFromApi(
      '/upLoadCustomerAvatar',
      type: type,
      formDataBody: ValueRender.buildFormDataParamBody(
        multipartFile,
        isCustomer == true
            ? GoogleDriveFolderNameEnum.CustomerAvatar.name
            : 'Root',
      ),
      isAuthen: true,
    );
  }
}
