import 'package:path/path.dart' as p;
import 'package:prm393_fa26_pe/models/bills.dart';
import 'package:sqflite/sqflite.dart';

final _sampleBills = [
  Bills(
    name: 'Đi chợ',
    amount: 150000,
    category: 'Ăn uống',
    date: DateTime(2026, 11, 1),
  ),
  Bills(
    name: 'Cà phê',
    amount: 45000,
    category: 'Giải trí',
    date: DateTime(2026, 11, 2),
  ),
  Bills(
    name: 'Đổ xăng',
    amount: 80000,
    category: 'Di chuyển',
    date: DateTime(2026, 11, 2),
  ),
  Bills(
    name: 'Khám bệnh',
    amount: 200000,
    category: 'Sức khỏe',
    date: DateTime(2026, 11, 3),
  ),
];

class DbHelper {
  DbHelper._();

  static final DbHelper instance = DbHelper._();

  Future<Database>? _databaseFuture;

  Future<Database> get database {
    return _databaseFuture ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    try {
      final databasePath = p.join(await getDatabasesPath(), 'users.db');

      return await openDatabase(
        databasePath,
        version: 1,
        onCreate: _createDatabase,
      );
    } catch (_) {
      _databaseFuture = null;
      rethrow;
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bills(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
      ''');
  }

  // READ: lấy toàn bộ hóa đơn.
  Future<List<Bills>> getBills() async {
    final db = await database;
    await _insertSampleBillsIfEmpty(db);

    final rows = await db.query('bills', orderBy: 'id DESC');

    return rows.map((row) => Bills.fromMap(row)).toList();
  }

  Future<void> _insertSampleBillsIfEmpty(Database db) async {
    await db.transaction((transaction) async {
      final count = Sqflite.firstIntValue(
        await transaction.rawQuery('SELECT COUNT(*) FROM bills'),
      );
      if (count != 0) return;

      final batch = transaction.batch();
      for (final bill in _sampleBills) {
        final data = bill.toMap()..remove('id');
        batch.insert('bills', data);
      }
      await batch.commit(noResult: true);
    });
  }

  // CREATE: thêm hóa đơn.
  Future<int> insertBill(Bills bill) async {
    final db = await database;

    final data = bill.toMap();
    data.remove('id');

    return db.insert('bills', data);
  }

  // UPDATE: sửa hóa đơn theo ID.
  Future<void> updateBill(Bills bill) async {
    if (bill.id == null) {
      throw ArgumentError('Thiếu ID hóa đơn.');
    }

    final db = await database;

    final data = bill.toMap();
    data.remove('id');

    final affectedRows = await db.update(
      'bills',
      data,
      where: 'id = ?',
      whereArgs: [bill.id],
    );

    if (affectedRows != 1) {
      throw StateError('Hóa đơn không còn tồn tại.');
    }
  }

  // DELETE: xóa hóa đơn theo ID.
  Future<void> deleteBill(int id) async {
    final db = await database;

    final affectedRows = await db.delete(
      'bills',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (affectedRows != 1) {
      throw StateError('Hóa đơn không còn tồn tại.');
    }
  }

  Future<void> close() async {
    final opening = _databaseFuture;
    _databaseFuture = null;

    if (opening != null) {
      final db = await opening;
      await db.close();
    }
  }
}
