import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/data/entity/translator_language.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repository/translator_repository.dart';

part 'translator_event.dart';
part 'translator_state.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorState> {
  final TranslatorRepository _translatorRepository;

  String translatedText = '';
  TranslatorLanguage? selectedLanguage;
  List<TranslatorLanguage> languageList = [];

  TranslatorBloc(this._translatorRepository) : super(TranslatorInitial()) {
    on<OnTranslateEvent>((event, emit) async {
      emit(TranslatorLoadingState());

      try {
        final response = await _translatorRepository.translate(
          event.text,
          event.sourceLanguageCode,
        );

        response.fold(
          (failure) => emit(TranslatorErrorState(failure.message)),
          (message) {
            translatedText = message;
            emit(TranslatorLoadedState(message));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(TranslatorErrorState(e.toString()));
      }
    });

    on<OnLoadLanguageListTranslatorEvent>((event, emit) async {
      emit(TranslatorLanguageListLoadingState());

      try {
        final response = await _translatorRepository.getAllLanguageList();

        response.fold(
          (failure) => emit(TranslatorErrorState(failure.message)),
          (list) {
            languageList = list;
            emit(TranslatorLanguageListLoadedState(list));
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        emit(TranslatorErrorState(e.toString()));
      }
    });

    on<OnSelectLanguageCodeTranslatorEvent>((event, emit) async {
      selectedLanguage = languageList
          .where((element) => element.languageCode == event.languageCode)
          .first;
      emit(TranslatorSelectedState(selectedLanguage));
    });

    on<OnClearTranslatorEvent>((event, emit) async {
      selectedLanguage = null;
      languageList.clear();
    });
  }
}
