class ProductIndex {
  String code;
  String date_added;
  String id;
  String product_name;

  ProductIndex (String code, String date_added, String id, String product_name) {
    this.code = code;
    this.date_added = date_added;
    this.id = id;
    this.product_name = product_name.trim();
  }
}