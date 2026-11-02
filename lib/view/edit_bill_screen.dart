import 'package:flutter/material.dart';
import 'package:prm393_fa26_pe/models/bills.dart';

class EditBillScreen extends StatefulWidget {
  const EditBillScreen({
    super.key,
    required this.bill,
    required this.currencyUnit,
  });

  final Bills bill;
  final String currencyUnit;

  @override
  State<EditBillScreen> createState() => _EditBillScreenState();
}

class _EditBillScreenState extends State<EditBillScreen> {
  static const _categories = [
    'Ăn uống',
    'Giải trí',
    'Di chuyển',
    'Hóa đơn',
    'Mua sắm',
    'Khác',
    'Y tế',
    'Giáo dục',
    'Du lịch',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late String _category;

  List<String> get _availableCategories {
    if (_categories.contains(_category)) return _categories;
    return [..._categories, _category];
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bill.name);
    _amountController = TextEditingController(
      text: _formatAmount(widget.bill.amount),
    );
    _dateController = TextEditingController(
      text: _formatDate(widget.bill.date),
    );
    _category = widget.bill.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Bills(
        id: widget.bill.id,
        name: _nameController.text.trim(),
        amount: double.parse(_amountController.text.replaceAll(',', '').trim()),
        category: _category,
        date: _parseDate(_dateController.text.trim())!,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa khoản chi')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên khoản chi',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                  suffixText: widget.currencyUnit,
                ),
                validator: (value) {
                  final amount = int.tryParse(
                    (value ?? '').replaceAll(',', '').trim(),
                  );
                  if (amount == null || amount < 0) {
                    return 'Nhập số tiền hợp lệ.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: _availableCategories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (category) {
                  if (category != null) {
                    setState(() => _category = category);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Ngày khoản chi',
                  hintText: 'dd/MM/yyyy',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_parseDate(value?.trim() ?? '') == null) {
                    return 'Nhập ngày hợp lệ theo định dạng dd/MM/yyyy.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(onPressed: _save, child: const Text('Lưu')),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Trường này không được để trống.';
    }
    return null;
  }

  String _formatAmount(num amount) {
    return amount.round().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }
}
