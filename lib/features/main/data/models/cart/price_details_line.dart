import 'package:equatable/equatable.dart';

class PriceDetailsLine extends Equatable {
  final int itemId;
  final String name;
  final int qty;
  final double unitPrice;
  final double lineTotal;

  const PriceDetailsLine({
    required this.itemId,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory PriceDetailsLine.fromJson(Map<String, dynamic> json) {
    return PriceDetailsLine(
      itemId: json['item_id'],
      name: json['name'],
      qty: json['qty'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      lineTotal: (json['line_total'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [itemId, name, qty, unitPrice, lineTotal];
}
