import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:greentrition/components/camera/error_dialog.dart';
import 'package:greentrition/components/product_registration/product_registration_stepper.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/views/product.dart';

class Camera extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  BarcodeScanner _bd;
  CameraController _camController;
  bool foundCode = false;
  Future<void> _initializeControllerFuture;
  bool showError = false;

  @override
  void initState() {
    initializeCamera();

    super.initState();
  }

  void initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _camController = new CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    //TODO SET ON
    // _camController.setFlashMode(FlashMode.off);

    setState(() {
      _initializeControllerFuture = _camController.initialize();
    });

    //Setup Barcode Detector
    List<BarcodeFormat> formats = [BarcodeFormat.ean13, BarcodeFormat.ean8];
    _bd = GoogleMlKit.vision.barcodeScanner(formats);
  }

  @override
  void dispose() {
    try {
      if (_camController != null) {
        _camController.dispose();
      }
    } catch (err) {
      print(err);
    }
    if (_bd != null) {
      _bd.close();
    }
    super.dispose();
  }

  void detectCode(CameraImage image) {
  }

  ///CameraController and BarcodeDetector and closed on dispose
  void onBarcodeDetectorClosedError(Object error) {
    print("Camera overhead - BarcodeDetector already closed.");
    _camController.stopImageStream().catchError((onError) {
      print("Could not stop ImageStream - no camera is streaming.");
    });
  }

  void startImageStream() {
    //Add delay
    Future.delayed(Duration(milliseconds: 300), () {
      foundCode = false;
    });

    if (_camController != null) {
      _camController.startImageStream((image) => detectCode(image));
    } else {
      print("Camera controller was null");
      initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          startImageStream();
          return GestureDetector(
            onTap: () {
              setState(() {
                showError = false;
              });
            },
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                      aspectRatio: _camController.value.previewSize.height /
                          _camController.value.previewSize.width,
                      child: _camController.buildPreview()),
                ),
                // Container(
                //   child: Positioned(
                //     child: Align(
                //       alignment: FractionalOffset.bottomCenter,
                //       heightFactor: 5,
                //       child: Container(
                //         width: 200,
                //         height: 100,
                //         decoration: BoxDecoration(
                //             color: Colors.transparent,
                //             /*boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black,
                //                 blurRadius: 10.0, // soften the shadow
                //                 spreadRadius: 7.0, //extend the shadow
                //                 offset: Offset(
                //                   5.0, // Move to right 10  horizontally
                //                   5.0, // Move to bottom 5 Vertically
                //                 ),
                //               )                            ],*/
                //             //shape: BoxShape.circle,
                //             border: Border.all(
                //               color: Colors.white,
                //               width: 5,
                //             ),
                //             borderRadius: BorderRadius.circular(13)),
                //       ),
                //     ),
                //   ),
                // ),

                /// TEXT CONTAINER
                /*Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Scanne einen Barcode",
                      style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(colors: [
                              Color(0xff0B9231),
                              Color(0xff0B9231).withOpacity(0.8)
                            ]).createShader(
                                new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          shadows: [
                            BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                offset: Offset(1, 5),
                                blurRadius: 35.0,
                                spreadRadius: 2.0),
                          ]),
                    )),*/

                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.1),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AbsorbPointer(
                      absorbing: !showError,
                      child: AnimatedOpacity(
                        opacity: showError ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: GestureDetector(
                            onTap: () async {
                              _camController
                                  .stopImageStream()
                                  .catchError((err) {
                                print(err.toString());
                              });

                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          ProductRegistrationStepper(),
                                      settings: RouteSettings(
                                          name:
                                              "Product registration stepper")));
                              initializeCamera();
                              startImageStream();
                            },
                            child: ErrorDialog()),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
              child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorVegan),
            ),
          ));
        }
      },
    );
  }

  void showErrorProductNotFound() {
    setState(() {
      showError = true;
    });
  }
}
