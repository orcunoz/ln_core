import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

class FileUtils {
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    var codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}

extension FileExtensions on File {
  Future<String> toBase64() async {
    List<int> imageBytes = await readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<File> fromBase64(String base64) async {
    List<int> imageBytes = base64Decode(base64);
    return writeAsBytes(imageBytes);
  }
}
