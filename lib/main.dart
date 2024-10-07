import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:greentrition/constants/colors.dart';
import "package:greentrition/screens/screen_manager.dart";
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import "package:greentrition/functions/first_run.dart";
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    // For play billing library 2.0 on Android, it is mandatory to call
    // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
    // as part of initializing the app.
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();

  runApp(App());

  isFirstRun().then((value) => {
        if (value) {initializeCategories()}
      });
}

class App extends StatelessWidget {
  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // TODO ADD https://pub.dev/packages/firebase_analytics/example

  Widget build(BuildContext context) {
    return MaterialApp(
        title: "greentrition",
        theme: ThemeData(
          accentColor: colorGreen,
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          // FirebaseAnalyticsObserver(analytics: analytics),
        ],
        home: ScreenManager());
  }
}
