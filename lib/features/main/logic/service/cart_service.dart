import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/data.dart';

class CartService {
  final CartRepo repo;

  CartService({required this.repo});

  Future<PriceResponse> getCartPrice(PriceRequest request) async {
    return await repo.calculatePrice(request);
  }

  Future<PromoValidateResponse> checkPromo(PromoValidateRequest request) async {
    return await repo.validatePromo(request);
  }

  Future<void> addToCart({
    required int dishId,
    required String dishName,
    required String category,
    required double price,
    required int quantity,
  })
  async {
    try {
      // Получение экземпляра SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Создание объекта для сохранения
      final cartItem = {
        'dishId': dishId,
        'dishName': dishName,
        'category': category,
        'price': price,
        'quantity': quantity,
      };

      // Получение текущей корзины
      List<Map<String, dynamic>> cart = [];
      final String? cartString = prefs.getString('cart');

      if (cartString != null) {
        // Если корзина существует, декодируем её
        cart = (json.decode(cartString) as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      // Проверка на существование элемента с таким dishId
      final existingItemIndex = cart.indexWhere((item) => item['dishId'] == dishId);
      if (existingItemIndex != -1) {
        // Если элемент уже есть, обновляем количество
        cart[existingItemIndex]['quantity'] =
            cart[existingItemIndex]['quantity'] + quantity;
      } else {
        // Если элемента нет, добавляем новый
        cart.add(cartItem);
      }

      // Сохранение обновлённой корзины
      await prefs.setString('cart', json.encode(cart));
    } catch (e, stack) {
      debugPrint('Ошибка при добавлении в корзину: $e');
      debugPrint('StackTrace: $stack');
    }
  }

  // Дополнительный метод для получения корзины
  Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('cart');

    if (cartString != null) {
      try {
        return (json.decode(cartString) as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } catch (e) {
        debugPrint("Ошибка при парсинге корзины: $e");
        return [];
      }
    }
    return [];
  }

}

