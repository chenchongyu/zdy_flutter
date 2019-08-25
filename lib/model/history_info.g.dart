// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryInfo _$HistoryInfoFromJson(Map<String, dynamic> json) {
  return HistoryInfo((json['historyList'] as List)
      ?.map((e) =>
          e == null ? null : HistoryList.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$HistoryInfoToJson(HistoryInfo instance) =>
    <String, dynamic>{'historyList': instance.historyList};

HistoryList _$HistoryListFromJson(Map<String, dynamic> json) {
  return HistoryList(
      json['medicinalId'] as String, json['medicinalName'] as String);
}

Map<String, dynamic> _$HistoryListToJson(HistoryList instance) =>
    <String, dynamic>{
      'medicinalId': instance.medicinalId,
      'medicinalName': instance.medicinalName
    };
