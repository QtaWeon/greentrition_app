import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/components/profile/profile_informations.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/database/db_adapter.dart';

import 'package:intl/intl.dart';

class UserInformation extends StatelessWidget {
  String author;
  String userId;

  UserInformation(String author, String userId) {
    this.author = author;
    this.userId = userId;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: backgroundColorEnd,
        child: Padding(
          padding: padding_all,
          child: Container(
            height: 300,
            child: Column(
              children: [
                ProfileInformation(
                  userName: author,
                  userId: userId,
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: AppDb.getUserInformation(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Beigetreten: " +
                              DateFormat.yMMMM()
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(snapshot.data.date_added),
                                          isUtc: true)
                                      .toLocal())
                                  .toString(),
                          style: GoogleFonts.quicksand(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 0,
                      );
                    }
                  },
                ),
                Text("Letzte Aktivität")
              ],
            ),
          ),
        ));
  }
}
