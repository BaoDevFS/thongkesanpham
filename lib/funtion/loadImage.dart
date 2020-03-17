import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class LoadImage{
  static Image imageFromBase64(String base64){
      return Image.memory(base64Decode(base64));
  }
  static String base64FromImage(Uint8List image){
    return base64Encode(image);
  }
  static Uint8List uint8listFromBase64(String base64){
    return base64Decode(base64);
  }
}