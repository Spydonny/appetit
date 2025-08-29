part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final Map<String, dynamic> item;
  const CartItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}

class CartItemRemoved extends CartEvent {
  final int index;
  const CartItemRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

class CartItemQuantityChanged extends CartEvent {
  final int index;
  final int quantity;
  const CartItemQuantityChanged({required this.index, required this.quantity});

  @override
  List<Object?> get props => [index, quantity];
}

class CartDeliveryChanged extends CartEvent {
  final bool isDelivery;
  const CartDeliveryChanged(this.isDelivery);

  @override
  List<Object?> get props => [isDelivery];
}

class CartPickupAddressSelected extends CartEvent {
  final String address;
  const CartPickupAddressSelected(this.address);

  @override
  List<Object?> get props => [address];
}

class CartDeliveryAddressChanged extends CartEvent {
  final String address;
  const CartDeliveryAddressChanged(this.address);

  @override
  List<Object?> get props => [address];
}

class CartPromoApplied extends CartEvent {
  final String promo;
  const CartPromoApplied(this.promo);

  @override
  List<Object?> get props => [promo];
}

class CartUseBonusesChanged extends CartEvent {
  final bool useBonuses;
  const CartUseBonusesChanged(this.useBonuses);

  @override
  List<Object?> get props => [useBonuses];
}

class CartPaymentChanged extends CartEvent {
  final String payment;
  const CartPaymentChanged(this.payment);

  @override
  List<Object?> get props => [payment];
}

class CartOrderSubmitted extends CartEvent {}