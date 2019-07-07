// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
      (json['recommedWords'] as List)?.map((e) => e as String)?.toList(),
      (json['diseaseWords'] as List)?.map((e) => e as String)?.toList(),
      json['text'] as String,
      json['resultlist'] == null
          ? null
          : Resultlist.fromJson(json['resultlist'] as Map<String, dynamic>),
      (json['submitWords'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'recommedWords': instance.recommedWords,
      'diseaseWords': instance.diseaseWords,
      'text': instance.text,
      'resultlist': instance.resultlist,
      'submitWords': instance.submitWords
    };

Resultlist _$ResultlistFromJson(Map<String, dynamic> json) {
  return Resultlist(
      (json['gridModel'] as List)
          ?.map((e) =>
              e == null ? null : GridModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['total'] as String,
      json['records'] as String,
      json['page'] as String);
}

Map<String, dynamic> _$ResultlistToJson(Resultlist instance) =>
    <String, dynamic>{
      'gridModel': instance.gridModel,
      'total': instance.total,
      'records': instance.records,
      'page': instance.page
    };

GridModel _$GridModelFromJson(Map<String, dynamic> json) {
  return GridModel(
      json['medicinalId'] as String,
      json['medicinalName'] as String,
      json['medicinalSpecification'] as String,
      json['medicinalIsInsurance'] as String,
      json['medicinalContraindication'] as String,
      json['medicinalManufacturingEnterprise'] as String,
      json['medicinalEvaluateStar'] as String,
      json['medicinalRecommedKpi'] as String,
      json['medicinalSaleCnt'] as String,
      json['medicinalDoubleEvaluateStar'] as String,
      json['medicinalViewCnt'] as String);
}

Map<String, dynamic> _$GridModelToJson(GridModel instance) => <String, dynamic>{
      'medicinalId': instance.medicinalId,
      'medicinalName': instance.medicinalName,
      'medicinalSpecification': instance.medicinalSpecification,
      'medicinalIsInsurance': instance.medicinalIsInsurance,
      'medicinalContraindication': instance.medicinalContraindication,
      'medicinalManufacturingEnterprise':
          instance.medicinalManufacturingEnterprise,
      'medicinalEvaluateStar': instance.medicinalEvaluateStar,
      'medicinalRecommedKpi': instance.medicinalRecommedKpi,
      'medicinalSaleCnt': instance.medicinalSaleCnt,
      'medicinalDoubleEvaluateStar': instance.medicinalDoubleEvaluateStar,
      'medicinalViewCnt': instance.medicinalViewCnt
    };
