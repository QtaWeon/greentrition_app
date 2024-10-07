import 'package:flutter/material.dart';
import 'package:greentrition/database/server.dart';

class MediaServer {
  static final url = mediaServer;

  static Image getProductImage(String productId) {
    Image img = Image.network(
      url + "/products/$productId/front.jpg",
      errorBuilder: (context, error, stackTrace) {
        print("Exception, no Image found on the server.");
        print(error.toString());

        return null;
      },
    );

    return img;
  }
}
