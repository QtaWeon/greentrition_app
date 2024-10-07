import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:greentrition/components/home/categories.dart';
import 'package:greentrition/components/home/search_category_selector.dart';
import 'package:greentrition/constants/ad_keywords.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/constants/gradients.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/constants/standard_user.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/functions/user.dart';
import 'package:greentrition/views/product.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  TextEditingController _searchBarController = TextEditingController();
  FocusNode _focusNodeSearchBar = FocusNode();
  List<dynamic> _items;
  bool _standardWidgetsVisible;
  String user_name = "";
  SearchCategorySelector _searchCategorySelector;
  ScrollPhysics _scrollPhysics = BouncingScrollPhysics();
  Timer searchTimer;
  Duration _opacityDuration = Duration(milliseconds: 250);

  InterstitialAd _myInterstitial;
  Container _adContainer;
  bool bannerAdLoaded = false;

  @override
  void initState() {
    getUsername().then((value) {
      setState(() {
        if (value == free_user) {
          user_name = "";
        } else {
          user_name = " " + value;
        }
      });
    });
    _searchCategorySelector = SearchCategorySelector();
    _standardWidgetsVisible = true;
    _items = [];
    _focusNodeSearchBar.addListener(() {
      if (!_focusNodeSearchBar.hasFocus) {
        if (_items.length == 0) {
          setState(() {
            _standardWidgetsVisible = true;
            _scrollPhysics = BouncingScrollPhysics();
          });
        }
        print("Cleared search suggestions.");
      } else {
        setState(() {
          _standardWidgetsVisible = false;
          _scrollPhysics = NeverScrollableScrollPhysics();
        });
      }
    });
    isFreeUser().then((value) {
      if (value) {
        loadAds();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    if (searchTimer != null) {
      searchTimer.cancel();
    }
    _focusNodeSearchBar.dispose();
    _searchBarController.dispose();
    _myInterstitial?.dispose();
    super.dispose();
  }

  void search(String query) {
    List<Category> categories = _searchCategorySelector.getSelectedCategories();
    if (query.length >= 3) {
      searchTimer = Timer(Duration(milliseconds: 300), () {
        AppDb.fetchSearchbarContent(query, categories).then((value) {
          setState(() {
            _items = value;
            _standardWidgetsVisible = false;
            _scrollPhysics = NeverScrollableScrollPhysics();
          });
        });
      });
    } else {
      setState(() {
        _items = [];
      });
    }
  }

  SizedBox displaySearchResults() {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
          color: backgroundColorStart,
        ),
        child: new ListView.builder(
          shrinkWrap: true,
          key: _listKey,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            if (_items.length > 0) {
              return InkWell(
                onTap: () {
                  isFreeUser().then((value) {
                    if (value) {
                      displayInterstitial();
                    }
                  });

                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ProductView(
                                id: _items[index].id,
                                saveToHistory: true,
                              ),
                          settings: RouteSettings(name: "Product page")));
                },
                splashColor: backgroundColorEnd,
                child: Container(
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: new Text(
                    _items[index].product_name,
                    style: GoogleFonts.openSans(fontSize: 19),
                  ),
                  color: Colors.transparent,
                ),
              );
            } else {
              return SizedBox(
                height: 0,
              );
            }
          },
          padding: EdgeInsets.only(top: 5.0, left: 5.0),
          itemCount: _items.length,
        ),
      ),
      //TODO ===
      height: _items.length == 1 ? 60 : _items.length * 35.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNodeSearchBar.unfocus();
      },
      child: Stack(children: [
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(20))),
                  child: SafeArea(
                    child: Padding(
                      padding: padding_left_and_right,
                      child: Column(
                        children: [
                          AnimatedSize(
                            vsync: this,
                            duration: Duration(milliseconds: 250),
                            child: AnimatedOpacity(
                              curve: Curves.easeIn,
                              opacity: _standardWidgetsVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 400),
                              child: Container(
                                child: Text(
                                  user_name.toString().length <= 0
                                      ? "Hallo!"
                                      : "Hi" + user_name.toString() + "!",
                                  style: headingFont,
                                  textAlign: TextAlign.left,
                                ),
                                alignment: Alignment.topLeft,
                                height: _standardWidgetsVisible ? 40 : 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SingleChildScrollView(
                            child: CupertinoScrollbar(
                              thickness: 3.0,
                              child: Material(
                                //color searchbar background
                                color: Colors.white,
                                elevation: 14.0,
                                borderRadius: BorderRadius.circular(10.0),
                                child: Column(children: <Widget>[
                                  TextFormField(
                                      controller: _searchBarController,
                                      cursorColor: Colors.green,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Name oder Barcode...",
                                          hintStyle: searchbarStyle,
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: colorTextDark,
                                            size: 25.0,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              _searchBarController.clear();
                                              setState(() {
                                                _items.clear();
                                              });
                                            },
                                            icon: Icon(Icons.clear),
                                          )),
                                      style: searchbarStyle,
                                      onChanged: search,
                                      focusNode: _focusNodeSearchBar),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: AnimatedSize(
                                          vsync: this,
                                          duration: Duration(milliseconds: 400),
                                          curve: _standardWidgetsVisible
                                              ? Curves.easeOut
                                              : Curves.easeIn,
                                          child: _standardWidgetsVisible
                                              ? SizedBox(
                                                  height: 0,
                                                )
                                              : _searchCategorySelector,
                                        ),
                                      ),
                                      Wrap(children: [displaySearchResults()]),
                                    ],
                                  ),
                                ]),
                                shadowColor: colorShadowBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                  duration: _opacityDuration,
                  opacity: _standardWidgetsVisible ? 1.0 : 0.0,
                  child: Divider(thickness: 1)),
              Expanded(
                child: Padding(
                  padding: padding_left_and_right,
                  child: SingleChildScrollView(
                    physics: _scrollPhysics,
                    child: AbsorbPointer(
                        absorbing: !_standardWidgetsVisible,
                        child: AnimatedOpacity(
                            curve: Curves.easeIn,
                            opacity: _standardWidgetsVisible ? 1.0 : 0.0,
                            duration: _opacityDuration,
                            child: Categories())),
                  ),
                ),
              ),
              if (bannerAdLoaded && _adContainer != null) _adContainer
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.0),
            ),
            color: backgroundColorEnd, //Colors.lightGreen[600],
            gradient: backgroundGradient,
          ),
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
        ),
      ]),
    );
  }

  void loadAds() {
    //ADS
    final AdRequest request = AdRequest(
      keywords: keywords,
      contentUrl: 'https://greentrition.de',
    );

    final AdListener listener = AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        setState(() {
          this.bannerAdLoaded = true;
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

    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-2024236311702686/7691587294',
      size: AdSize.banner,
      request: request,
      listener: listener,
    );

    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    _adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    _myInterstitial = InterstitialAd(
      adUnitId: 'ca-app-pub-2024236311702686/6610439910',
      request: request,
      listener: AdListener(),
    );

    final AdListener listener2 = AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        ad.dispose();
        print('Ad closed.');
      },
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
    );
  }

  void displayInterstitial() {
    _myInterstitial.load().then((value) => _myInterstitial.show());
  }
}
