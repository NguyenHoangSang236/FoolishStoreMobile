import 'package:json_annotation/json_annotation.dart';

part 'refund.g.dart';

@JsonSerializable()
class Refund {
  int id;
  double refundMoney;
  DateTime? date;
  String? evidentImage;
  String status;

  Refund(this.id, this.refundMoney, this.date, this.evidentImage, this.status);

  factory Refund.fromJson(Map<String, dynamic> json) => _$RefundFromJson(json);

  Map<String, dynamic> toJson() => _$RefundToJson(this);

  @override
  String toString() {
    return 'Refund{id: $id, refundMoney: $refundMoney, date: $date, evidentImage: $evidentImage, status: $status}';
  }
}
