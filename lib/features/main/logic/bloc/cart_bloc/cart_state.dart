part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<Map<String, dynamic>> items;
  final bool isDelivery;
  final String? pickupAddress;
  final String deliveryAddress;
  final bool useBonuses;
  final String? promo;
  final String? payment;
  final double productsTotal;
  final double deliveryPrice;
  final double bonusValue;
  final double total;

  const CartState({
    this.items = const [],
    this.isDelivery = false,
    this.pickupAddress,
    this.deliveryAddress = "",
    this.useBonuses = false,
    this.promo,
    this.payment,
    this.productsTotal = 0,
    this.deliveryPrice = 0,
    this.bonusValue = 0,
    this.total = 0,
  });

  CartState copyWith({
    List<Map<String, dynamic>>? items,
    bool? isDelivery,
    String? pickupAddress,
    String? deliveryAddress,
    bool? useBonuses,
    String? promo,
    String? payment,
    double? productsTotal,
    double? deliveryPrice,
    double? bonusValue,
    double? total,
  }) {
    return CartState(
      items: items ?? this.items,
      isDelivery: isDelivery ?? this.isDelivery,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      useBonuses: useBonuses ?? this.useBonuses,
      promo: promo ?? this.promo,
      payment: payment ?? this.payment,
      productsTotal: productsTotal ?? this.productsTotal,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      bonusValue: bonusValue ?? this.bonusValue,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() => {
    "items": items,
    "isDelivery": isDelivery,
    "pickupAddress": pickupAddress,
    "deliveryAddress": deliveryAddress,
    "useBonuses": useBonuses,
    "promo": promo,
    "payment": payment,
  };

  factory CartState.fromMap(Map<String, dynamic> map) => CartState(
    items: List<Map<String, dynamic>>.from(map["items"] ?? []),
    isDelivery: map["isDelivery"] ?? false,
    pickupAddress: map["pickupAddress"],
    deliveryAddress: map["deliveryAddress"] ?? "",
    useBonuses: map["useBonuses"] ?? false,
    promo: map["promo"],
    payment: map["payment"],
  );

  @override
  List<Object?> get props => [
    items,
    isDelivery,
    pickupAddress,
    deliveryAddress,
    useBonuses,
    promo,
    payment,
    productsTotal,
    deliveryPrice,
    bonusValue,
    total
  ];
}
