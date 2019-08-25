import 'package:json_annotation/json_annotation.dart';

part 'history_info.g.dart';


@JsonSerializable()
class HistoryInfo extends Object {

  @JsonKey(name: 'historyList')
  List<HistoryList> historyList;

  HistoryInfo(this.historyList,);

  factory HistoryInfo.fromJson(Map<String, dynamic> srcJson) => _$HistoryInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HistoryInfoToJson(this);

}


@JsonSerializable()
class HistoryList extends Object {

  @JsonKey(name: 'medicinalId')
  String medicinalId;

  @JsonKey(name: 'medicinalName')
  String medicinalName;

  HistoryList(this.medicinalId,this.medicinalName,);

  factory HistoryList.fromJson(Map<String, dynamic> srcJson) => _$HistoryListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HistoryListToJson(this);

}


