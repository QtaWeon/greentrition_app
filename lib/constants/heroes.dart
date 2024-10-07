import 'package:flutter/material.dart';
import 'package:greentrition/views/heros/vegan_hero.dart';
import 'package:greentrition/views/heros/histamine_hero.dart';
import 'package:greentrition/views/heros/vegetarian_hero.dart';
import 'package:greentrition/views/heros/gluten_hero.dart';
import 'package:greentrition/views/heros/sugar_hero.dart';
import 'package:greentrition/views/heros/fructose_hero.dart';

Map<String, Widget> tagToHero = {
  "vegan": VeganHero(),
  "vegetarian": VegetarianHero(),
  "sugar": SugarHero(),
  "fructose": FructoseHero(),
  "gluten": GlutenHero(),
  "histamine": HistamineHero(),
};

class HeroFactory {
  static Widget tagToHero(String tag) {
    switch (tag) {
      case "vegan":
        return VeganHero();
      case "vegetarian":
        return VegetarianHero();
      case "sugar":
        return SugarHero();
      case "fructose":
        return FructoseHero();
      case "gluten":
        return GlutenHero();
      case "histamine":
        return HistamineHero();
    }
  }
}
