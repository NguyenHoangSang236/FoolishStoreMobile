import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@CopyWith()
@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  int id;
  int accountId;
  String userName;
  String status;
  String name;
  String phoneNumber;
  String? address;
  String? city;
  String? country;
  String? avatar;
  String? email;

  User(
    this.id,
    this.accountId,
    this.userName,
    this.status,
    this.name,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.avatar,
    this.email,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id, accountId: $accountId, userName: $userName, status: $status, name: $name, phoneNumber: $phoneNumber, address: $address, city: $city, country: $country, avatar: $avatar, email: $email}';
  }
}
