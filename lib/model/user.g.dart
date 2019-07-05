// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return new User(json['name'] as String, json['route_id'] as String,
      (json['users'] as List)?.map((e) => e as String)?.toList());
}

abstract class _$UserSerializerMixin {
  String get name;
  String get routeId;
  List<String> get users;
  Map<String, dynamic> _toJson() =>
      <String, dynamic>{'name': name, 'route_id': routeId, 'users': users};
}
