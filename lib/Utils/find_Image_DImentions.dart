import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FindImgDimen {
  final String imageUrl;

  FindImgDimen({Key? key, required this.imageUrl});

  Future<Map<String, int>> getImageDimensions() async {
    try {
      final completer = Completer<ImageInfo>();
      final listener = ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info);
      });

      final ImageStream stream = CachedNetworkImageProvider(imageUrl)
          .resolve(ImageConfiguration(size: Size(200, 150)));
      stream.addListener(listener);

      final info = await completer.future;
      stream.removeListener(listener);

      return {
        'width': info.image.width,
        'height': info.image.height,
      };
    } catch (e) {
      print('Error fetching image dimensions: $e');
      return {'width': 0, 'height': 0};
    }
  }
}
