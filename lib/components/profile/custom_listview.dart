import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/functions/ImageGetter.dart';
import 'package:greentrition/functions/colors.dart';
import 'package:greentrition/functions/nutrition_check.dart';
import 'package:greentrition/views/product.dart';

class CustomListView extends StatelessWidget {
  Future _future;

  CustomListView(Future future) {
    this._future = future;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      thickness: 3.0,
      child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: ExpansionTile(

                          expandedAlignment: Alignment.centerLeft,
                          title: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ProductView(
                                              id: snapshot.data[index].id,
                                            )));
                              },
                              child: Text(
                                snapshot.data[index].product_name,
                                style: standardStyle,
                              )),
                          children: [
                            //Get Product information
                            FutureBuilder(
                              future: FirebaseDbAdapter()
                                  .db
                                  .getProductById(snapshot.data[index].id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  //CategoryChips from ingredient information
                                  return FutureBuilder(
                                    future: getIngredientInformation(
                                        snapshot.data.ingredients),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        List<Widget> categoryChips = snapshot
                                            .data
                                            .getTrueNutrition()
                                            .map<Widget>((x) => CategoryChip(x))
                                            .toList();
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Wrap(
                                            spacing: 5,
                                            runSpacing: 2,
                                            children: categoryChips,
                                          ),
                                        );
                                      } else {
                                        return SizedBox(
                                          height: 0,
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return SizedBox(
                                    height: 0,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorVegan),
                ),
              );
            }
          }),
    );
  }
}

class CategoryChip extends StatelessWidget {
  Category _category;

  CategoryChip(Category category) {
    _category = category;
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: EdgeInsets.all(5),
      label:ImageGetter.getCategoryTextIcon(_category, fontSize: 16),
      // label: Text(category_included_text[_category],
      //     style: GoogleFonts.openSans(
      //       fontSize: 15,
      //       color: textColorFromHex(colorFromCategory(_category)),
      //     )),
      backgroundColor: colorFromCategory(_category),
    );
  }
}

class HistoryEntry {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;

  HistoryEntry(header, body, iconpic, {bool isExpanded = false})
      : header = header,
        body = body,
        iconpic = iconpic;
}
