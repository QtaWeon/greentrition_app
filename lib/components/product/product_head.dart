import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/components/product_registration/product_scanner.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:http/http.dart';

class ProductHeader extends StatefulWidget {
  final double screenHeight;
  final String product_name;
  final String brands;
  final String id;
  final bool hasImage;

  const ProductHeader(
      {Key key,
      this.screenHeight,
      this.product_name,
      this.brands,
      this.id,
      this.hasImage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductHeaderState();
  }
}

class ProductHeaderState extends State<ProductHeader> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // checkImageStatus();
                  // if (hasBackgroundImage) {
                  //   Navigator.of(context).push(CupertinoPageRoute(
                  //     builder: (context) {
                  //       return BasicPage(
                  //           content: ImageViewer(this.img.image));
                  //     },
                  //   ));
                  // }
                },
                child: Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                      // image: DecorationImage(
                      //     image: this.img.image, fit: BoxFit.none),
                      color: colorProductHead,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-1, -1),
                          blurRadius: 5,
                        )
                      ]),
                  child: Stack(alignment: Alignment.center, children: [
                    Align(
                      child: AbsorbPointer(
                        absorbing: this.widget.hasImage,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity: !this.widget.hasImage
                              ? 1.0
                              : 0.0,
                          child: IconButton(
                              onPressed: () async {
                                try {
                                  List<dynamic> retVals =
                                      await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  Camera()));
                                  XFile productPicture = retVals[0];
                                  XFile ingredientsPicture = retVals[1];
                                  productPicture
                                      .readAsBytes()
                                      .then((bytes) {
                                    AppDb.uploadProductImage(
                                        MultipartFile.fromBytes(
                                            "image", bytes,
                                            filename: "front.jpg"),
                                        this.widget.id);
                                  });
                                  ingredientsPicture
                                      .readAsBytes()
                                      .then((bytes) {
                                    AppDb.uploadProductImage(
                                        MultipartFile.fromBytes(
                                            "image", bytes,
                                            filename: "back.jpg"),
                                        this.widget.id);
                                  });
                                } catch (e) {
                                  print(e.toString());
                                  print("No pictures were taken");
                                }
                              },
                              icon: Icon(
                                Icons.add_a_photo_outlined,
                                size: 25,
                              )),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Align(
                          child: AbsorbPointer(
                            absorbing: this.widget.hasImage,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 100),
                              opacity: !this.widget.hasImage
                                  ? 1.0
                                  : 0.0,
                              child: IconButton(
                                  onPressed: () async {
                                    try {
                                      List<dynamic> retVals =
                                      await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  Camera()));
                                      XFile productPicture = retVals[0];
                                      XFile ingredientsPicture = retVals[1];
                                      productPicture
                                          .readAsBytes()
                                          .then((bytes) {
                                        AppDb.uploadProductImage(
                                            MultipartFile.fromBytes(
                                                "image", bytes,
                                                filename: "front.jpg"),
                                            this.widget.id);
                                      });
                                      ingredientsPicture
                                          .readAsBytes()
                                          .then((bytes) {
                                        AppDb.uploadProductImage(
                                            MultipartFile.fromBytes(
                                                "image", bytes,
                                                filename: "back.jpg"),
                                            this.widget.id);
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                      print("No pictures were taken");
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 25,
                                  )),
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                          Text(
                            this.widget.brands,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 6),
                                ],
                                fontSize: 17,
                                color: backgroundColorEnd),
                          ),
                          Text(
                            this.widget.product_name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                      color: Colors.black87,
                                      offset: Offset(1, 1),
                                      blurRadius: 6),
                                ],
                                fontSize: 24,
                                color: backgroundColorEnd),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
  }
}
