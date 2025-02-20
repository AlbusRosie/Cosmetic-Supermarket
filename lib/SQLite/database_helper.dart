import 'package:ct312h_project/JSON/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final databaseName = "mini_supermarket.db";

  String user = '''
    CREATE TABLE users (
      uid INTEGER PRIMARY KEY AUTOINCREMENT,
      urole TEXT CHECK (urole IN ('1', '2')) NOT NULL DEFAULT '2', 
      uname TEXT NOT NULL,
      phone TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      address TEXT DEFAULT NULL,
      avt TEXT DEFAULT "assets/no_user.jpg"
    )
  ''';
  // 1 = admin, 2 = user

  String products = '''
    CREATE TABLE products (
      pid INTEGER PRIMARY KEY AUTOINCREMENT,
      pname TEXT NOT NULL,
      category TEXT NOT NULL,
      price REAL NOT NULL,
      stock_quality INTEGER NOT NULL,
      description TEXT,
      img TEXT
    )
  ''';

  String orders = '''
    CREATE TABLE orders (
      oid INTEGER PRIMARY KEY AUTOINCREMENT,
      uid INTEGER NOT NULL,
      odate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      total_price DECIMAL(10,2) DEFAULT 0.00,
      status TEXT CHECK (status IN ('pending', 'success', 'fail')) NOT NULL,
      FOREIGN KEY (uid) REFERENCES users (uid) ON DELETE CASCADE
    )
  ''';

    String order_items = '''
    CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      oid INTEGER NOT NULL,
      pid INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      price_per_unit DECIMAL(10,2) NOT NULL,
      FOREIGN KEY (oid) REFERENCES orders (oid) ON DELETE CASCADE,
      FOREIGN KEY (pid) REFERENCES products (pid) ON DELETE CASCADE
    )
  ''';

  // Future<void> deleteDatabase() async {
  //   final databasePath = await getDatabasesPath();
  //   final path = join(databasePath, databaseName);
  //   await databaseFactory.deleteDatabase(path);
  // }

  // Connection is ready
  Future<Database> initDB ()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async{
      await db.execute(user);
    });
  }

  // Function Methods

  // Authentication
  Future<bool> authenticate(Users usr)async{
    final Database db = await initDB();
    var result = await db.rawQuery("select * from users where phone = '${usr.phone}' AND password = '${usr.password}'");
    if(result.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  // Sign Up
  Future<int> createUser(Users user) async{
    final Database db = await initDB();
    return db.insert("users", user.toMap());
  }

  // Get current User details
  Future<Users?> getUserByPhone(String phone) async {
    final Database db = await initDB();
    var res = await db.query("users", where: "phone = ?", whereArgs: [phone]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

}