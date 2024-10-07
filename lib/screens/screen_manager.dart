import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import "package:flutter/cupertino.dart";
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/gradients.dart';
import 'package:greentrition/constants/standard_user.dart';
import 'package:greentrition/database/authorization.dart';
import 'package:greentrition/functions/user.dart';
import 'package:greentrition/screens/home.dart';
import 'package:greentrition/screens/profile.dart';
import 'package:greentrition/screens/camera.dart';

class ScreenManager extends StatefulWidget {
  @override
  ScreenManagerState createState() => ScreenManagerState();
}

class ScreenManagerState extends State<ScreenManager> {
  PageController _pageController;
  int selectedIndex = 0;
  Home home;
  Camera camera;
  Profile profile;
  String userName = " ";

  @override
  void initState() {
    home = Home();
    camera = Camera();
    profile = Profile();
    // Starting page
    if (kIsWeb) {
      selectedIndex = 0;
    } else {
      selectedIndex = 1;
    }

    _pageController = PageController(initialPage: selectedIndex);

    Authorization().authorize();

    //App Data Initialization
    getUsername().then((value) {
      String usr = value;
      if (usr == "") {
        setUsername(free_user);
        userName = free_user;
      } else {
        userName = usr;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void switchItem(int index) async {
    setState(() {
      selectedIndex = index;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(selectedIndex);
      }
    });
  }

  void changePage(int index) {
    setState(() {
      if (index == 1) {
        //Unfocus keyboard
        FocusScope.of(context).unfocus();
      }
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: backgroundGradient, color: backgroundColorEnd),
        child: PageView(
          controller: _pageController,
          onPageChanged: changePage,
          children: [
            home,
            camera,
            profile,
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 5.0, top: 0),
        decoration: BoxDecoration(
          color: backgroundColorEnd,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: footerColor,
          iconSize: 30.0,
          showSelectedLabels: false,
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.lightGreen[100],
                      spreadRadius: 0.2,
                      blurRadius: 25,
                    )
                  ],
                ),
                child: Icon(
                  Icons.home,
                  color: Colors.green,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/scan.png",
                //TODO subject to change
                //color: Color(0xff73716E),
                height: 25,
              ),
              activeIcon: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.lightGreen[100],
                      spreadRadius: 0.2,
                      blurRadius: 25,
                    )
                  ],
                ),
                child: Image.asset(
                  "assets/icons/scan.png",
                  height: 25,
                  color: Colors.green,
                  fit: BoxFit.fill,
                ),
              ),
              label: '',
            ),
            /*BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/einstellungen.png",
                height: 20,
              ),
              label: '',
              activeIcon: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.lightGreen[100],
                      spreadRadius: 0.2,
                      blurRadius: 25,
                    )
                  ],
                ),
                child: Image.asset(
                  "assets/icons/einstellungen_filled.png",
                  height: 20,
                  color: Colors.green,
                  fit: BoxFit.fill,
                ),
              ),
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: '',
              activeIcon: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightGreen[100],
                        spreadRadius: 0.2,
                        blurRadius: 25,
                      )
                    ],
                  ),
                  child:
                      Icon(Icons.account_circle_outlined, color: Colors.green)),
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.lightGreen[800],
          onTap: switchItem,
        ),
      ),
    );
  }
}
