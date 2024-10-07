import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/components/images/image_viewer.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/views/basic_page.dart';

class ProductImage extends StatefulWidget {
  final bool hasImage;
  final Image img;

  const ProductImage({Key key, this.hasImage, this.img}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductImageState();
  }
}

class ProductImageState extends State<ProductImage>
    with TickerProviderStateMixin {
  double height = 200;
  double expanded = 200;
  double collapsed = 50;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.hasImage
        ? Stack(children: [
            GestureDetector(
              onTap: () {
                if (this.widget.hasImage) {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) {
                      return BasicPage(
                          content: Container(
                              child: ImageViewer(this.widget.img.image)));
                    },
                  ));
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                height: this.height,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorContainer,
                    image: DecorationImage(
                        image: this.widget.img.image, fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          color: colorShadowBlack)
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: this.height == collapsed
                    ? Icon(Icons.keyboard_arrow_down_rounded)
                    : Icon(Icons.keyboard_arrow_up_rounded),
                iconSize: 30,
                onPressed: () {
                  if (height == expanded) {
                    setState(() {
                      this.height = collapsed;
                    });
                  } else {
                    setState(() {
                      this.height = expanded;
                    });
                  }
                },
              ),
            )
          ])
        : SizedBox(
            height: 0,
          );
  }
}
