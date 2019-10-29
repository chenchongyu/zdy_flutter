// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_history_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryOrder _$HistoryOrderFromJson(Map<String, dynamic> json) {
  return HistoryOrder((json['lstGoods'] as List)
      ?.map((e) =>
          e == null ? null : OrderItem.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$HistoryOrderToJson(HistoryOrder instance) =>
    <String, dynamic>{'lstGoods': instance.pkgList};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
      json['id'] as String,
      json['pkgId'] as String,
      json['createTime'] as String,
      json['name'] as String,
      json['price'] as String);
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'pkgId': instance.pkgId,
      'createTime': instance.createTime,
      'name': instance.pkgName,
      'price': instance.pkgPrice
    };
