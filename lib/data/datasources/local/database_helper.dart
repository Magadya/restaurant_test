
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurant.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tables (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number TEXT NOT NULL,
        isOccupied INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tableId INTEGER NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        FOREIGN KEY (tableId) REFERENCES tables (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (orderId) REFERENCES orders (id),
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');

    // Insert sample products
    await _insertSampleProducts(db);
  }

  Future<void> _insertSampleProducts(Database db) async {
    final products = [
      {
        'name': 'Маргарита',
        'price': 12.99,
        'imageUrl': 'assets/images/margherita.jpg',
        'type': 'pizza',
        'description': 'Классическая итальянская пицца'
      },
      {
        'name': 'Пепперони',
        'price': 14.99,
        'imageUrl': 'assets/images/pepperoni.jpg',
        'type': 'pizza',
        'description': 'Пицца с острыми колбасками'
      },
      {
        'name': 'Кола',
        'price': 2.99,
        'imageUrl': 'assets/images/cola.jpg',
        'type': 'drink',
        'description': 'Прохладительный напиток'
      },
    ];

    for (var product in products) {
      await db.insert('products', product);
    }
  }
}