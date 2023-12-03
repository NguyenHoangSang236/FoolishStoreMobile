import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repository/google_drive_repository.dart';

part 'upload_file_event.dart';
part 'upload_file_state.dart';

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final GoogleDriveRepository _googleDriveRepository;

  String ggDriveFileUrl = '';

  UploadFileBloc(this._googleDriveRepository) : super(UploadFileInitial()) {
    on<OnUploadFileEvent>((event, emit) async {
      emit(UploadFileUploadingState());

      try {
        String response = await _googleDriveRepository.uploadFileToGoogleDrive(
            event.uploadFile,
            isCustomer: event.isCustomer);

        ggDriveFileUrl = response;

        if (response.contains('https://drive.google')) {
          emit(UploadFileUploadedState(response));
        } else {
          emit(UploadFileErrorState(response));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(UploadFileErrorState(e.toString()));
      }
    });
  }
}
