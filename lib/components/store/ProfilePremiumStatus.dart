import 'package:flutter/cupertino.dart';
import 'package:greentrition/views/basic_page.dart';

class ProfilePremiumStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePremiumStatusState();
  }
}

class ProfilePremiumStatusState extends State<ProfilePremiumStatus> {
  @override
  Widget build(BuildContext context) {
    return BasicPage(
      content: Container(
        child: Column(
          children: [
            Text("TODO Funktion noch nicht implementiert"),
          ],
        ),
      ),
      showBackButton: false,
    );
  }
}
