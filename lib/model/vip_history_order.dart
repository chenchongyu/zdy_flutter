import 'package:json_annotation/json_annotation.dart';

part 'vip_history_order.g.dart';


@JsonSerializable()
class HistoryOrder extends Object {

  @JsonKey(name: 'lstGoods')
  List<OrderItem> pkgList;

  HistoryOrder(this.pkgList,);

  factory HistoryOrder.fromJson(Map<String, dynamic> srcJson) => _$HistoryOrderFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HistoryOrderToJson(this);

}


@JsonSerializable()
class OrderItem extends Object {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'pkgId')
  String pkgId;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'name')
  String pkgName;

  @JsonKey(name: 'price')
  String pkgPrice;


  OrderItem(this.id, this.pkgId, this.createTime, this.pkgName, this.pkgPrice);

  factory OrderItem.fromJson(Map<String, dynamic> srcJson) => _$OrderItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

}



