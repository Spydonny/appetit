import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'enums.dart';

class Order extends Equatable {
  final int id;
  final String number;
  final OrderStatus status;
  final FulfillmentType fulfillment;
  final String? addressText;
  final double? lat;
  final double? lng;
  final double subtotal;
  final double discount;
  final double total;
  final bool paid;
  final PaymentMethod paymentMethod;
  final String? promocodeCode;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.number,
    required this.status,
    required this.fulfillment,
    this.addressText,
    this.lat,
    this.lng,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paid,
    required this.paymentMethod,
    this.promocodeCode,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      number: json['number'],
      status: OrderStatusX.fromString(json['status']),
      fulfillment: FulfillmentTypeX.fromString(json['fulfillment']),
      addressText: json['address_text'],
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paid: json['paid'],
      paymentMethod: PaymentMethodX.fromString(json['payment_method']),
      promocodeCode: json['promocode_code'],
      createdAt: DateTime.parse(json['created_at']),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'status': status.value,
    'fulfillment': fulfillment.value,
    'address_text': addressText,
    'lat': lat,
    'lng': lng,
    'subtotal': subtotal,
    'discount': discount,
    'total': total,
    'paid': paid,
    'payment_method': paymentMethod.value,
    'promocode_code': promocodeCode,
    'created_at': createdAt.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id,
    number,
    status,
    fulfillment,
    addressText,
    lat,
    lng,
    subtotal,
    discount,
    total,
    paid,
    paymentMethod,
    promocodeCode,
    createdAt,
    items,
  ];
}
