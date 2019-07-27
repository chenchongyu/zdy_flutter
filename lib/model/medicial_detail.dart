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
  String medicinalFunction;

  @JsonKey(name: 'medicinalSpecification')
  String medicinalSpecification;

  @JsonKey(name: 'medicinalIngredients')
  String medicinalIngredients;

  @JsonKey(name: 'medicinalCharacter')
  String medicinalCharacter;

  @JsonKey(name: 'medicinalUsage')
  String medicinalUsage;

  @JsonKey(name: 'medicinalAdverseReactions')
  String medicinalAdverseReactions;

  @JsonKey(name: 'medicinalIsInsurance')
  String medicinalIsInsurance;

  @JsonKey(name: 'medicinalContraindication')
  String medicinalContraindication;

  @JsonKey(name: 'medicinalAttentions')
  String medicinalAttentions;

  @JsonKey(name: 'medicinalInteract')
  String medicinalInteract;

  @JsonKey(name: 'medicinalStorage')
  String medicinalStorage;

  @JsonKey(name: 'medicinalPackage')
  String medicinalPackage;

  @JsonKey(name: 'medicinalOperativeNorm')
  String medicinalOperativeNorm;

  @JsonKey(name: 'medicinalLicenseNumber')
  String medicinalLicenseNumber;

  @JsonKey(name: 'medicinalManufacturingEnterprise')
  String medicinalManufacturingEnterprise;

  @JsonKey(name: 'medicinalEnterpriseAddress')
  String medicinalEnterpriseAddress;

  @JsonKey(name: 'medicinalIncompatibility')
  String medicinalIncompatibility;

  @JsonKey(name: 'medicinalValidity')
  String medicinalValidity;

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

  
