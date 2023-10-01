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

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
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
      },
    );
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

    final result = await db.rawQuery(
        'SELECT * FROM contributors LEFT JOIN transactions ON contributors.id = transactions.contributorId WHERE amount IS NOT NULL ORDER BY transactions.id DESC LIMIT 10');
    return result;
  }

  //fetch Operation: Get a single user transactions map and totalAmount from database
  Future<Map<String, dynamic>> getUserTransactionDetails(int id) async {
    Database? db = await database;

    final transactions = await db.rawQuery(
        'SELECT * FROM transactions WHERE contributorId = $id ORDER BY transactions.date DESC');

    double totalAmount = 0.0;
    for (var transaction in transactions) {
      totalAmount += transaction['amount'] as double;
    }

    return {'transactions': transactions, 'totalAmount': totalAmount};
  }

  //fetch Operation: Get a single user contributor objects from database
  Future<List<Map<String, dynamic>>> getUserMapList(int? id) async {
    Database? db = await database;

    final result =
        await db.rawQuery('SELECT * FROM contributors WHERE id = $id');
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

  Future<void> deleteTransaction(int transactionId) async {
    final db = await database;
    try {
      // Retrieve the transaction details before deletion
      final transactionDetails = await db
          .query('transactions', where: 'id = ?', whereArgs: [transactionId]);

      // Delete the transaction
      await db
          .execute('DELETE FROM transactions WHERE id = ?', [transactionId]);

      // Update the contributor's balance
      final contributorId = transactionDetails[0]['contributorId'];
      final transactionAmount = transactionDetails[0]['amount'];
      await db.execute(
          'UPDATE contributors SET balance = balance - ? WHERE id = ?',
          [transactionAmount, contributorId]);
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }
}
