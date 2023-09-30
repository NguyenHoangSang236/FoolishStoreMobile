import 'dart:convert';

extension FormatString on String {
  String get dollar => '\$$this';
  Map<String, dynamic> get map => json.decode(jsonEncode(this));

  // format enum into uppercase first letter string
  String get formatEnumToUppercaseFirstLetter =>
      '${this[0]}${replaceAll('_', ' ').substring(1).toLowerCase()}';
}
