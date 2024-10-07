import 'dart:convert';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/exceptions/custom_exception.dart';
import 'package:html/dom.dart';
import 'package:greentrition/classes/product.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

const proxyurl = "http://greentrition.de:8080/";

Future<Product> queryEdeka(String code) async {
  String url = "https://lmiv-backend.edeka-foodservice.de/v1/search?q=" +
      code +
      "&page=0&size=10&sort=productName,asc";

  var resp = await http.get(Uri.parse(url), headers: {"origin": "localhost"});

  Map<String, dynamic> json_obj = jsonDecode(resp.body);
  String article_number;
  String region;
  if (json_obj["content"].length > 1) {
    article_number = json_obj["content"][1]["articleNumber"];
    print(json_obj["content"][1]);
    region = json_obj["content"][1]["region"]["key"];
  }

  url = "https://lmiv-backend.edeka-foodservice.de/v1/product/" +
      region +
      "/" +
      article_number;

  resp = await http.get(Uri.parse(url), headers: {"origin": "localhost"});

  Product product;

  if (resp.statusCode == 200) {
    product = getProductFromData(utf8.decode(resp.bodyBytes), code);
    //Saving product to db
    FirebaseDbAdapter().db.saveProduct(product);
    return product;
  } else {
    return null;
  }
}

String getQueryId(body) {
  String article_nr = body["response"]["docs"][0]["id_tlc"];
  if (body["response"]["numFound"] > 1) {
    article_nr = body["response"]["docs"][1]["id_tlc"];
  }
  print("Artikelnr: $article_nr");
  return article_nr;
}

Product getProductFromData(body, String code) {
  var unescape = HtmlUnescape();
  body = unescape.convert(body);
  Map<String, dynamic> jsonData = jsonDecode(body);
  String product_name = jsonData["productName"]
      .replaceAll("RAEUMARTIKEL", "")
      .replaceAll("ODZ", "")
      .trim();
  String brands = jsonData["responsibleManufacturer"]["name"];
  String quantity = jsonData["netCapacity"] + jsonData["netCapacityUnit"];
  var result = readIngredients(jsonData["ingredients"]);
  List<String> ingredients = result[0],
      additional_information = List<String>.of(result[1]);

  for (String elem in jsonData["allergens"]) {
    additional_information.add(elem);
  }

  Map<String, String> nutritional_values_100 = Map();
  for (Map<String, dynamic> nutrient in jsonData["nutrients"]) {
    nutritional_values_100[nutrient["nutrient"].toString()] =
        nutrient["amountPerBase"];
  }

  print(nutritional_values_100);
  print(brands);
  print(product_name);
  print(quantity);
  print(ingredients);
  print(additional_information);

  String stores = "Edeka";
  String countries = "Germany";
  String date_added = DateTime.now().millisecondsSinceEpoch.toString();

  if (product_name == null || brands == null) {
    print("Something is wrong. Initialization failed.");
    throw CustomException("Product initialization failed.");
  }

  Product product = Product(
      additional_information,
      brands,
      code,
      countries,
      date_added,
      code,
      ingredients,
      product_name,
      quantity,
      stores,
      nutritional_values_100);

  // the found gtin is probably  wrong
  if (code.length != jsonData["gtin"].length) {
    product = null;
  }

  return product;
}

String getBrands(Document document) {
  String brands = "";
  var unescape = HtmlUnescape();
  String name = "Verantwortlicher Lebensmittelunternehmer";
  var text_fields = document.querySelectorAll("h2");
  for (int i = 0; i < text_fields.length; i++) {
    if (text_fields[i].innerHtml.indexOf(name) != -1) {
      brands = unescape.convert(
          document.querySelectorAll("p.text-field")[0].innerHtml.trim());
    }
  }
  return brands;
}

String getContent(Document document, String name) {
  var unescape = HtmlUnescape();

  var elements = document.querySelectorAll("h2");
  String content = "";
  for (int i = 0; i < elements.length; i++) {
    if (elements[i].innerHtml.trim().contains(name)) {
      if (document.querySelectorAll("h2").length !=
          document.querySelectorAll("p.text-field").length) {
        content =
            document.querySelectorAll("p.text-field")[i + 1].innerHtml.trim();
      } else {
        content = document.querySelectorAll("p.text-field")[i].innerHtml.trim();
      }
    }
  }

  return unescape.convert(content);
}

List<List<String>> readIngredients(String ingredients_string) {
  RegExp exp = RegExp(" ",
      caseSensitive: false);
  var match = exp.firstMatch(ingredients_string);

  List<String> additional_info = [];
  List<String> temp_ings = [];
  if (match != null) {
    int index = match.start;
    temp_ings = [
      ingredients_string.substring(0, index),
      ingredients_string.substring(index + 1)
    ];

    if (temp_ings.length > 1) {
      additional_info.add(temp_ings[1]);
      ingredients_string = temp_ings[0];
    }
  }

  ingredients_string = ingredients_string.replaceFirst("*", "");

  //Extract extra information
  exp = RegExp("\\*+[ ]*[A-Za-zÀ-ž\u0370-\u03FF\u0400-\u04FF]+.*",
      caseSensitive: false, unicode: true, dotAll: true);
  match = exp.firstMatch(ingredients_string);
  if (match != null) {
    additional_info.add(ingredients_string.substring(match.end));
    ingredients_string = ingredients_string.substring(0, match.start);
  }

  //Get Ingredients
  //First part: percentage, second part any word with "-" , ":" or whitespace but also e.g. E 472e, words numbers after
  exp = RegExp(
    "(\\d*,?\.?\\d*\\s?\u0025)?\\s*([A-Za-zÀ-ž\u0370-\u03FF\u0400-\u04FF]-?\:?\\d*\u0025?\\s?\\d*\u0025?)+\s*((\\(([A-Za-zÀ-ž\u0370-\u03FF\u0400-\u04FF]*\\s*\\d*\u0025?\\s*\u0025?-*'*´*,*\\s*|([A-Za-zÀ-ž\u0370-\u03FF\u0400-\u04FF]*\\s*\\d*\u0025?\\s*\u0025?,*))*)\\)*)?",
    caseSensitive: false,
    unicode: false,
  );

  var matches = exp.allMatches(ingredients_string).toList();
  List<String> ingredients = [];
  try {
    for (int i = 0; i < matches.length; i++) {
      String temp =
          ingredients_string.substring(matches[i].start, matches[i].end).trim();
      if (temp[0] == ",") {
        temp = temp.substring(1);
      }
      if (i == matches.length - 1) {
        temp.replaceFirst(".", "");
      }
      ingredients.add(temp);
    }
  } catch (err) {
    print(err);
    print("No ingredients found.");
  }

  print("RET:");
  print(match);
  return [ingredients, additional_info];
}

Map<String, String> getNutritionalValues(Document document) {
  Map<String, String> nutritional_values_100;
  try {
    var table_length =
        document.querySelector("tbody").querySelectorAll("tr").length;
    for (int i = 1; i < table_length - 1; i++) {
      nutritional_values_100[document
              .querySelector("tbody")
              .querySelectorAll("tr")[i]
              .querySelector("td")
              .innerHtml] =
          document
              .querySelector("tbody")
              .querySelectorAll("tr")[i]
              .getElementsByTagName("td")[1]
              .innerHtml;
    }
    return nutritional_values_100;
  } catch (err) {
    //console.log(err);
    print("No nutrition table found");
    return null;
  }
}
