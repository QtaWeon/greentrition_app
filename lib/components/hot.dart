import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/views/product.dart';

class Hot extends StatelessWidget {
  Category category;

  Hot(Category category) {
    this.category = category;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.campaign_outlined),
            SizedBox(
              width: 5,
            ),
            Text("Angesagt",
                style: GoogleFonts.quicksand(
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 0.5,
                          offset: Offset.zero)
                    ],
                    fontSize: 20,
                    color: colorTextDark,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder(
            future: AppDb.getHotItems(category, amount: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Divider(
                      height: 0,
                    ),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ProductView(
                                        id: snapshot.data[index].id,
                                        saveToHistory: false,
                                      )));
                        },
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        title: Text(
                          snapshot.data[index].name,
                          style: standardStyle,
                        ),
                        trailing: Wrap(
                          children: [
                            Icon(
                              Icons.comment,
                              size: 15,
                            ),
                            Text(
                              " " +
                                  snapshot.data[index].commentsAmount
                                      .toString(),
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorVegan),
                );
              }
            })
      ],
    );
  }
}
