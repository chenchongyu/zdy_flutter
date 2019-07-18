import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult extends Object {
  @JsonKey(name: 'recommedWords')
  List<String> recommedWords;

  @JsonKey(name: 'diseaseWords')
  List<String> diseaseWords;

  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'resultlist')
  Resultlist resultlist;

  @JsonKey(name: 'submitWords')
  List<String> submitWords;

  SearchResult(
    this.recommedWords,
    this.diseaseWords,
    this.text,
    this.resultlist,
    this.submitWords,
  );

  factory SearchResult.fromJson(Map<String, dynamic> srcJson) =>
      _$SearchResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class Resultlist extends Object {
  @JsonKey(name: 'gridModel')
  List<GridModel> gridModel;

  @JsonKey(name: 'total')
  String total;

  @JsonKey(name: 'records')
  String records;

  @JsonKey(name: 'page')
  String page;

  Resultlist(
    this.gridModel,
    this.total,
    this.records,
    this.page,
  );

  factory Resultlist.fromJson(Map<String, dynamic> srcJson) =>
      _$ResultlistFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultlistToJson(this);
}

@JsonSerializable()
class GridModel extends Object {
  @JsonKey(name: 'medicinalId')
  String medicinalId;

  @JsonKey(name: 'medicinalName')
  String medicinalName;

  @JsonKey(name: 'medicinalSpecification')
  String medicinalSpecification; //规格

  String medicinalSpecification2; //缩略展示的规格

  @JsonKey(name: 'medicinalIsInsurance')
  String medicinalIsInsurance;

  @JsonKey(name: 'medicinalContraindication')
  String medicinalContraindication;

  @JsonKey(name: 'medicinalManufacturingEnterprise')
  String medicinalManufacturingEnterprise; //药厂
  String medicinalManufacturingEnterprise2; //缩略展示的药厂


  @JsonKey(name: 'medicinalEvaluateStar')
  String medicinalEvaluateStar;

  @JsonKey(name: 'medicinalRecommedKpi')
  String medicinalRecommedKpi;

  @JsonKey(name: 'medicinalSaleCnt')
  String medicinalSaleCnt;

  @JsonKey(name: 'medicinalDoubleEvaluateStar')
  String medicinalDoubleEvaluateStar;

  @JsonKey(name: 'medicinalViewCnt')
  String medicinalViewCnt;

  GridModel(
    this.medicinalId,
    this.medicinalName,
    this.medicinalSpecification,
    this.medicinalIsInsurance,
    this.medicinalContraindication,
    this.medicinalManufacturingEnterprise,
    this.medicinalEvaluateStar,
    this.medicinalRecommedKpi,
    this.medicinalSaleCnt,
    this.medicinalDoubleEvaluateStar,
    this.medicinalViewCnt,
  );

  factory GridModel.fromJson(Map<String, dynamic> srcJson) =>
      _$GridModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GridModelToJson(this);
}
