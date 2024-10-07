import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  ImageProvider _imageProvider;

  ImageViewer(ImageProvider image) {
    _imageProvider = image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: _imageProvider,
    ));
  }
}
