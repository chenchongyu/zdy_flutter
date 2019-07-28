import 'package:json_annotation/json_annotation.dart';

part 'product_info.g.dart';

@JsonSerializable()
class ProductInfo {
  @JsonKey(name: 'productlist')
  List<Product> productlist;

  ProductInfo(this.productlist);

  factory ProductInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductInfoToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: 'descId')
  String descId;
  @JsonKey(name: 'descTitle')
  String descTitle;
  @JsonKey(name: 'descContent')
  String descContent;
  @JsonKey(name: 'descImageUrl')
  String descImageUrl;
  @JsonKey(name: 'descVisitUrl')
  String descVisitUrl;

  Product(this.descId, this.descTitle, this.descContent, this.descImageUrl,
      this.descVisitUrl);

  factory Product.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
