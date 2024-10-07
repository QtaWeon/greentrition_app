import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:pie_chart/pie_chart.dart';

class NutriChart extends StatefulWidget {
  final Map<String, String> nutritional_values;

  const NutriChart({Key key, this.nutritional_values}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NutriChartState();
  }
}

class NutriChartState extends State<NutriChart> {
  Map<String, double> dataMap = null;

  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
    Color(0xff30584)
  ];

  @override
  void initState() {
    print(this.widget.nutritional_values);
    if (this.widget.nutritional_values != null) {
      this.widget.nutritional_values.forEach((key, value) {
        //format mg to grams
        if (value.contains("mg")) {
          var val = value.replaceAll("mg", "").replaceAll("<", "").replaceAll(",", ".");
          this.widget.nutritional_values[key] =
              (double.parse(val) * 0.001).toString();
        }
      });

      dataMap = this
          .widget
          .nutritional_values
          .map((key, value) => MapEntry(
              key,
              double.parse(value
                  .replaceAll("<", "")
                  .replaceAll("kcal", "")
                  .replaceAll("kj", "")
                  .replaceAll("g", "")
                  .replaceAll(",", "."))))
          .cast<String, double>();
      dataMap.remove("Energie");
      dataMap.remove("Kilokalorien");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dataMap == null || dataMap.isEmpty
        ? SizedBox(
            height: 0,
          )
        : Container(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorContainer,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      color: colorShadowBlack)
                ]),
            child: PieChart(
              emptyColor: Colors.white,

              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              // TODO ADD NUTRI SCORE
              // centerText: "A",
              // centerTextStyle: GoogleFonts.openSans(
              //     fontSize: 30,
              //     color: colorTextShadowGreen,
              //     fontWeight: FontWeight.bold),
              ringStrokeWidth: 28,
              legendOptions: LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: true,
                decimalPlaces: 1,
              ),

              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
          );
  }
}
