import 'package:json_annotation/json_annotation.dart';

part 'vip_package.g.dart';


@JsonSerializable()
class VipPackage extends Object {

  @JsonKey(name: 'lstGoods')
  List<PkgListItem> pkgList;

  VipPackage(this.pkgList,);

  factory VipPackage.fromJson(Map<String, dynamic> srcJson) => _$VipPackageFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VipPackageToJson(this);

}


@JsonSerializable()
class PkgListItem extends Object {

  @JsonKey(name: 'id')
  String pkgId;

  @JsonKey(name: 'name')
  String pkgName;

  @JsonKey(name: 'price')
  String pkgPrice;

  PkgListItem(this.pkgId,this.pkgName,this.pkgPrice,);

  factory PkgListItem.fromJson(Map<String, dynamic> srcJson) => _$Pkg_listFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Pkg_listToJson(this);

}



