import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/components/custom_sliver_app_bar.dart';
import 'package:greentrition/components/category_page.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/views/basic_page.dart';

class HistamineHero extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistamineHeroState();
  }
}

class HistamineHeroState extends State<HistamineHero> {
  @override
  Widget build(BuildContext context) {
    return BasicPage(
        showBackButton: false,
        content: CupertinoScrollbar(
            thickness: 3.0,
            child: CustomScrollView(
              slivers: [
                CustomSliverAppBar("Histaminarm"),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      Container(
                          padding: padding_left_and_right,
                          child: CategoryPage(Category.histamine)),
                      // Recipes(Category.histamine),
                      // Recipes(Category.histamine),
                    ],
                  )
                ]))
              ],
            )));
  }
}
