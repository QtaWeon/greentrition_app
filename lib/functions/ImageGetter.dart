import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/categories.dart';

class ImageGetter {
  static Image getCategoryAsset(Category category, {double scale = 10.0}) {
    switch (category) {
      case Category.vegan:
        {
          return Image.asset(
            "assets/icons/nutrition/original/vegan.png",
            scale: scale,
          );
        }
      case Category.vegetarian:
        {
          return Image.asset(
            "assets/icons/nutrition/original/milch.png",
            scale: scale,
          );
        }
      case Category.gluten:
        {
          return Image.asset(
            "assets/icons/nutrition/original/bread.png",
            scale: scale,
          );
        }
      case Category.sugar:
        {
          return Image.asset(
            "assets/icons/nutrition/original/anise-candy.png",
            scale: scale,
          );
        }
      case Category.histamine:
        {
          return Image.asset(
            "assets/icons/nutrition/original/tomate.png",
            scale: scale,
          );
        }
      case Category.fructose:
        {
          return Image.asset(
            "assets/icons/nutrition/original/fruits.png",
            scale: scale,
          );
        }
      default:
        {
          throw UnimplementedError("Kategoriebild nicht verfuegbar.");
        }
    }
  }

  static Text getCategoryTextIcon(Category category, {double fontSize = 14.0}) {
    switch (category) {
      case Category.vegan:
        {
          return Text(
            category_text_icon[category],
            style: TextStyle(fontSize: fontSize),
          );
        }
      case Category.vegetarian:
        {
          return Text(
            category_text_icon[category],
            style: TextStyle(fontSize: fontSize),
          );
        }
      case Category.gluten:
        {
          return Text(
            category_text_icon[category],
            style: TextStyle(fontSize: fontSize),
          );
        }
      case Category.sugar:
        {
          return Text(
            category_text_icon[category],
            style: TextStyle(fontSize: fontSize),
          );
        }
      case Category.histamine:
        {
          return Text(
            category_text_icon[category],
            style: TextStyle(fontSize: fontSize),
          );
        }
      case Category.fructose:
        {
          return Text(
            category_text_icon[category],
            style: TextStyle(fontSize: fontSize),
          );
        }
      default:
        {
          throw UnimplementedError("Kategoriebild nicht verfuegbar.");
        }
    }
  }

  static Image getCategoryAssetCompressed(Category category,
      {double scale = 10.0}) {
    switch (category) {
      case Category.vegan:
        {
          return Image.asset(
            "assets/icons/nutrition/compressed/vegan.png",
            scale: scale,
          );
        }
      case Category.vegetarian:
        {
          return Image.asset(
            "assets/icons/nutrition/compressed/milch.png",
            scale: scale,
          );
        }
      case Category.gluten:
        {
          return Image.asset(
            "assets/icons/nutrition/compressed/bread.png",
            scale: scale,
          );
        }
      case Category.sugar:
        {
          return Image.asset(
            "assets/icons/nutrition/compressed/anise_candy.png",
            scale: scale,
          );
        }
      case Category.histamine:
        {
          return Image.asset(
            "assets/icons/nutrition/compressed/tomate.png",
            scale: scale,
          );
        }
      case Category.fructose:
        {
          return Image.asset(
            "assets/icons/nutrition/compressed/fruits.png",
            scale: scale,
          );
        }
      default:
        {
          throw UnimplementedError("Kategoriebild nicht verfuegbar.");
        }
    }
  }
}
