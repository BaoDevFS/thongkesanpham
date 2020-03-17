import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thongkehanghoa/dao/Dao_ProductDefault.dart';
import 'package:thongkehanghoa/dao/Dao_ProductSale.dart';
import 'package:thongkehanghoa/model/product.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';

class ControlSaleMorning {
  ControlSaleMorning() {
    print("new ControlSaleMorning");
  }

  DaoProductDefault daoProductDefault;
  DaoSaleProductSale daoSaleProductSale;
  List<Product> listProductDefault;
  List<SaleProduct> listSaleProduct;

  Future<bool> getStatusWork() async {
    final sharePreferent = await SharedPreferences.getInstance();
    return sharePreferent.getBool("WORK") ?? false;
  }

  setStatusWork() async {
    final sharePreferent = await SharedPreferences.getInstance();
    sharePreferent.setBool("WORK", true);
  }

  deleteStatusWork() async {
    final sharePreferent = await SharedPreferences.getInstance();
    sharePreferent.remove("WORK");
  }

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

  //get danh sách mặc định
  Future<List<Product>> getListProductDefault() async {
    if (daoProductDefault == null) {
      daoProductDefault = new DaoProductDefault();
    }
    listProductDefault = await daoProductDefault.getListProduct();
    return listProductDefault;
  }
//taoj phien lam viec moi
  Future createNewSessionWork() async {
    final b = await createDatabase();
    if (b) {
      var list = await getListProductDefault();
      if (list != null) {
        final bol = await saveListSaleProduct();
        if (bol) {
          await setStatusWork();
          return true;
        } else {
          print("ERROR: Save Fail!");
          return false;
        }
        //sau khi save xog
      }
    }
  }

  //lấy danh sách bán
  Future<List<SaleProduct>> getListSaleProduct(int type) async {
    // type here is a morning or afternoon
    if (daoSaleProductSale == null) {
      daoSaleProductSale = new DaoSaleProductSale();
    }
    listSaleProduct = await daoSaleProductSale.getListSaleProduct(type);
    return listSaleProduct;
    // not have work
  }

  // chuyển từ danh sách mặc định sang danh sách bán sáng
  Future<bool> saveListSaleProduct() async {
    if (daoSaleProductSale == null) {
      daoSaleProductSale = new DaoSaleProductSale();
    }
    try {
      var product;
      for (var i = 0; i < listProductDefault.length; i++) {
        product = listProductDefault.elementAt(i);
        daoSaleProductSale.addSaleProduct(SaleProduct(
            name: product.name,
            type: 1,
            price: product.price,
            image: product.image,
            barcode: product.barcode,
            amountInput: 0,
            amountOutput: 0));
        daoSaleProductSale.addSaleProduct(SaleProduct(
            name: product.name,
            type: 2,
            price: product.price,
            image: product.image,
            barcode: product.barcode,
            amountInput: 0,
            amountOutput: 0));
      }
    } catch (err) {
      print(err);
      return false;
    }
    return true;
  }
   getIndex(SaleProduct saleProduct){
    return listSaleProduct.indexOf(saleProduct);
  }
  //
  bool changeSaleProductFromList(
    int type,
    int index,
    int value,
  ) {
    try {
      SaleProduct saleProduct = listSaleProduct.elementAt(index);
      if (type == 1) {
        saleProduct.amountInput = value;
      } else {
        saleProduct.amountOutput = value;
      }
      print(saleProduct.toString());
      listSaleProduct.removeAt(index);
      listSaleProduct.insert(index, saleProduct);
      daoSaleProductSale.updateSaleProduct(saleProduct);
      return true;

    } catch (err) {
      return false;
    }
  }
  bool changeSaleProduct(SaleProduct saleProduct,int type,int value){
    if (type == 1) {
      saleProduct.amountInput = value;
    } else {
      saleProduct.amountOutput = value;
    }
    daoSaleProductSale.updateSaleProduct(saleProduct);
  }
}
