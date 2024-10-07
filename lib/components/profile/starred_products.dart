import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/components/profile/custom_listview.dart';
import 'package:greentrition/components/store/NoPremiumStatus.dart';
import 'package:greentrition/functions/product.dart';

class StarredProducts extends StatelessWidget {
  bool isPremium = false;

  StarredProducts(bool isPremium) {
    this.isPremium = isPremium;
  //  TODO REMOVE ALWAYS PREMIUM
    this.isPremium = true;
  }

  @override
  Widget build(BuildContext context) {
    return !isPremium
        ? NoPremiumStatus()
        : CustomListView(getStarredProducts());
  }
}
