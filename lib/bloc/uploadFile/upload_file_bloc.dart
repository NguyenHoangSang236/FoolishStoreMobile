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
        final response = await _googleDriveRepository.uploadFileToGoogleDrive(
          event.uploadFile,
          isCustomer: event.isCustomer,
        );

        response.fold(
          (failure) => emit(UploadFileErrorState(failure.message)),
          (url) => emit(UploadFileUploadedState(url)),
        );
      } catch (e, stackTrace) {
        debugPrint('Caught Exception: $e\n$stackTrace');
        emit(UploadFileErrorState(e.toString()));
      }
    });
  }
}
