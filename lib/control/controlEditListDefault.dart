import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thongkehanghoa/dao/Dao_ProductDefault.dart';
import 'package:thongkehanghoa/model/product.dart';

class ControlEditListDefault{
  List<Product> listProductDefault;
  DaoProductDefault daoProductDefault;
  Future<bool> createDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "thongke.db");

// Check if the database exists
    var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "db/thongke.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return true;
  }

  Future<List<Product>> getListProductDefault() async {
    if(daoProductDefault==null) {
      daoProductDefault = new DaoProductDefault();
    }
    final b = await createDatabase();
    if(b) {
      listProductDefault = await daoProductDefault.getListProduct();
      return listProductDefault;
    }
  }
  //
  bool changeProductFromList(String type,int index, value,) {
    try {
      Product product =listProductDefault.elementAt(index);
      switch(type){
        case "name":
          product.name=value;
          break;
        case "price":
          product.price=value;
          break;
        case "image":
          product.image=value;
          break;
        case "barcode":
          product.barcode=value;
          break;
      }
      listProductDefault.removeAt(index);
      listProductDefault.insert(index, product);
      print(product.toString());
      daoProductDefault.updateProduct(product);
      return true;
    } catch (err) {
      return false;
    }
  }
}