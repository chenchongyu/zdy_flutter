import 'package:json_annotation/json_annotation.dart';

part 'medicial_detail.g.dart';


@JsonSerializable()
class MedicialDetail extends Object {

  @JsonKey(name: 'recommendList')
  List<RecommendList> recommendList;

  @JsonKey(name: 'medicinal')
  Medicinal medicinal;

  MedicialDetail(this.recommendList,this.medicinal,);

  factory MedicialDetail.fromJson(Map<String, dynamic> srcJson) => _$MedicialDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MedicialDetailToJson(this);

}


@JsonSerializable()
class RecommendList extends Object {

  @JsonKey(name: 'medicinalId')
  String medicinalId;

  @JsonKey(name: 'medicinalName')
  String medicinalName;

  @JsonKey(name: 'medicinalSpecification')
  String medicinalSpecification;

  @JsonKey(name: 'medicinalManufacturingEnterprise')
  String medicinalManufacturingEnterprise;

  RecommendList(this.medicinalId,this.medicinalName,this.medicinalSpecification,this.medicinalManufacturingEnterprise,);

  factory RecommendList.fromJson(Map<String, dynamic> srcJson) => _$RecommendListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RecommendListToJson(this);

}


@JsonSerializable()
class Medicinal extends Object {

  @JsonKey(name: 'medicinalId')
  String medicinalId;

  @JsonKey(name: 'medicinalDispensatoryName')
  String medicinalDispensatoryName;

  @JsonKey(name: 'medicinalBrand')
  String medicinalBrand;

  @JsonKey(name: 'medicinalName')
  String medicinalName;

  @JsonKey(name: 'medicinalFunction')
  String medicinalFunction; //主治功能

  @JsonKey(name: 'medicinalSpecification')
  String medicinalSpecification; //规格

  @JsonKey(name: 'medicinalIngredients')
  String medicinalIngredients; //成分

  @JsonKey(name: 'medicinalCharacter')
  String medicinalCharacter; //性状

  @JsonKey(name: 'medicinalUsage')
  String medicinalUsage; //用法用量

  @JsonKey(name: 'medicinalAdverseReactions')
  String medicinalAdverseReactions; //不良反应

  @JsonKey(name: 'medicinalIsInsurance')
  String medicinalIsInsurance;

  @JsonKey(name: 'medicinalContraindication')
  String medicinalContraindication; //用药禁忌

  @JsonKey(name: 'medicinalAttentions')
  String medicinalAttentions;

  @JsonKey(name: 'medicinalInteract')
  String medicinalInteract; //药物相互作用

  @JsonKey(name: 'medicinalStorage')
  String medicinalStorage;

  @JsonKey(name: 'medicinalPackage')
  String medicinalPackage;

  @JsonKey(name: 'medicinalOperativeNorm')
  String medicinalOperativeNorm; //执行标准

  @JsonKey(name: 'medicinalLicenseNumber')
  String medicinalLicenseNumber; //批准文号

  @JsonKey(name: 'medicinalManufacturingEnterprise')
  String medicinalManufacturingEnterprise;

  @JsonKey(name: 'medicinalEnterpriseAddress')
  String medicinalEnterpriseAddress;

  @JsonKey(name: 'medicinalIncompatibility')
  String medicinalIncompatibility; //配伍禁忌

  @JsonKey(name: 'medicinalValidity')
  String medicinalValidity; //有效期

  @JsonKey(name: 'zuoyonglb')
  String zuoyonglb;

  @JsonKey(name: 'hanyupy')
  String hanyupy;

  @JsonKey(name: 'yaopingfl')
  String yaopingfl;

  @JsonKey(name: 'feichuffl')
  String feichuffl;

  @JsonKey(name: 'yaowugl')
  String yaowugl;

  @JsonKey(name: 'yaowudl')
  String yaowudl;

  @JsonKey(name: 'renchenqyy')
  String renchenqyy;

  @JsonKey(name: 'ertongyy')
  String ertongyy;

  @JsonKey(name: 'laonianyy')
  String laonianyy;

  @JsonKey(name: 'linchuangyy')
  String linchuangyy;

  @JsonKey(name: 'yaodaidlx')
  String yaodaidlx;

  @JsonKey(name: 'jinggao')
  String jinggao;

  @JsonKey(name: 'liulancs')
  String liulancs;

  @JsonKey(name: 'xiaoliang')
  String xiaoliang;

  @JsonKey(name: 'medicinalKeyWordsResult')
  MedicinalKeyWordsResult medicinalKeyWordsResult;

  @JsonKey(name: 'medicinalCollect')
  String medicinalCollect;

  @JsonKey(name: 'medicinalImageUrl')
  String medicinalImageUrl;

  Medicinal(this.medicinalId,this.medicinalDispensatoryName,this.medicinalBrand,this.medicinalName,this.medicinalFunction,this.medicinalSpecification,this.medicinalIngredients,this.medicinalCharacter,this.medicinalUsage,this.medicinalAdverseReactions,this.medicinalIsInsurance,this.medicinalContraindication,this.medicinalAttentions,this.medicinalInteract,this.medicinalStorage,this.medicinalPackage,this.medicinalOperativeNorm,this.medicinalLicenseNumber,this.medicinalManufacturingEnterprise,this.medicinalEnterpriseAddress,this.medicinalIncompatibility,this.medicinalValidity,this.zuoyonglb,this.hanyupy,this.yaopingfl,this.feichuffl,this.yaowugl,this.yaowudl,this.renchenqyy,this.ertongyy,this.laonianyy,this.linchuangyy,this.yaodaidlx,this.jinggao,this.liulancs,this.xiaoliang,this.medicinalKeyWordsResult,this.medicinalCollect,this.medicinalImageUrl,);

  factory Medicinal.fromJson(Map<String, dynamic> srcJson) => _$MedicinalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MedicinalToJson(this);

}


@JsonSerializable()
class MedicinalKeyWordsResult extends Object {

  MedicinalKeyWordsResult();

  factory MedicinalKeyWordsResult.fromJson(Map<String, dynamic> srcJson) => _$MedicinalKeyWordsResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MedicinalKeyWordsResultToJson(this);

}

  
