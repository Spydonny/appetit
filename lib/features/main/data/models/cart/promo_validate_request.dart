import 'cart_item.dart';

class PromoValidateRequest {
  final String? code;
  final List<CartItem> cart;

  PromoValidateRequest({
    this.code,
    required this.cart,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'cart': cart.map((e) => e.toJson()).toList(),
    };
  }
}
