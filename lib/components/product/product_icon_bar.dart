import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/classes/product.dart';
import 'package:greentrition/components/product/change_request.dart';
import 'package:greentrition/functions/navigator.dart';
import 'package:greentrition/functions/product.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:share_plus/share_plus.dart';

class ProductIconBar extends StatefulWidget {
  final Product product;

  const ProductIconBar({Key key, this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductIconBarState();
  }
}

class ProductIconBarState extends State<ProductIconBar> {
  bool starred = false;
  final double iconSize = 32;

  @override
  void initState() {
    starredStatus(this.widget.product.id).then((value) =>
        setState(() {
          starred = value;
        }));
    super.initState();
  }

  void back() {
    navigatorPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 5, right: 15),
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Image.asset(
                  "assets/icons/zuruck.png",
                  scale: 20,
                ),
                onPressed: back,
              ),
              Row(
                children: [IconButton(
                    splashRadius: 25,
                    iconSize: iconSize,
                    icon: Icon(Icons.ios_share),
                    onPressed: () async {
                      await Share.share(this.widget.product.brands + " " + this.widget.product.product_name
                          + "\n" + "https://greentrition.de/product?id=" + this.widget.product.id);
                    }),
                  starred
                      ? IconButton(
                      splashRadius: 25,
                      iconSize: iconSize,
                      icon: IconShadowWidget(
                          Icon(Icons.star, color: Colors.yellow[600])),
                      onPressed: () {
                        starredToggle(this.widget.product);
                        setState(() {
                          starred = !starred;
                        });
                      })
                      : IconButton(
                      splashRadius: 25,
                      iconSize: iconSize,
                      icon: Icon(Icons.star_outline),
                      onPressed: () {
                        starredToggle(this.widget.product);
                        setState(() {
                          starred = !starred;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  ChangeRequest(
                                    product: this.widget.product,
                                  ),
                              settings: RouteSettings(
                                  name: "ChangeRequest page")));
                    },
                    child: Container(
                      child: Text(
                        "?",
                        style:
                        TextStyle(fontFamily: "Quicksand", fontSize: 35.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}
