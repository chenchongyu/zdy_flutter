// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['name'] as String, json['route_id'] as String,
      (json['users'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'route_id': instance.routeId,
      'users': instance.users
    };
