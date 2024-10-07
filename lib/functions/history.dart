import 'dart:convert';
import 'dart:core';

import 'package:greentrition/classes/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Add Products to history
void addToHistory(Product product) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var history = prefs.getStringList("history") ?? List<String>();
  history.add("{\"product_name\" : \"" +
      product.brands +
      " " +
      product.product_name +
      "\","
          " \"id\" : \"" +
      product.id +
      "\"}");
  if (history.length > 100) {
    history.removeAt(0);
  }
  prefs.setStringList("history", history.toList());
}

///Get Product history list
Future<List<HistoryProduct>> getHistory() async {
  List<HistoryProduct> retVal = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var history = prefs.getStringList("history") ?? List<String>();
  history
      .map((e) => Map<String, String>.from(json.decode(e)))
      .toList()
      .forEach((element) {
    retVal.add(HistoryProduct(element["id"], element["product_name"]));
  });
  return retVal.reversed.toList();
}
