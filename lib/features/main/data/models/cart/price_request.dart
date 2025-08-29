import 'cart_item.dart';
import 'fulfillment_type.dart';

class PriceRequest {
  final List<CartItem> items;
  final String? promocode;
  final FulfillmentType fulfillment;
  final String? address;

  PriceRequest({
    required this.items,
    this.promocode,
    required this.fulfillment,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'promocode': promocode,
      'fulfillment': fulfillment.value,
      'address': address,
    };
  }
}
