import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/views/basic_page.dart';

class MyBarcodeScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyBarcodeScannerState();
  }
}

class MyBarcodeScannerState extends State<MyBarcodeScanner> {
  BarcodeScanner _bd;
  CameraController _camController;
  bool foundCode = false;
  Future<void> _initializeControllerFuture;

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

  ///CameraController and BarcodeDetector
  void onBarcodeDetectorClosedError(Object error) {
    print("Camera overhead - BarcodeDetector already closed.");
    _camController.stopImageStream().catchError((onError) {
      print("Could not stop ImageStream - no camera is streaming.");
    });
    startImageStream();
    // _bd = GoogleMlKit.vision.barcodeScanner([BarcodeFormat.ean13, BarcodeFormat.ean8]);
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
    return BasicPage(
      content: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            startImageStream();
            return Stack(
              children: [
                Center(
                  child: AspectRatio(
                      //Container war schon ueber Ratio => Strech fail
                      aspectRatio: _camController.value.previewSize.height /
                          _camController.value.previewSize.width,
                      child: _camController.buildPreview()),
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.all(32.0),
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
                    )),
              ],
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
      ),
    );
  }
}
