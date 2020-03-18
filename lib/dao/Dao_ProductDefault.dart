import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thongkehanghoa/model/product.dart';

class DaoProductDefault {
  Database database;

  DaoProductDefault({this.database});

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

  addProductDefault(Product product) async {
    Database db = await createDatabase();
//    await db.insert('product', product.toMap());
    return await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO product(name, price, image, barcode) VALUES("${product.name}", ${product.price}, "${product.image}", "${product.barcode}" )');
      print('inserted1: $id1');
    });
  }

  Future<Product> getProductById(int id) async {
    Database db = await createDatabase();
    List<Map> maps = await db.query('product',
        columns: ['id', 'name', 'price', 'image', 'barcode'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Product>> getListProduct() async {
    Database db = await createDatabase();
    List<Map<String, dynamic>> maps = await db.query('product');
    return List.generate(maps.length, (i) {
      return Product(
          id: maps[i]['id'],
          name: maps[i]['name'],
          price: maps[i]['price'],
          image: maps[i]['image'],
          barcode: maps[i]['barcode']);
    });
  }

  updateProduct(Product product) async {
    Database db = await createDatabase();
    await db.update('product', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  deleteProduct(int id) async {
    Database db = await createDatabase();
    await db.delete('product', where: 'id=?', whereArgs: [id]);
  }

  Future deleteAllProduct() async {
    Database db = await createDatabase();
    await db.delete('product');
  }
}
