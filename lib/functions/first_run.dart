import 'package:shared_preferences/shared_preferences.dart';
import 'package:greentrition/constants/categories.dart';

import 'nutrition.dart';

Future<bool> isFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstRun = prefs.getBool("firstRun") ?? true;

    //set to false
    if(firstRun) {
      prefs.setBool("firstRun", !firstRun);
    }
    return firstRun;
}

void initializeCategories() {
    setNutrition(Category.vegan, true);
    setNutrition(Category.gluten, true);
    setNutrition(Category.histamine, true);
    setNutrition(Category.vegetarian, true);
}