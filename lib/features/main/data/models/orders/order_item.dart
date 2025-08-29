import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int id;
  final int? itemId;
  final String nameSnapshot;
  final int qty;
  final double priceAtMoment;

  const OrderItem({
    required this.id,
    this.itemId,
    required this.nameSnapshot,
    required this.qty,
    required this.priceAtMoment,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemId: json['item_id'],
      nameSnapshot: json['name_snapshot'],
      qty: json['qty'],
      priceAtMoment: (json['price_at_moment'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'item_id': itemId,
    'name_snapshot': nameSnapshot,
    'qty': qty,
    'price_at_moment': priceAtMoment,
  };

  @override
  List<Object?> get props => [id, itemId, nameSnapshot, qty, priceAtMoment];
}
