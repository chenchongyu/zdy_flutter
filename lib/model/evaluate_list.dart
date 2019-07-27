import 'package:json_annotation/json_annotation.dart'; 
  
part 'evaluate_list.g.dart';


@JsonSerializable()
  class EvaluateList extends Object {

  @JsonKey(name: 'evaluatelist')
  Evaluatelist evaluatelist;

  EvaluateList(this.evaluatelist,);

  factory EvaluateList.fromJson(Map<String, dynamic> srcJson) => _$EvaluateListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluateListToJson(this);

}

  
@JsonSerializable()
  class Evaluatelist extends Object {

  @JsonKey(name: 'gridModel')
  List<GridModel> gridModel;

  @JsonKey(name: 'total')
  String total;

  @JsonKey(name: 'records')
  String records;

  @JsonKey(name: 'page')
  String page;

  Evaluatelist(this.gridModel,this.total,this.records,this.page,);

  factory Evaluatelist.fromJson(Map<String, dynamic> srcJson) => _$EvaluatelistFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluatelistToJson(this);

}

  
@JsonSerializable()
  class GridModel extends Object {

  @JsonKey(name: 'evaluateTime')
  String evaluateTime;

  @JsonKey(name: 'evaluateContent')
  String evaluateContent;

  @JsonKey(name: 'evaluateStar')
  String evaluateStar;

  GridModel(this.evaluateTime,this.evaluateContent,this.evaluateStar,);

  factory GridModel.fromJson(Map<String, dynamic> srcJson) => _$GridModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GridModelToJson(this);

}

  
