//对列表item数据的封装，根据不同的type显示不同的卡片
class ListItemData<T> {
  static const int TYPE_HEADER = 1;
  static const int TYPE_IMAGE = 2;
  static const int TYPE_CHECKBOX = 3;
  static const int TYPE_ITEM_TITLE = 4;
  static const int TYPE_ITEM = 5;

  int type;
  T data;

  ListItemData(this.type, this.data);


}
