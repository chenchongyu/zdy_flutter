// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluate_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluateList _$EvaluateListFromJson(Map<String, dynamic> json) {
  return EvaluateList(json['evaluatelist'] == null
      ? null
      : Evaluatelist.fromJson(json['evaluatelist'] as Map<String, dynamic>));
}

Map<String, dynamic> _$EvaluateListToJson(EvaluateList instance) =>
    <String, dynamic>{'evaluatelist': instance.evaluatelist};

Evaluatelist _$EvaluatelistFromJson(Map<String, dynamic> json) {
  return Evaluatelist(
      (json['gridModel'] as List)
          ?.map((e) =>
              e == null ? null : GridModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['total'] as String,
      json['records'] as String,
      json['page'] as String);
}

Map<String, dynamic> _$EvaluatelistToJson(Evaluatelist instance) =>
    <String, dynamic>{
      'gridModel': instance.gridModel,
      'total': instance.total,
      'records': instance.records,
      'page': instance.page
    };

GridModel _$GridModelFromJson(Map<String, dynamic> json) {
  return GridModel(json['evaluateTime'] as String,
      json['evaluateContent'] as String, json['evaluateStar'] as String);
}

Map<String, dynamic> _$GridModelToJson(GridModel instance) => <String, dynamic>{
      'evaluateTime': instance.evaluateTime,
      'evaluateContent': instance.evaluateContent,
      'evaluateStar': instance.evaluateStar
    };
