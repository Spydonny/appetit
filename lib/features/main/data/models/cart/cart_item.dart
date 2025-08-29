import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int itemId;
  final int qty;

  const CartItem({
    required this.itemId,
    required this.qty,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['item_id'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'qty': qty,
    };
  }

  @override
  List<Object?> get props => [itemId, qty];
}
