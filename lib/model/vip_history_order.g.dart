// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_history_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryOrder _$HistoryOrderFromJson(Map<String, dynamic> json) {
  return HistoryOrder((json['lstOrder'] as List)
      ?.map((e) =>
          e == null ? null : OrderItem.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$HistoryOrderToJson(HistoryOrder instance) =>
    <String, dynamic>{'lstOrder': instance.pkgList};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
      json['id'] as String,
      json['goods_id'] as String,
      json['creat_time'] as String,
      json['goods_name'] as String,
      json['goods_price'] as String);
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'goods_id': instance.pkgId,
      'creat_time': instance.createTime,
      'goods_name': instance.pkgName,
      'goods_price': instance.pkgPrice
    };
