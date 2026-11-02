import 'package:prm393_fa26_pe/models/bills.dart';
import 'package:prm393_fa26_pe/viewmodels/dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bills_viewmodels.g.dart';

@Riverpod(keepAlive: true)
class BillsViewModels extends _$BillsViewModels {
  @override
  Future<List<Bills>> build() => ref.watch(billsRepositoryProvider).getBills();

  Future<void> deleteBill(int id) async {
    final repository = ref.read(billsRepositoryProvider);
    await repository.deleteBill(id);
    state = AsyncData(await repository.getBills());
  }

  Future<void> reloadBills() async {
    final repository = ref.read(billsRepositoryProvider);
    state = const AsyncLoading();
    state = AsyncData(await repository.getBills());
  }
}
