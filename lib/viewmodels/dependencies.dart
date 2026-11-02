import 'package:prm393_fa26_pe/data/db_helper.dart';
import 'package:prm393_fa26_pe/repository/bills_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dependencies.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences preferences(Ref ref){
  throw StateError('preferrences phải được override trong main()');
}
@Riverpod(keepAlive: true)
BillsRepository billsRepository(Ref ref){
  return BillsRepository(DbHelper.instance);
  }