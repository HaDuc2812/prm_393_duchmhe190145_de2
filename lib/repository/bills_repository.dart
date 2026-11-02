import 'package:prm393_fa26_pe/data/db_helper.dart';
import 'package:prm393_fa26_pe/models/bills.dart';

class BillsRepository {
  BillsRepository(this._dbHelper);

  final DbHelper _dbHelper;

  Future<List<Bills>> getBills() => _dbHelper.getBills();

  Future<int> insertBill(Bills bill) => _dbHelper.insertBill(bill);

  Future<void> updateBill(Bills bill) => _dbHelper.updateBill(bill);

  Future<void> deleteBill(int id) => _dbHelper.deleteBill(id);
}
