// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VipPackage _$VipPackageFromJson(Map<String, dynamic> json) {
  return VipPackage((json['lstGoods'] as List)
      ?.map((e) =>
          e == null ? null : PkgListItem.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$VipPackageToJson(VipPackage instance) =>
    <String, dynamic>{'lstGoods': instance.pkgList};

PkgListItem _$Pkg_listFromJson(Map<String, dynamic> json) {
  return PkgListItem(json['id'] as String, json['name'] as String,
      json['price'] as String);
}

Map<String, dynamic> _$Pkg_listToJson(PkgListItem instance) => <String, dynamic>{
      'id': instance.pkgId,
      'name': instance.pkgName,
      'price': instance.pkgPrice
    };
