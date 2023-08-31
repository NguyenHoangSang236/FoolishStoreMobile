import 'dart:convert';

extension FormatString on String {
  String get dollar => '\$$this';
  Map<String, dynamic> get map => json.decode(jsonEncode(this));
}
