import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// --- SYSTEM / USER EVENTS ---

  /// Пользователь зарегистрировался
  Future<void> logSignUp({required DateTime timestamp}) async {
    await _analytics.logEvent(
      name: "sign_up",
      parameters: {
        "timestamp": timestamp, // например: email, google, apple
      },
    );
  }

  /// Пользователь вошёл в систему
  Future<void> logLogin({required DateTime timestamp}) async {
    await _analytics.logEvent(
      name: "login",
      parameters: {
        "timestamp": timestamp,
      },
    );
  }

  /// Пользователь вышел из системы
  // Future<void> logLogout() async {
  //   await _analytics.logEvent(name: "logout");
  // }

  /// --- MARKETING / CONTENT EVENTS ---

  /// Просмотр баннера (рекламы / акции)
  Future<void> logBannerView({
    required String bannerId,
    required String bannerName,
    String? campaign,
  }) async {
    await _analytics.logEvent(
      name: "banner_view",
      parameters: {
        "banner_id": bannerId,
        "banner_name": bannerName,
        if (campaign != null) "campaign": campaign,
      },
    );
  }

  /// Клик по баннеру
  Future<void> logBannerClick({
    required String bannerId,
    required String bannerName,
    String? campaign,
  }) async {
    await _analytics.logEvent(
      name: "banner_click",
      parameters: {
        "banner_id": bannerId,
        "banner_name": bannerName,
        if (campaign != null) "campaign": campaign,
      },
    );
  }

  /// --- E-COMMERCE EVENTS (из прошлого примера) ---
  Future<void> logDishView({
    required String dishId,
    required String dishName,
    String category = "Dishes",
    double? price,
    String currency = "KZT",
  }) async {
    await _analytics.logEvent(
      name: "view_item",
      parameters: {
        "item_id": dishId,
        "item_name": dishName,
        "item_category": category,
        if (price != null) "price": price,
        "currency": currency,
      },
    );
  }

  Future<void> logAddToCart({
    required String dishId,
    required String dishName,
    required String category,
    required double price,
    String currency = 'KZT',
    required int quantity,
  }) async {
    await _analytics.logEvent(
      name: "add_to_cart",
      parameters: {
        "item_id": dishId,
        "item_name": dishName,
        "item_category": category,
        "price": price,
        "currency": currency,
        "quantity": quantity,
      },
    );
  }

  Future<void> logPurchase({
    required String orderId,
    required double totalPrice,
    String currency = "KZT",
    List<Map<String, dynamic>>? items,
  }) async {
    await _analytics.logEvent(
      name: "purchase",
      parameters: {
        "transaction_id": orderId,
        "value": totalPrice,
        "currency": currency,
        if (items != null) "items": items,
      },
    );
  }

  /// --- UNIVERSAL EVENT ---
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}

