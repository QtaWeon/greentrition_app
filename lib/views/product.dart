import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:greentrition/classes/ingredient.dart';
import 'package:greentrition/classes/product.dart';
import 'package:greentrition/components/product/comments.dart';
import 'package:greentrition/components/product/ingredients.dart';
import 'package:greentrition/components/product/nutrition.dart';
import 'package:greentrition/components/product/nutritional_values.dart';
import 'package:greentrition/components/product/product_head.dart';
import 'package:greentrition/components/product/product_icon_bar.dart';
import 'package:greentrition/components/product/product_image.dart';
import 'package:greentrition/constants/ad_keywords.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/shadows.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/database/media_adapter.dart';
import 'package:greentrition/functions/history.dart';
import 'package:greentrition/functions/nutrition_check.dart';
import 'package:greentrition/product_initialization/edeka.dart';
import 'package:greentrition/views/basic_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductView extends StatefulWidget {
  final String id;
  final bool saveToHistory;

  const ProductView({Key key, this.id, this.saveToHistory = false})
      : super(key: key);

  @override
  ProductViewState createState() => ProductViewState();
}

class ProductViewState extends State<ProductView> {
  Product _product;
  FirebaseDbAdapter dbAdapter;
  bool _initialized;
  IngredientInformation _ingredientInformation;
  Image img;
  bool hasImage = false;

  BannerAd _anchoredAdaptiveAd;
  bool _adLoaded = false;

  final scrollController = ScrollController();

  @override
  void initState() {
    _initialized = false;
    dbAdapter = FirebaseDbAdapter();
    dbAdapter.db.getProductById(this.widget.id).then((value) {
      print("DBADAPT:ID");
      if (value != null) {
        setState(() {
          _product = value;
          _initialized = true;
          getIngredientInformation(_product.ingredients)
              .then((value) => _ingredientInformation = value)
              .then((val) {
            checkIfSafeToHistory();
          });
        });
      } else {
        dbAdapter.db.getProductByCode(this.widget.id).then((value) {
          print("DBADAPT:CODE");
          if (value != null) {
            setState(() {
              _product = value;
              _initialized = true;
              getIngredientInformation(_product.ingredients)
                  .then((value) => _ingredientInformation = value)
                  .then((val) {
                checkIfSafeToHistory();
              });
            });
          } else {
            setState(() {
              queryEdeka(this.widget.id).then((value) {
                setState(() {
                  print(value.ingredients);
                  _product = value;
                  _initialized = true;
                  getIngredientInformation(_product.ingredients)
                      .then((value) => _ingredientInformation = value);
                });
                //save to DB
              }).then((val) {
                checkIfSafeToHistory();
              }).catchError((error) {
                print(error);
                print("No Edeka product found.");
                if (!_initialized) {
                  Navigator.pop(context, false);
                }
              });
            });
          }
        });
      }
    });

    getImage();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void reportError() {}

  void checkIfSafeToHistory() {
    if (this.widget.saveToHistory) {
      addToHistory(_product);
    }
  }

  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return _initialized
        ? BasicPage(
            showBackButton: false,
            onStack1: ProductIconBar(
              product: _product,
            ),
            content: Scaffold(
              body: GlowingOverscrollIndicator(
                color: colorTextShadowGreen,
                axisDirection: AxisDirection.down,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: CupertinoScrollbar(
                    thickness: 3,
                    child: Stack(
                      children: [
                        ProductHeader(
                          product_name: _product.product_name,
                          brands: _product.brands,
                          id: _product.id,
                          screenHeight: MediaQuery.of(context).size.height,
                          hasImage: this.hasImage,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            SafeArea(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30)),
                                    boxShadow: shadowListLowBlur),
                                child: Column(children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 5, right: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Ingredients(
                                            _ingredientInformation.ingredients),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Nutrition(
                                            _ingredientInformation
                                                .getTrueNutrition(),
                                            _ingredientInformation
                                                .getFalseNutrition()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        NutriChart(
                                          nutritional_values:
                                              this._product.nutritional_values,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ProductImage(
                                          hasImage: this.hasImage,
                                          img: this.img,
                                        ),
                                        if (_anchoredAdaptiveAd != null &&
                                            _adLoaded)
                                          Container(
                                            color: Colors.green,
                                            width: _anchoredAdaptiveAd
                                                .size.width
                                                .toDouble(),
                                            height: _anchoredAdaptiveAd
                                                .size.height
                                                .toDouble(),
                                            child: AdWidget(
                                                ad: _anchoredAdaptiveAd),
                                          ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Divider(
                                          color: backgroundColorStart,
                                        ),
                                        Comments(
                                          product_id: this.widget.id,
                                          scrollController: scrollController,
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : BasicPage(
            content: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.20,
              ),
              child: skeleton(),
            ),
          );
  }

  Shimmer skeleton() {
    return Shimmer.fromColors(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.07,
            widthFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
            ),
          ),
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }

  void getImage() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String hive_path = appDocDirectory.path + '/' + 'cache';

    var box = await Hive.openBox("images", path: hive_path);
    print(box.containsKey(this.widget.id));
    //TODO imageprovider to bytes
    if (box.containsKey(this.widget.id)) {
      dynamic bytes = box.get(this.widget.id);
      setState(() {
        this.img = Image.memory(bytes);
      });
    } else {
      setState(() {
        img = MediaServer.getProductImage(this.widget.id);
      });
    }

    checkImageStatus();
  }

  void checkImageStatus() async {
    //check if background image available
    final Image image = Image(image: img.image);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;
    int width = info.width;
    int height = info.height;

    if (height != null && height > 0) {
      setState(() {
        this.hasImage = true;
      });
    } else {
      this.hasImage = false;
    }
  }

// //  ADS
  Future<void> _loadAd() async {
    final AdRequest request = AdRequest(
      keywords: keywords,
      contentUrl: 'https://greentrition.de',
    );

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).orientation,
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final AdListener listener = AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        setState(() {
          _adLoaded = true;
        });
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
    );

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2024236311702686/7691587294'
          : 'ca-app-pub-2024236311702686/6099441707',
      size: size,
      request: request,
      listener: listener,
    );
    return _anchoredAdaptiveAd.load();
  }
}
