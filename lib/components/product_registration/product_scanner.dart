import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/views/basic_page.dart';

class Camera extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  CameraController _camController;
  Future<void> _initializeControllerFuture;
  bool firstPicture = true;
  XFile firstpic;
  XFile secondpic;
  String productName = "";

  @override
  void initState() {
    initializeCamera();

    super.initState();
  }

  void takePhoto() async {
    XFile pic;
    try {
      pic = await _camController.takePicture();
    } catch (e) {
      print("capture not finished yet");
    }
    if (firstPicture) {
      firstpic = pic;
      setState(() {
        firstPicture = false;
      });
      //TODO ENABLE WHEN FIXED
      // startOcr(FirebaseVisionImage.fromFilePath(firstpic.path)).then((value) {
      //   productName = value;
      // });
    } else {
      secondpic = pic;
      //TODO ENABLE WHEN FIXED
      // startOcr(FirebaseVisionImage.fromFilePath(secondpic.path))
      //     .then((ingredientString) {
      String ingredientString = "";
      Navigator.of(context)
          .pop([firstpic, secondpic, productName, ingredientString]);
      // });
    }
  }

  void initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _camController = new CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false);
    //TODO SET ON
    // _camController.setFlashMode(FlashMode.off);

    setState(() {
      _initializeControllerFuture = _camController.initialize();
    });
  }

  @override
  void dispose() {
    _camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      showBackButton: true,
      content: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: AspectRatio(
                      //Container war schon ueber Ratio => Strech fail
                      aspectRatio: _camController.value.previewSize.height /
                          _camController.value.previewSize.width,
                      child: _camController.buildPreview()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.all(32.0),
                      child: Text(
                        firstPicture
                            ? "Fotografiere die Produktvorderseite"
                            : "Fotografiere die Inhaltsstoffe",
                        textAlign: TextAlign.center,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: takePhoto,
                      color: colorGreen.withOpacity(0.8),
                      textColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                  ),
                )
              ],
            );
          } else {
            return SizedBox(
              height: 0,
            );
          }
        },
      ),
    );
  }

// Future<String> startOcr(FirebaseVisionImage visionImage) async {
//   final TextRecognizer textRecognizer =
//       FirebaseVision.instance.textRecognizer();
//   VisionText visionText = await textRecognizer.processImage(visionImage);
//   textRecognizer.close();
//   if (visionText.text == null) {
//     return "";
//   } else {
//     return visionText.text;
//   }
// }
}
