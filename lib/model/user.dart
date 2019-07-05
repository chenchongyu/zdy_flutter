import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable()
class User {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'route_id')
  String routeId;

  @JsonKey(name: 'users')
  List<String> users;

  User(this.name,this.routeId,this.users,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}


