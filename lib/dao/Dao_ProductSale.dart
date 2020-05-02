import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';

class DaoSaleProductSale {
  Database database;

  Future<Database> createDatabase() async {
    if (database != null) {
      return database;
    }
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "thongke.db");
    database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {});
    return database;
  }

  Future addSaleProduct(SaleProduct saleProduct) async {
    Database db = await createDatabase();
    return await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO saleproduct(name,type, price, image,barcode, amountInput, amountOutput) VALUES("${saleProduct.name}",${saleProduct.type}, ${saleProduct.price}, "${saleProduct.image}", "${saleProduct.barcode}",${saleProduct.amountInput},${saleProduct.amountOutput})');
      print('inserted1: $id1');
    });
  }

  Future<SaleProduct> getSaleProductById(int id) async {
    Database db = await createDatabase();
    List<Map> maps = await db.query('saleproduct',
        columns: [
          'id',
          'name',
          'type',
          'price',
          'image',
          'barcode',
          'amountInput',
          'amountOutput'
        ],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SaleProduct.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SaleProduct>> getListSaleProduct(int type) async {
    Database db = await createDatabase();
    List<Map> maps = await db.query('saleproduct',where: "type=?",whereArgs: [type]);
    return List.generate(maps.length, (i) {
      return SaleProduct(
          id: maps[i]['id'],
          name: maps[i]['name'],
          type: maps[i]['type'],
          price: maps[i]['price'],
          image: maps[i]['image'],
          barcode: maps[i]['barcode'],
          amountInput: maps[i]['amountInput'],
          amountOutput: maps[i]['amountOutput']);
    });
  }
  //get all SaleProduct
  Future<List<SaleProduct>> getListAllSaleProduct() async {
    Database db = await createDatabase();
    List<Map> maps = await db.query('saleproduct');
    return List.generate(maps.length, (i) {
      return SaleProduct(
          id: maps[i]['id'],
          name: maps[i]['name'],
          type: maps[i]['type'],
          price: maps[i]['price'],
          image: maps[i]['image'],
          barcode: maps[i]['barcode'],
          amountInput: maps[i]['amountInput'],
          amountOutput: maps[i]['amountOutput']);
    });
  }

  Future<SaleProduct> getSaleProductByBarcode(String barcode,int type)async{
    Database db = await createDatabase();
    List<Map> maps = await db.query('saleproduct',
        columns: [
          'id',
          'name',
          'type',
          'price',
          'image',
          'barcode',
          'amountInput',
          'amountOutput'
        ],
        where: 'barcode = ? and type = ?',
        whereArgs: [barcode,type]);
    if (maps.length > 0) {
      return SaleProduct.fromMap(maps.first);
    }
    return null;
  }
  Future<SaleProduct> getSaleProductByName(String name,int type)async{
    Database db = await createDatabase();
    List<Map> maps = await db.query('saleproduct',
        columns: [
          'id',
          'name',
          'type',
          'price',
          'image',
          'barcode',
          'amountInput',
          'amountOutput'
        ],
        where: 'name = ? and type = ?',
        whereArgs: [name,type]);
    if (maps.length > 0) {
      return SaleProduct.fromMap(maps.first);
    }
    return null;
  }

  Future updateSaleProduct(SaleProduct saleProduct) async {
    Database db = await createDatabase();
    await db.update('saleproduct', saleProduct.toMap(),
        where: 'id = ?', whereArgs: [saleProduct.id]);
  }

  Future updateSaleProductByTypeAndBarcode(SaleProduct saleProduct, type) async {
    //type is morning or affternoon
    var tmpsaleProduct;
    if(saleProduct.barcode==null){
      tmpsaleProduct =await getSaleProductByName(saleProduct.name, type);
    }else{
       tmpsaleProduct =await getSaleProductByBarcode(saleProduct.barcode, type);
    }
    if(tmpsaleProduct==null){
      return;
    }
    tmpsaleProduct.amountInput=saleProduct.amountOutput;
    await database.update('saleproduct', tmpsaleProduct.toMap(),
        where: 'id = ?', whereArgs: [tmpsaleProduct.id]);
    return;
  }

  Future deleteSaleProduct(int id) async {
    Database db = await createDatabase();
    await db.delete('saleproduct', where: 'id=?', whereArgs: [id]);
  }
  Future deleteAllSaleProduct()async{
    Database db = await createDatabase();
    await db.delete('saleproduct');
  }
}
