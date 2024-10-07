import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Nutrition extends StatelessWidget {
  List<Category> trueList;
  List<Category> falseList;

  Nutrition(trueList, falseList) {
    this.trueList = trueList;
    this.falseList = falseList;
  }

  Widget trueWidget() {
    return Flexible(
      child: Column(children: [
        // Container(
        //   padding: EdgeInsets.all(5),
        //   height: 25,
        //   width: 25,
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle, color: colorGreen.withOpacity(0.26)),
        //   child: Container(
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.transparent,
        //         border: Border.all(color: colorGreen, width: 2)),
        //   ),
        // ),
        ListView.builder(
          itemBuilder: (BuildContext context, index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  category_text_icon[trueList[index]] +
                      " " +
                      category_included_text[trueList[index]],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(color: colorGreen, fontSize: 16)),
            );
          },
          itemCount: trueList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ]),
    );
  }

  Widget falseWidget() {
    return Flexible(
      child: Column(children: [
        // Container(
        //   padding: EdgeInsets.all(6),
        //   height: 25,
        //   width: 25,
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle, color: colorRed.withOpacity(0.26)),
        //   child: Container(
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.transparent,
        //         border: Border.all(color: colorRed, width: 2)),
        //   ),
        // ),
        ListView.builder(
          itemBuilder: (BuildContext context, index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "❌ " + category_not_included_text[falseList[index]],
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(color: colorRed, fontSize: 15),
              ),
            );
          },
          itemCount: falseList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    //assume that any of the lists has >= 1 elements
    return trueList.length >= 1 || falseList.length >= 1
        ? Container(
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
            child: Row(
              mainAxisAlignment: trueList.length >= 1 && falseList.length >= 1
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                trueList.length >= 1
                    ? trueWidget()
                    : falseList.length >= 1
                        ? falseWidget()
                        : Column(),
                trueList.length >= 1 && falseList.length >= 1
                    ? falseWidget()
                    : Spacer(),
              ],
            ),
          )
        : Container(width: 0.0, height: 0.0);
  }
}
