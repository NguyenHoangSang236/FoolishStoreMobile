// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserCWProxy {
  User id(int id);

  User accountId(int accountId);

  User userName(String userName);

  User status(String status);

  User name(String name);

  User phoneNumber(String phoneNumber);

  User address(String? address);

  User city(String? city);

  User country(String? country);

  User avatar(String? avatar);

  User email(String? email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    int? id,
    int? accountId,
    String? userName,
    String? status,
    String? name,
    String? phoneNumber,
    String? address,
    String? city,
    String? country,
    String? avatar,
    String? email,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUser.copyWith.fieldName(...)`
class _$UserCWProxyImpl implements _$UserCWProxy {
  const _$UserCWProxyImpl(this._value);

  final User _value;

  @override
  User id(int id) => this(id: id);

  @override
  User accountId(int accountId) => this(accountId: accountId);

  @override
  User userName(String userName) => this(userName: userName);

  @override
  User status(String status) => this(status: status);

  @override
  User name(String name) => this(name: name);

  @override
  User phoneNumber(String phoneNumber) => this(phoneNumber: phoneNumber);

  @override
  User address(String? address) => this(address: address);

  @override
  User city(String? city) => this(city: city);

  @override
  User country(String? country) => this(country: country);

  @override
  User avatar(String? avatar) => this(avatar: avatar);

  @override
  User email(String? email) => this(email: email);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    Object? id = const $CopyWithPlaceholder(),
    Object? accountId = const $CopyWithPlaceholder(),
    Object? userName = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phoneNumber = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? country = const $CopyWithPlaceholder(),
    Object? avatar = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
  }) {
    return User(
      id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      accountId == const $CopyWithPlaceholder() || accountId == null
          ? _value.accountId
          // ignore: cast_nullable_to_non_nullable
          : accountId as int,
      userName == const $CopyWithPlaceholder() || userName == null
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String,
      status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      phoneNumber == const $CopyWithPlaceholder() || phoneNumber == null
          ? _value.phoneNumber
          // ignore: cast_nullable_to_non_nullable
          : phoneNumber as String,
      address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
      city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String?,
      country == const $CopyWithPlaceholder()
          ? _value.country
          // ignore: cast_nullable_to_non_nullable
          : country as String?,
      avatar == const $CopyWithPlaceholder()
          ? _value.avatar
          // ignore: cast_nullable_to_non_nullable
          : avatar as String?,
      email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
    );
  }
}

extension $UserCopyWith on User {
  /// Returns a callable class that can be used as follows: `instanceOfUser.copyWith(...)` or like so:`instanceOfUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserCWProxy get copyWith => _$UserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['accountId'] as int,
      json['userName'] as String,
      json['status'] as String,
      json['name'] as String,
      json['phoneNumber'] as String,
      json['address'] as String?,
      json['city'] as String?,
      json['country'] as String?,
      json['avatar'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'userName': instance.userName,
      'status': instance.status,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'avatar': instance.avatar,
      'email': instance.email,
    };
