// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkInfo _$LinkInfoFromJson(Map<String, dynamic> json) {
  return LinkInfo((json['linklist'] as List)
      ?.map((e) => e == null ? null : Link.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$LinkInfoToJson(LinkInfo instance) =>
    <String, dynamic>{'linklist': instance.linklist};

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
      json['descId'] as String,
      json['descTitle'] as String,
      json['descContent'] as String,
      json['descImageUrl'] as String,
      json['descVisitUrl'] as String);
}

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'descId': instance.descId,
      'descTitle': instance.descTitle,
      'descContent': instance.descContent,
      'descImageUrl': instance.descImageUrl,
      'descVisitUrl': instance.descVisitUrl
    };
