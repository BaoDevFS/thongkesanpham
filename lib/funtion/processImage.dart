import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProcessImage{
  static Future<File> resizeImage(File image)async{
    if(image==null) return null;
//    ImageProperties properties = await FlutterNativeImage.getImageProperties(image.path);
    File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 80,
        targetWidth: 270, targetHeight: 480);
    return compressedFile;
  }
  static Future<File> pickImage()async{
    var imagetmp  = await ImagePicker.pickImage(source: ImageSource.camera);
    if(imagetmp==null){
      return null;
    }
    Directory path = await getApplicationDocumentsDirectory();
// copy the file to a new path
     File newImage = await imagetmp.copy('${path.path}/image1.png');
    return newImage;
  }
  static Future<Uint8List> getUint8ListFromImage(File file)async{
    Uint8List uint8list = await file.readAsBytesSync();
    return uint8list;
  }
}