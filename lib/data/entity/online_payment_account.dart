import 'package:json_annotation/json_annotation.dart';

part 'online_payment_account.g.dart';

@JsonSerializable()
class OnlinePaymentAccount {
  @JsonKey(name: "id")
  int id;
  String receiverAccount;
  String receiverName;
  String additionalInfo;
  String type;

  OnlinePaymentAccount(
    this.id,
    this.receiverAccount,
    this.receiverName,
    this.additionalInfo,
    this.type,
  );

  factory OnlinePaymentAccount.fromJson(Map<String, dynamic> json) =>
      _$OnlinePaymentAccountFromJson(json);

  Map<String, dynamic> toJson() => _$OnlinePaymentAccountToJson(this);

  @override
  String toString() {
    return 'OnlinePaymentAccount{id: $id, receiverAccount: $receiverAccount, receiverName: $receiverName, additionalInfo: $additionalInfo, type: $type}';
  }
}
