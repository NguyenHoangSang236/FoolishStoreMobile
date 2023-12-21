// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translator_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslatorLanguage _$TranslatorLanguageFromJson(Map<String, dynamic> json) =>
    TranslatorLanguage(
      json['id'] as int,
      json['languageCode'] as String,
      json['name'] as String,
      json['flagImage'] as String,
    );

Map<String, dynamic> _$TranslatorLanguageToJson(TranslatorLanguage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'languageCode': instance.languageCode,
      'name': instance.name,
      'flagImage': instance.flagImage,
    };
