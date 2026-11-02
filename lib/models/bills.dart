class Bills {
  const Bills({
    this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  });

  final int? id;
  final String name;
  final double amount;
  final String category;
  final DateTime date;


  factory Bills.fromMap(Map<String, dynamic> map) {
    return Bills(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
}