class Product {
  //Either String or List<String>
  dynamic additional_info;
  String brands;
  String code;
  String countries;
  String date_added;
  String id;
  List<String> ingredients;
  String product_name;
  String quantity;
  String stores;
  Map<String, String> nutritional_values;

  Product(
      dynamic additional_info,
      String brands,
      String code,
      String countries,
      String date_added,
      String id,
      List<String> ingredients,
      String product_name,
      String quantity,
      String stores,
      Map<String, String> nutritional_values) {
    this.additional_info = additional_info;
    this.brands = brands;
    this.code = code;
    this.countries = countries;
    this.date_added = date_added;
    this.id = id;
    this.ingredients = ingredients;
    this.product_name = fixProductName(product_name, brands);
    this.quantity = quantity;
    this.stores = stores;
    this.nutritional_values = nutritional_values;
  }

  Product.fromStepper(String brands, String productName, String barcode,
      List<String> ingredients)
      : this.brands = brands,
        this.product_name = fixProductName(productName, brands),
        this.code = barcode,
        this.ingredients = ingredients,
        this.id = barcode,
        countries = "Germany",
        date_added = DateTime.now().millisecondsSinceEpoch.toString();
}

class HistoryProduct {
  String id;
  String product_name;

  HistoryProduct(
    String id,
    String product_name,
  ) {
    this.id = id;
    this.product_name = product_name;
  }
}

//Case: Product name includes brand

String fixProductName(String productName, String brand) {
  if (productName.contains(brand)) {
    productName = productName.replaceFirst(brand, "");
  }
  return productName;
}
