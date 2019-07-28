// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInfo _$ProductInfoFromJson(Map<String, dynamic> json) {
  return ProductInfo((json['productlist'] as List)
      ?.map(
          (e) => e == null ? null : Product.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$ProductInfoToJson(ProductInfo instance) =>
    <String, dynamic>{'productlist': instance.productlist};

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
      json['descId'] as String,
      json['descTitle'] as String,
      json['descContent'] as String,
      json['descImageUrl'] as String,
      json['descVisitUrl'] as String);
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'descId': instance.descId,
  'descTitle': instance.descTitle,
  'descContent': instance.descContent,
  'descImageUrl': instance.descImageUrl,
  'descVisitUrl': instance.descVisitUrl
};
