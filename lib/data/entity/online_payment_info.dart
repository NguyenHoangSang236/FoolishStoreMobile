import 'package:fashionstore/data/entity/online_payment_account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'online_payment_info.g.dart';

@JsonSerializable()
class OnlinePaymentInfo {
  String? content;
  double? moneyAmount;
  OnlinePaymentAccount? receiverInfo;

  OnlinePaymentInfo(this.content, this.moneyAmount, this.receiverInfo);

  factory OnlinePaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$OnlinePaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OnlinePaymentInfoToJson(this);

  @override
  String toString() {
    return 'OnlinePaymentInfo{content: $content, moneyAmount: $moneyAmount, receiverInfo: $receiverInfo}';
  }
}
