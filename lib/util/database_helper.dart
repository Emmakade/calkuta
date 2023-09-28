import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/models/transactions.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'calkuta.db');

    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      //TODO To Add
      // modify model, registration, profile,
      //create a table to hold username nad password
      //create a table to hold bank names and code
      await db.execute('''
          CREATE TABLE contributors(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            gender TEXT NOT NULL,
            phone TEXT NULL,
            email TEXT NULL,
            addr TEXT NULL,
            bankName TEXT NOT NULL,
            bankAcctNo TEXT NULL,
            dateJoined TEXT NOT NULL,
            imageDp TEXT NULL,
            balance REAL DEFAULT 0.0
          )
        ''');

      await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            contributorId INTEGER NOT NULL,
            type TEXT NOT NULL,
            amount REAL NOT NULL,
            remark TEXT NULL,
            FOREIGN KEY(contributorId) REFERENCES contributors(id)
          )
        ''');

      // Create the trigger to update the contributor balance
      await db.execute('''
          CREATE TRIGGER update_balance AFTER INSERT ON transactions
          BEGIN
            UPDATE contributors
            SET balance = balance + NEW.amount
            WHERE id = NEW.contributorId;
          END;
        ''');
    }, onUpgrade: _onUpgrade);
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the new column 'remark' to the 'transactions' table
      await db.execute('ALTER TABLE transactions ADD COLUMN remark TEXT NULL');
    }
  }

  //fetch Operation: Get all contributor objects from database
  Future<List<Map<String, dynamic>>> getContributorMapList() async {
    Database? db = await database;

    var result = await db.query('contributors');
    return result;
  }

  //fetch Operation: Get all transactions objects from database
  Future<List<Map<String, dynamic>>> getTransactionMapList() async {
    Database? db = await database;

    final result = await db.rawQuery(
        'SELECT * FROM contributors LEFT JOIN transactions ON contributors.id = transactions.contributorId WHERE amount IS NOT NULL ORDER BY transactions.id DESC');

    return result;
  }

  //fetch Operation: Get the last 10 transactions objects from database
  Future<List<Map<String, dynamic>>> getTenTransactionMapList() async {
    Database? db = await database;

    //TODO: check this query on empty database
    final result = await db.rawQuery(
        'SELECT * FROM contributors LEFT JOIN transactions ON contributors.id = transactions.contributorId WHERE amount IS NOT NULL ORDER BY transactions.id DESC LIMIT 10');

    return result;
  }

  //fetch Operation: Get a single user transactions objects from database
  Future<List<Map<String, dynamic>>> getUserTransactionMapList(int id) async {
    Database? db = await database;

    final result = await db.rawQuery(
        'SELECT * FROM transactions WHERE contributorId = $id ORDER BY transactions.date DESC');
    return result;
  }

  //fetch Operation: Get a single user contributor objects from database
  Future<List<Map<String, dynamic>>> getUserMapList(
      Contributor contributor) async {
    Database? db = await database;

    final result = await db
        .rawQuery('SELECT * FROM contributors WHERE id = ${contributor.id}');
    return result;
  }

  //insert Operation: insert a contributors objects to database
  Future<int> insertContributor(Contributor contributor) async {
    Database db = await database;
    var result = await db.insert('contributors', contributor.toMap());
    return result;
  }

  //insert Operation: insert a transaction objects to database
  Future<int> insertTransaction(Transactions transactions) async {
    Database db = await database;
    var result = await db.insert('transactions', transactions.toMap());
    return result;
  }

  //update Operation: update a contribu object and save it to database
  Future<int> updateContributor(Contributor contributor) async {
    var db = await database;
    var result = await db.update(
      'contributors',
      contributor.toMap(),
      where: 'id =?',
      whereArgs: [contributor.id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  //delete Operation: delete a contributor objects from database
  Future<int> deleteContributor(int id) async {
    var db = await database;
    int result = await db.rawDelete('DELETE FROM contributors WHERE id = $id');
    return result;
  }

  //get number of contributor(s) object(s) in database
  Future<int> getCount() async {
    Database? db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from contributors');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  //Get the 'Map List' [ List<Map> ] and convert it to  'Contributor List' [ List<Contributor>]
  Future<List<Contributor>> getContributorList() async {
    var contributorMapList = await getContributorMapList();
    int count = contributorMapList.length;

    List<Contributor> contributorList = <Contributor>[];
    //for loop to create a 'contri list' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contributorList.add(Contributor.fromMapObject(contributorMapList[i]));
    }
    return contributorList;
  }

  //Get Map list and convert it to Transaction List
  Future<List<Transactions>> getTransactionList() async {
    var transactionMapList = await getTransactionMapList();
    int count = transactionMapList.length;

    List<Transactions> transactionList = <Transactions>[];
    //for loop to create a 'transa list' from a 'Map List'
    for (int i = 0; i < count; i++) {
      transactionList.add(Transactions.fromMapObject(transactionMapList[i]));
    }

    return transactionList;
  }

  //get the total of all balances deposited or withdrawed
  Future<double> getTotalBalance() async {
    final contributorMaps = await getContributorMapList();

    double totalBalance = 0;
    for (var contributorMap in contributorMaps) {
      final contributor = Contributor.fromMapObject(contributorMap);
      totalBalance += contributor.balance ?? 0;
    }
    return totalBalance;
  }
}
