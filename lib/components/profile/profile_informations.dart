import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/functions/user.dart';

class ProfileInformation extends StatefulWidget {
  final String userName;
  final String userId;

  const ProfileInformation({Key key, this.userName = "", this.userId = ""})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileInformationState();
  }
}

class ProfileInformationState extends State<ProfileInformation> {
  bool userIdInitialized = false;
  String userName = "";
  String userId;
  String premiumCrown = "👑";
  bool isPremium = false;
  Duration fadeDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    if (this.widget.userId.length != 0 && this.widget.userName.length != 0) {
      this.userId = this.widget.userId;
      this.userName = this.widget.userName;
      userIdInitialized = true;
    } else {
      getUsername().then((userName) {
        setState(() {
          this.userName = userName;
        });
        getUserId().then((value) {
          setState(() {
            userId = value;
            userIdInitialized = true;
          });
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      //Wichtig
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 7, color: colorShadowBlack, spreadRadius: 0.2)
                ],
              ),
              child: CircleAvatar(
                child: Stack(children: [
                  Center(
                    child: Text(
                      userName.length == 0 ? "" : userName[0],
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ]),
                radius: 50,
                backgroundColor: colorTextDark,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        userIdInitialized
            ? FutureBuilder(
                future: AppDb.getUserInformation(userId),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: tabBarStyle,
                          ),
                          snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData && snapshot.data.premium
                              ? Text(
                                  this.premiumCrown,
                                  style: tabBarStyle,
                                )
                              : SizedBox(
                                  height: 0,
                                )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 2, top: 3),
                          child: Row(
                            children: [
                              Column(children: [
                                Icon(Icons.thumb_up),
                                AnimatedOpacity(
                                    duration: fadeDuration,
                                    opacity: snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData
                                        ? 1
                                        : 0,
                                    child: Text(snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData
                                        ? snapshot.data.likes.toString()
                                        : "")),
                              ]),
                              SizedBox(
                                width: 20,
                              ),
                              Column(children: [
                                Icon(Icons.comment),
                                AnimatedOpacity(
                                    duration: fadeDuration,
                                    opacity: snapshot.connectionState ==
                                            ConnectionState.done
                                        ? 1
                                        : 0,
                                    child: Text(snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData
                                        ? snapshot.data.comments.toString()
                                        : ""))
                              ])
                            ],
                          ))
                    ],
                  );
                })
            : SizedBox(
                height: 0,
              ),
      ],
    ));
  }
}
