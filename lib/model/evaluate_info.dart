import 'package:json_annotation/json_annotation.dart'; 
  
part 'evaluate_info.g.dart';


@JsonSerializable()
  class EvaluateInfo extends Object {

  @JsonKey(name: 'evaluateTags')
  List<EvaluateTags> evaluateTags;

  EvaluateInfo(this.evaluateTags,);

  factory EvaluateInfo.fromJson(Map<String, dynamic> srcJson) => _$EvaluateInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluateInfoToJson(this);

}

  
@JsonSerializable()
  class EvaluateTags extends Object {

  @JsonKey(name: 'tagid')
  String tagid;

  @JsonKey(name: 'tagContent')
  String tagContent;

  EvaluateTags(this.tagid,this.tagContent,);

  factory EvaluateTags.fromJson(Map<String, dynamic> srcJson) => _$EvaluateTagsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluateTagsToJson(this);

}

  
