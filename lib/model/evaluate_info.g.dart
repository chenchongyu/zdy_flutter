// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluate_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluateInfo _$EvaluateInfoFromJson(Map<String, dynamic> json) {
  return EvaluateInfo((json['evaluateTags'] as List)
      ?.map((e) =>
          e == null ? null : EvaluateTags.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$EvaluateInfoToJson(EvaluateInfo instance) =>
    <String, dynamic>{'evaluateTags': instance.evaluateTags};

EvaluateTags _$EvaluateTagsFromJson(Map<String, dynamic> json) {
  return EvaluateTags(json['tagid'] as String, json['tagContent'] as String);
}

Map<String, dynamic> _$EvaluateTagsToJson(EvaluateTags instance) =>
    <String, dynamic>{
      'tagid': instance.tagid,
      'tagContent': instance.tagContent
    };
