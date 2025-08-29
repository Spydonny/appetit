import 'package:appetite_app/features/auth/data/repos/auth_repo.dart';
import 'package:appetite_app/features/main/data/data.dart';
import 'package:appetite_app/features/shared/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/services/services.dart';
import '../../features/main/logic/service/service.dart';
import '../../features/shared/shared.dart';

final getIt = GetIt.instance;

const baseUrl = 'https://appetitapi-production.up.railway.app/api/v1';

class TokenNotifier extends ValueNotifier<String> {
  TokenNotifier([super.initialToken = '']);

  /// Получить токен
  String get token => value;

  /// Установить новый токен
  void setToken(String newToken) {
    value = newToken;
  }

  /// Очистить токен
  void clearToken() {
    value = '';
  }

  /// Проверка, есть ли токен
  bool get hasToken => value.isNotEmpty;
}

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AppService>(() => AppService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());
  getIt.registerCachedFactory<AnalyticsService>(() => AnalyticsService());
  getIt.registerCachedFactory<MapService>(() => MapService(repo: MapRepo(baseUrl: baseUrl)));
  getIt.registerSingleton<TokenNotifier>(TokenNotifier());

  getIt.registerCachedFactory<AuthService>(() => AuthService(AuthRepo(baseUrl: baseUrl)));

  getIt.registerCachedFactory<CartService>(() => CartService(repo: CartRepo(baseUrl: baseUrl)));
  getIt.registerCachedFactory<MenuService>(() => MenuService(repo: MenuRepo(baseUrl: baseUrl)));
  getIt.registerCachedFactory<OrderService>(() => OrderService(OrderRepo(baseUrl: baseUrl,
  )));
}
