class ProductItem {
  String code;
  String id;
  String date_added;
  String name;
  int commentsAmount;

  ProductItem(String code, String id, String date_added, String name,
      int commentsAmount) {
    this.code = code;
    this.commentsAmount = commentsAmount;
    this.date_added = date_added;
    this.name = name;
    this.id = id;
  }
}
