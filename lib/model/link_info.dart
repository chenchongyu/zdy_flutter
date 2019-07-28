import 'package:json_annotation/json_annotation.dart';

part 'link_info.g.dart';

@JsonSerializable()
class LinkInfo {
  @JsonKey(name: 'linklist')
  List<Link> linklist;

  LinkInfo(this.linklist);

  factory LinkInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$LinkInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LinkInfoToJson(this);
}

@JsonSerializable()
class Link {
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

  Link(this.descId, this.descTitle, this.descContent, this.descImageUrl,
      this.descVisitUrl);

  factory Link.fromJson(Map<String, dynamic> srcJson) =>
      _$LinkFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
