import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:greentrition/classes/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> starredStatus(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool foundId = false;

  List<String> starredItems = prefs.getStringList("starred") ?? List<String>();
  starredItems
      .map((e) => Map<String, String>.from(json.decode(e)))
      .toList()
      .forEach((element) {
    if (element["id"] == id) {
      foundId = true;
    }
  });

  return foundId;
}

void starredToggle(Product product) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool foundId = false;
  var foundElement;

  List<String> starredItems = prefs.getStringList("starred") ?? List<String>();
  starredItems
      .map((e) => Map<String, String>.from(json.decode(e)))
      .toList()
      .forEach((element) {
    if (element["id"] == product.id) {
      foundId = true;
      foundElement = element;
    }
  });

  if (foundId) {
    starredItems.remove(foundElement);
  } else {
    starredItems.add("{\"product_name\" : \"" +
        product.brands +
        " " +
        product.product_name +
        "\","
            " \"id\" : \"" +
        product.id +
        "\"}");
  }

  prefs.setStringList("starred", starredItems);
}

Future<List<HistoryProduct>> getStarredProducts() async {
  List<HistoryProduct> retVal = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> starredItems = prefs.getStringList("starred") ?? List<String>();
  starredItems
      .map((e) => Map<String, String>.from(json.decode(e)))
      .toList()
      .forEach((element) {
    retVal.add(HistoryProduct(element["id"], element["product_name"]));
  });

  return retVal.reversed.toList();
}
