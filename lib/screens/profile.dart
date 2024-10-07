import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greentrition/components/profile/history_widget.dart';
import 'package:greentrition/components/profile/profile_informations.dart';
import 'package:greentrition/components/profile/starred_products.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/gradients.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/functions/user.dart';
import 'package:greentrition/screens/settings.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  int redrawValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
          color: Color(0xffdfcea1),
          gradient: backgroundGradient),
      child: Padding(
        padding: padding_top,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
              child: Stack(children: [
                kIsWeb ? Container(height: 0, width: 0,):
            Positioned(
                right: 0,
                top: 0,
                child: Padding(
                  padding: padding_left_and_right,
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Settings(),
                              settings: RouteSettings(name: "Settings")));
                      //redraw
                      setState(() {
                        ++redrawValue;
                      });
                    },
                    icon: Icon(Icons.settings),
                  ),
                )),
            Column(
              children: [
                Padding(
                  padding: padding_left_and_right,
                  child: ProfileInformation(),
                ),
                Divider(
                  thickness: 1,
                ),
                Flexible(
                  child: DefaultTabController(
                    length: 2,
                    child: Padding(
                      padding: padding_left_and_right,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: TabBar(
                          labelColor: colorGreen,
                          indicatorColor: colorGreen,
                          unselectedLabelColor: colorGreen.withOpacity(0.5),
                          tabs: [
                            Tab(icon: Icon(Icons.subject)),
                            Tab(icon: Icon(Icons.star)),
                            // Tab(icon: Icon(Icons.chat_bubble),)
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: HistoryWidget(),
                            ),
                            FutureBuilder(
                              future: isPremium(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: StarredProducts(snapshot.data),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 0,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ])),
        ),
      ),
    );
  }
}
