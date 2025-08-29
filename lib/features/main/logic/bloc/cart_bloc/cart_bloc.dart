import 'package:appetite_app/features/main/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../../core/core.dart';
import '../../service/service.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  final CartService _cartService = getIt<CartService>();
  final OrderService _orderService = getIt<OrderService>();

  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityChanged>(_onItemQuantityChanged);
    on<CartDeliveryChanged>(_onDeliveryChanged);
    on<CartPickupAddressSelected>(_onPickupSelected);
    on<CartDeliveryAddressChanged>(_onDeliveryAddressChanged);
    on<CartPromoApplied>(_onPromoApplied);
    on<CartUseBonusesChanged>(_onUseBonusesChanged);
    on<CartPaymentChanged>(_onPaymentChanged);
    on<CartOrderSubmitted>(_onOrderSubmitted);
  }

  Future<void> _onItemAdded(CartItemAdded e, Emitter<CartState> emit) async {
    // Добавляем элемент в корзину через CartService
    await _cartService.addToCart(
      dishId: e.item['dishId'] as int,
      dishName: e.item['dishName'] as String,
      category: e.item['category'] as String,
      price: (e.item['price'] as num).toDouble(),
      quantity: e.item['quantity'] as int,
    );

    // Получаем обновлённую корзину
    final items = await _cartService.getCart();
    emit(_recalculate(state.copyWith(items: items)));
  }

  Future<void> _onItemRemoved(CartItemRemoved e, Emitter<CartState> emit) async {
    // Получаем текущую корзину
    final items = await _cartService.getCart();
    if (e.index < items.length) {
      items.removeAt(e.index);
      // Сохраняем обновлённую корзину в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart', json.encode(items));
    }
    emit(_recalculate(state.copyWith(items: items)));
  }

  Future<void> _onItemQuantityChanged(CartItemQuantityChanged e, Emitter<CartState> emit) async {
    // Получаем текущую корзину
    final items = await _cartService.getCart();
    if (e.index < items.length) {
      items[e.index]['quantity'] = e.quantity;
      // Сохраняем обновлённую корзину
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart', json.encode(items));
    }
    emit(_recalculate(state.copyWith(items: items)));
  }

  void _onDeliveryChanged(CartDeliveryChanged e, Emitter<CartState> emit) {
    emit(_recalculate(state.copyWith(isDelivery: e.isDelivery)));
  }

  void _onPickupSelected(CartPickupAddressSelected e, Emitter<CartState> emit) {
    emit(state.copyWith(pickupAddress: e.address));
  }

  void _onDeliveryAddressChanged(CartDeliveryAddressChanged e, Emitter<CartState> emit) {
    emit(state.copyWith(deliveryAddress: e.address));
  }

  Future<void> _onPromoApplied(CartPromoApplied e, Emitter<CartState> emit) async {
    final newState = state.copyWith(promo: e.promo);

    try {
      final items = await _cartService.getCart();
      final List<CartItem> cart = items.map((item) => CartItem(
        itemId: int.parse(item['dishId']),
        qty: item['quantity'] as int,
      )).toList();
      final response = await _cartService.checkPromo(PromoValidateRequest(code: e.promo ,cart: cart));
      emit(_recalculate(newState.copyWith(bonusValue: response.discount)));
    } catch (_) {
      emit(_recalculate(newState.copyWith(bonusValue: 0)));
    }
  }

  void _onUseBonusesChanged(CartUseBonusesChanged e, Emitter<CartState> emit) {
    emit(_recalculate(state.copyWith(useBonuses: e.useBonuses)));
  }

  void _onPaymentChanged(CartPaymentChanged e, Emitter<CartState> emit) {
    emit(state.copyWith(payment: e.payment));
  }

  Future<void> _onOrderSubmitted(CartOrderSubmitted e, Emitter<CartState> emit) async {
    final orderData = {
      'items': state.items,
      'isDelivery': state.isDelivery,
      'pickupAddress': state.pickupAddress,
      'deliveryAddress': state.deliveryAddress,
      'useBonuses': state.useBonuses,
      'promo': state.promo,
      'payment': state.payment,
      'total': state.total,
    };

    await _orderService.createOrder(orderData);
    // Очищаем корзину в SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    emit(const CartState()); // Очищаем состояние
  }

  CartState _recalculate(CartState s) {
    final productsTotal = s.items.fold<double>(
      0,
          (sum, item) => sum + (item['price'] as num) * (item['quantity'] as num),
    );
    final deliveryPrice = s.isDelivery ? 500.0 : 0.0;
    final bonusValue = s.useBonuses ? 300.0 : 0.0;
    final total = productsTotal + deliveryPrice - bonusValue;

    return s.copyWith(
      productsTotal: productsTotal,
      deliveryPrice: deliveryPrice,
      bonusValue: bonusValue,
      total: total,
    );
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      return _recalculate(CartState.fromMap(json));
    } catch (_) {
      return const CartState();
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) => state.toMap();
}
