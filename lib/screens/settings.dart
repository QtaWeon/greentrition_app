import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/classes/user.dart';
import 'package:greentrition/components/custom_sliver_app_bar.dart';
import 'package:greentrition/components/registration/sign_in_buttons.dart';
import 'package:greentrition/components/settings/nutrition_selection.dart';
import 'package:greentrition/components/store/landing.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/functions/navigator.dart';
import 'package:greentrition/functions/user.dart';
import 'package:greentrition/views/basic_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  String _user_name = "";
  bool isLoggedIn = false;
  User user;

  @override
  void initState() {
    initSettings();
    AppDb.getUser().then((value) {
      user = value;
    });

    super.initState();
  }

  void initSettings() {
    getUsername().then((value) {
      setState(() {
        _user_name = value;
      });
    });
    isFreeUser().then((value) {
      setState(() {
        isLoggedIn = !value;
      });
    });
  }

  void back() {
    navigatorPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
        showBackButton: false,
        content: CupertinoScrollbar(
            thickness: 3.0,
            child: CustomScrollView(
              slivers: [
                CustomSliverAppBar("Einstellungen"),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: padding_left_and_right,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorTextDark),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      isLoggedIn
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white),
                                              child: ListTile(
                                                onTap: () {},
                                                title: Text(
                                                  _user_name.length == 0
                                                      ? "Dein Name"
                                                      : _user_name,
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colorTextDark),
                                                ),
                                                leading:
                                                    Icon(Icons.verified_user),
                                              ),
                                            )
                                          : SignInButtons(
                                              callback: this.initSettings,
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // TODO UNCOMMENT! Use lifetime ad removal instead of subsription?
                            // Text(
                            //   "Unterstützen",
                            //   style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.bold,
                            //       color: colorTextDark),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(15),
                            //       color: Colors.white),
                            //   width: double.infinity,
                            //   child: ListTile(
                            //     leading: Text(
                            //       "👑",
                            //       style: TextStyle(fontSize: 20),
                            //     ),
                            //     title: Text(
                            //       "Premium",
                            //       style: GoogleFonts.openSans(
                            //           fontWeight: FontWeight.w600,
                            //           color: colorTextDark),
                            //     ),
                            //     onTap: () {
                            //       if (isLoggedIn) {
                            //         Navigator.of(context)
                            //             .push(CupertinoPageRoute(
                            //           builder: (context) {
                            //             return PremiumLanding(user: this.user);
                            //           },
                            //         ));
                            //       } else {
                            //         Fluttertoast.showToast(
                            //             msg: "Bitte log Dich ein");
                            //       }
                            //     },
                            //     trailing: Icon(Icons.arrow_forward_ios),
                            //   ),
                            // ),
                            SizedBox(height: 20),
                            Text(
                              "Intoleranzen / Allergien",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorTextDark),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            NutritionSelection(),
                            SizedBox(
                              height: 20,
                            ),
                            isLoggedIn
                                ? Center(
                                    child: OutlinedButton(
                                      // highlightElevation: 1,
                                      // highlightedBorderColor: Colors.red,
                                      // borderSide:
                                      //     BorderSide(color: colorRedIngredient),
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10)),
                                      onPressed: () {
                                        logoutUser();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Logout"),
                                    ),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            Divider(
                              thickness: 1,
                            ),
                            TextButton(
                                onPressed: () {
                                  launch("https://greentrition.de/privacy",
                                      forceWebView: true);
                                },
                                child: Text(
                                  "Datenschutz",
                                  style: TextStyle(
                                      color: colorTextDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                            TextButton(
                                onPressed: () {
                                  showAboutDialog(
                                      context: context,
                                      applicationName: "greentrition");
                                },
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                      color: colorTextDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorContainer),
                              child: Text(
                                "Alle Angaben zu den Ernährungsweisen sind ohne Gewähr und selbst zu überprüfen. Die Datenbank wird stetig aktualisiert und es werden neue Inhaltsstoffe aufgenommen. Trotzdem kann es in Einzelfällen dazu kommen, dass Angaben fehlerhaft sind oder fehlen."
                                "\nKontakt: hello@greentrition.de",
                                style: GoogleFonts.openSans(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
