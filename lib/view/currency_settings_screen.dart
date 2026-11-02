import 'package:flutter/material.dart';

class CurrencySettingsScreen extends StatefulWidget {
  const CurrencySettingsScreen({super.key, required this.currentUnit});

  final String currentUnit;

  @override
  State<CurrencySettingsScreen> createState() => _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState extends State<CurrencySettingsScreen> {
  late String _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.currentUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn vị tiền tệ')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DropdownButton<String>(
          value: _selectedUnit,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'VND', child: Text('VND')),
            DropdownMenuItem(value: 'USD', child: Text('USD')),
          ],
          onChanged: (unit) {
            if (unit != null) {
              setState(() {
                _selectedUnit = unit;
              });
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: FilledButton(
          onPressed: () => Navigator.pop(context, _selectedUnit),
          child: const Text('Lưu'),
        ),
      ),
    );
  }
}
