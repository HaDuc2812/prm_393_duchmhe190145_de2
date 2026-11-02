import 'package:flutter/material.dart';
import 'package:prm393_fa26_pe/data/db_helper.dart';
import 'package:prm393_fa26_pe/models/bills.dart';
import 'package:prm393_fa26_pe/view/currency_settings_screen.dart';
import 'package:prm393_fa26_pe/view/edit_bill_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _currencyPreferenceKey = 'currency_unit';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Bills>> _bills;
  String _currencyUnit = 'VND';

  @override
  void initState() {
    super.initState();
    _bills = DbHelper.instance.getBills();
    _loadCurrencyUnit();
  }

  Future<void> _loadCurrencyUnit() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedUnit = preferences.getString(_currencyPreferenceKey) ?? 'VND';
      if (mounted) {
        setState(() => _currencyUnit = savedUnit);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải đơn vị tiền tệ: $error')),
      );
    }
  }

  Future<void> _reloadBills() async {
    setState(() {
      _bills = DbHelper.instance.getBills();
    });
    await _bills;
  }

  Future<void> _editBill(Bills bill) async {
    final updatedBill = await Navigator.of(context).push<Bills>(
      MaterialPageRoute(
        builder: (context) =>
            EditBillScreen(bill: bill, currencyUnit: _currencyUnit),
      ),
    );
    if (updatedBill == null || !mounted) return;

    try {
      if (bill.id == null) {
        await DbHelper.instance.insertBill(updatedBill);
      } else {
        await DbHelper.instance.updateBill(updatedBill);
      }
      await _reloadBills();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật khoản chi: $error')),
      );
    }
  }

  Future<void> _showSettings() async {
    final selectedUnit = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) =>
            CurrencySettingsScreen(currentUnit: _currencyUnit),
      ),
    );
    if (selectedUnit == null || !mounted) return;

    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        _currencyPreferenceKey,
        selectedUnit,
      );
      if (!saved) {
        throw StateError('Không thể lưu đơn vị tiền tệ.');
      }
      if (mounted) {
        setState(() => _currencyUnit = selectedUnit);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu đơn vị tiền tệ: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          TextButton.icon(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings_outlined, size: 18),
            label: const Text('Cài đặt'),
          ),
          TextButton.icon(
            onPressed: _reloadBills,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Tải lại'),
          ),
        ],
      ),
      body: FutureBuilder<List<Bills>>(
        future: _bills,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không thể tải các khoản chi.'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _reloadBills,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final bills = snapshot.data ?? const <Bills>[];
          return RefreshIndicator(
            onRefresh: _reloadBills,
            child: bills.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 180),
                      Center(child: Text('Chưa có khoản chi nào.')),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      final bill = bills[index];
                      return _BillCard(
                        bill: bill,
                        currencyUnit: _currencyUnit,
                        onEdit: () => _editBill(bill),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  const _BillCard({
    required this.bill,
    required this.currencyUnit,
    required this.onEdit,
  });

  final Bills bill;
  final String currencyUnit;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final date = bill.date.toLocal();
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bill.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            label: Text(bill.category),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatAmount(bill.amount)} $currencyUnit',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Sửa'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatAmount(num amount) {
  return amount.round().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
}
