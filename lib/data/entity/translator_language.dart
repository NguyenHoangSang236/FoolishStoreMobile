import 'package:json_annotation/json_annotation.dart';

part 'translator_language.g.dart';

@JsonSerializable()
class TranslatorLanguage {
  @JsonKey(name: "id")
  final int id;
  final String languageCode;
  final String name;
  final String flagImage;

  TranslatorLanguage(this.id, this.languageCode, this.name, this.flagImage);

  factory TranslatorLanguage.fromJson(Map<String, dynamic> json) =>
      _$TranslatorLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$TranslatorLanguageToJson(this);

  @override
  String toString() {
    return 'Language{id: $id, languageCode: $languageCode, name: $name, imageLocalStoragePath: $flagImage}';
  }
}
