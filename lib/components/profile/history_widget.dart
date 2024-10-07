import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/components/profile/custom_listview.dart';
import 'package:greentrition/functions/history.dart';

class HistoryWidget extends StatelessWidget {

  HistoryWidget() {
  }

  @override
  Widget build(BuildContext context) {
    return CustomListView(getHistory());
  }
}
