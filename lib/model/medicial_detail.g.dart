// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicial_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicialDetail _$MedicialDetailFromJson(Map<String, dynamic> json) {
  return MedicialDetail(
      (json['recommendList'] as List)
          ?.map((e) => e == null
              ? null
              : RecommendList.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['medicinal'] == null
          ? null
          : Medicinal.fromJson(json['medicinal'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MedicialDetailToJson(MedicialDetail instance) =>
    <String, dynamic>{
      'recommendList': instance.recommendList,
      'medicinal': instance.medicinal
    };

RecommendList _$RecommendListFromJson(Map<String, dynamic> json) {
  return RecommendList(
      json['medicinalId'] as String,
      json['medicinalName'] as String,
      json['medicinalSpecification'] as String,
      json['medicinalManufacturingEnterprise'] as String);
}

Map<String, dynamic> _$RecommendListToJson(RecommendList instance) =>
    <String, dynamic>{
      'medicinalId': instance.medicinalId,
      'medicinalName': instance.medicinalName,
      'medicinalSpecification': instance.medicinalSpecification,
      'medicinalManufacturingEnterprise':
          instance.medicinalManufacturingEnterprise
    };

Medicinal _$MedicinalFromJson(Map<String, dynamic> json) {
  return Medicinal(
      json['medicinalId'] as String,
      json['medicinalDispensatoryName'] as String,
      json['medicinalBrand'] as String,
      json['medicinalName'] as String,
      json['medicinalFunction'] as String,
      json['medicinalSpecification'] as String,
      json['medicinalIngredients'] as String,
      json['medicinalCharacter'] as String,
      json['medicinalUsage'] as String,
      json['medicinalAdverseReactions'] as String,
      json['medicinalIsInsurance'] as String,
      json['medicinalContraindication'] as String,
      json['medicinalAttentions'] as String,
      json['medicinalInteract'] as String,
      json['medicinalStorage'] as String,
      json['medicinalPackage'] as String,
      json['medicinalOperativeNorm'] as String,
      json['medicinalLicenseNumber'] as String,
      json['medicinalManufacturingEnterprise'] as String,
      json['medicinalEnterpriseAddress'] as String,
      json['medicinalIncompatibility'] as String,
      json['medicinalValidity'] as String,
      json['zuoyonglb'] as String,
      json['hanyupy'] as String,
      json['yaopingfl'] as String,
      json['feichuffl'] as String,
      json['yaowugl'] as String,
      json['yaowudl'] as String,
      json['renchenqyy'] as String,
      json['ertongyy'] as String,
      json['laonianyy'] as String,
      json['linchuangyy'] as String,
      json['yaodaidlx'] as String,
      json['jinggao'] as String,
      json['liulancs'] as String,
      json['xiaoliang'] as String,
      json['medicinalKeyWordsResult'] == null
          ? null
          : MedicinalKeyWordsResult.fromJson(
              json['medicinalKeyWordsResult'] as Map<String, dynamic>),
      json['medicinalCollect'] as String,
      json['medicinalImageUrl'] as String);
}

Map<String, dynamic> _$MedicinalToJson(Medicinal instance) => <String, dynamic>{
      'medicinalId': instance.medicinalId,
      'medicinalDispensatoryName': instance.medicinalDispensatoryName,
      'medicinalBrand': instance.medicinalBrand,
      'medicinalName': instance.medicinalName,
      'medicinalFunction': instance.medicinalFunction,
      'medicinalSpecification': instance.medicinalSpecification,
      'medicinalIngredients': instance.medicinalIngredients,
      'medicinalCharacter': instance.medicinalCharacter,
      'medicinalUsage': instance.medicinalUsage,
      'medicinalAdverseReactions': instance.medicinalAdverseReactions,
      'medicinalIsInsurance': instance.medicinalIsInsurance,
      'medicinalContraindication': instance.medicinalContraindication,
      'medicinalAttentions': instance.medicinalAttentions,
      'medicinalInteract': instance.medicinalInteract,
      'medicinalStorage': instance.medicinalStorage,
      'medicinalPackage': instance.medicinalPackage,
      'medicinalOperativeNorm': instance.medicinalOperativeNorm,
      'medicinalLicenseNumber': instance.medicinalLicenseNumber,
      'medicinalManufacturingEnterprise':
          instance.medicinalManufacturingEnterprise,
      'medicinalEnterpriseAddress': instance.medicinalEnterpriseAddress,
      'medicinalIncompatibility': instance.medicinalIncompatibility,
      'medicinalValidity': instance.medicinalValidity,
      'zuoyonglb': instance.zuoyonglb,
      'hanyupy': instance.hanyupy,
      'yaopingfl': instance.yaopingfl,
      'feichuffl': instance.feichuffl,
      'yaowugl': instance.yaowugl,
      'yaowudl': instance.yaowudl,
      'renchenqyy': instance.renchenqyy,
      'ertongyy': instance.ertongyy,
      'laonianyy': instance.laonianyy,
      'linchuangyy': instance.linchuangyy,
      'yaodaidlx': instance.yaodaidlx,
      'jinggao': instance.jinggao,
      'liulancs': instance.liulancs,
      'xiaoliang': instance.xiaoliang,
      'medicinalKeyWordsResult': instance.medicinalKeyWordsResult,
      'medicinalCollect': instance.medicinalCollect,
      'medicinalImageUrl': instance.medicinalImageUrl
    };

MedicinalKeyWordsResult _$MedicinalKeyWordsResultFromJson(
    Map<String, dynamic> json) {
  return MedicinalKeyWordsResult();
}

Map<String, dynamic> _$MedicinalKeyWordsResultToJson(
        MedicinalKeyWordsResult instance) =>
    <String, dynamic>{};
