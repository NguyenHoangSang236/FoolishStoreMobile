import 'dart:convert';

extension FormatString on String {
  String get dollar => '\$$this';
  Map<String, dynamic> get map => json.decode(jsonEncode(this));

  String get formatToJson {
    String jsonString = this;

    /// replace '=' with ': '
    jsonString = jsonString.replaceAll("=", ": ");

    /// add quotes to json string
    jsonString = jsonString.replaceAll('{', '{"');
    jsonString = jsonString.replaceAll(': ', '": "');
    jsonString = jsonString.replaceAll(', ', '", "');
    jsonString = jsonString.replaceAll('}', '"}');
    jsonString = jsonString.replaceAll('}"', '}');
    jsonString = jsonString.replaceAll('"{', '{');

    /// remove quotes on array json string
    jsonString = jsonString.replaceAll('"[{', '[{');
    jsonString = jsonString.replaceAll('}]"', '}]');

    return jsonString;
  }

  // format enum into uppercase first letter string
  String get formatEnumToUppercaseFirstLetter =>
      '${this[0]}${replaceAll('_', ' ').substring(1).toLowerCase()}';
}
