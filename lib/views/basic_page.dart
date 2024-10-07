import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/gradients.dart';
import 'package:greentrition/functions/navigator.dart';

class BasicPage extends StatefulWidget {
  final Widget content;
  final Widget onStack1;
  final Widget onStack2;
  final bool showBackButton;

  const BasicPage(
      {Key key,
      this.content,
      this.onStack1 = const SizedBox(
        height: 0,
      ),
      this.onStack2 = const SizedBox(
        height: 0,
      ),
      this.showBackButton = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BasicPageState();
  }
}

class BasicPageState extends State<BasicPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //TODO subject to change
        height: double.infinity,
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Stack(
          children: [
            this.widget.content,
            this.widget.showBackButton
                ? iconBar()
                : SizedBox(
                    height: 0,
                  ),
            this.widget.onStack1,
            this.widget.onStack2
          ],
        ),
      ),
    );
  }

  void back() {
    navigatorPop(context);
  }

  Widget iconBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 5),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/icons/zuruck.png",
                scale: 20,
              ),
              onPressed: back,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
