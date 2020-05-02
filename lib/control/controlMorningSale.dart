import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thongkehanghoa/dao/Dao_ProductDefault.dart';
import 'package:thongkehanghoa/dao/Dao_ProductSale.dart';
import 'package:thongkehanghoa/model/product.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';

class ControlSaleMorning {
  DaoProductDefault daoProductDefault;
  DaoSaleProductSale daoSaleProductSale;
  List<Product> listProductDefault;
  List<SaleProduct> listSaleProduct;
  Map<String, dynamic> tonkho = new Map();
  Future<bool> saveFile()async{
    final casang ="Ca sáng";
    final cachieu ="Ca chiều";
    final header ="Tên,Barcode,Giá,SL nhập,SL tồn,SL bán được,Tổng tiền";
    try {
      final directory = await getExternalStorageDirectory();
      var sdcard = directory.parent.parent.parent.parent.path;
      Directory folder = Directory("$sdcard/Athongke");
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      var file = new File("${folder.path}/${DateTime.now()}.csv");
      var sink = file.openWrite(mode: FileMode.append);
      sink.write("$casang \n");
      sink.write("$header \n");
      List<SaleProduct> sang = await getListSaleProduct(1);
      sang.forEach((element) {
        sink.write(
            "${element.name},${element.barcode},${element.price},${element
                .amountInput},${element.amountOutput},${element.amountInput -
                element.amountOutput},${(element.amountInput -
                element.amountOutput) * element.price}, \n");
      });
      List<SaleProduct> chieu = await getListSaleProduct(2);
      sink.write("$cachieu \n");
      sink.write("$header \n");
      chieu.forEach((element) {
        sink.write(
            "${element.name},${element.barcode},${element.price},${element
                .amountInput},${element.amountOutput},${element.amountInput -
                element.amountOutput},${(element.amountInput -
                element.amountOutput) * element.price}, \n");
      });
      sink.close();
      return true;
    }catch ( e){
      print(e);
      return false;
    }
  }
  Future<bool> getStatusWork() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("WORK") ?? false;
  }
  ControlSaleMorning(){
    gettonkho();
  }
  setCurrentPage(int type)async{
    final share = await SharedPreferences.getInstance();
    // true is affternoonPage
    // false is morningPage
    if(type==1){
      share.setBool("CR", false);
    }else {
      share.setBool("CR", true);
    }
  }
  setStatusWork() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("WORK", true);
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
  }
   gettonkho()async{
    final share = await SharedPreferences.getInstance();
    final tonkhos = share.getString("TONKHO")??"";
    if(tonkhos=="") return;

    tonkho = jsonDecode(tonkhos);
  }

  // chuyển từ danh sách mặc định sang danh sách bán sáng
  Future<bool> saveListSaleProduct() async {
    if (daoSaleProductSale == null) {
      daoSaleProductSale = new DaoSaleProductSale();
    }
    final sharedPreferences =await SharedPreferences.getInstance();
    final dataton = sharedPreferences.getString("TONKHO") ?? "";
    try {
      var product;
      if (dataton == "") {
        for (var i = 0; i < listProductDefault.length; i++) {
          print("new app");
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
      } else {
        print("no neww");
        tonkho = jsonDecode(dataton);
        int tmp;
        for (var i = 0; i < listProductDefault.length; i++) {
          product = listProductDefault.elementAt(i);
          if(product.barcode==null){
            tmp = tonkho[product.name]==null?0:tonkho[product.name];
          }else{
            tmp =tonkho[product.barcode]==null?0:tonkho[product.barcode];
          }
          daoSaleProductSale.addSaleProduct(SaleProduct(
              name: product.name,
              type: 1,
              price: product.price,
              image: product.image,
              barcode: product.barcode,
              amountInput: tmp,
              amountOutput: 0));
          daoSaleProductSale.addSaleProduct(SaleProduct(
              name: product.name,
              type: 2,
              price: product.price,
              image: product.image,
              barcode: product.barcode,
              amountInput: tmp,
              amountOutput: 0));
        }
      }
    } catch (err) {
      print(err);
      return false;
    }
    return true;
  }

  getIndex(SaleProduct saleProduct) {
    return listSaleProduct.indexOf(saleProduct);
  }

//  //// change saleproduct in list
//  bool changeSaleProductFromList(
//    int type,
//    int index,
//    int value,
//  ) {
//    try {
//      SaleProduct saleProduct = listSaleProduct.elementAt(index);
//      if (type == 1) {
//        saleProduct.amountInput = value;
//      } else {
//        saleProduct.amountOutput = value;
//        //update data tonkho to map
//        changeDataTonKho(saleProduct.barcode, value);
//      }
//      listSaleProduct.removeAt(index);
//      listSaleProduct.insert(index, saleProduct);
//      daoSaleProductSale.updateSaleProduct(saleProduct);
//      return true;
//    } catch (err) {
//      return false;
//    }
//  }
  //change data in map
  changeDataTonKho(String key,int value){
    tonkho.update(key, (valuew) => value,ifAbsent: ()=>value);
    return;
  }
  // save data map to local
  Future saveDataTonKho()async{
    if(tonkho.length!=0) {
      print("save");
      final sharedPreferences = await SharedPreferences.getInstance();
      final json = jsonEncode(tonkho);
      sharedPreferences.setString("TONKHO",json);
    }
  }
  // change saleproduct in database
  bool changeSaleProduct(SaleProduct saleProduct, int type,int typema, int value) {
    if (type == 1) {
      saleProduct.amountInput = value;
    } else {
      saleProduct.amountOutput = value;
      if(typema!=2) {
        daoSaleProductSale.updateSaleProductByTypeAndBarcode(saleProduct, 2);
      }
      changeDataTonKho(saleProduct.barcode==null?saleProduct.name:saleProduct.barcode, value);
    }
    daoSaleProductSale.updateSaleProduct(saleProduct);
  }

  double totalMoney() {
    var total = 0.0;
    listSaleProduct.forEach((product) {
      total += (product.amountInput - product.amountOutput) * product.price;
    });
    return total;
  }
}
