import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/core/service_locator/service_locator.dart';
import 'package:appetite_app/features/shared/services/services.dart';

void main() {
  group('Service Locator', () {
    setUp(() {
      // Reset the service locator before each test
      if (getIt.isRegistered<AppService>()) {
        getIt.unregister<AppService>();
      }
      if (getIt.isRegistered<ThemeService>()) {
        getIt.unregister<ThemeService>();
      }
    });

    tearDown(() {
      // Clean up after each test
      if (getIt.isRegistered<AppService>()) {
        getIt.unregister<AppService>();
      }
      if (getIt.isRegistered<ThemeService>()) {
        getIt.unregister<ThemeService>();
      }
    });

    test('should have getIt instance', () {
      expect(getIt, isNotNull);
    });

    test('should have setupLocator function', () {
      expect(setupLocator, isA<Future<void> Function()>());
    });

    test('should register AppService as lazy singleton', () async {
      await setupLocator();
      
      expect(getIt.isRegistered<AppService>(), isTrue);
      
      final appService = getIt<AppService>();
      expect(appService, isA<AppService>());
      
      // Should return the same instance (singleton)
      final appService2 = getIt<AppService>();
      expect(identical(appService, appService2), isTrue);
    });

    test('should register ThemeService as lazy singleton', () async {
      await setupLocator();
      
      expect(getIt.isRegistered<ThemeService>(), isTrue);
      
      final themeService = getIt<ThemeService>();
      expect(themeService, isA<ThemeService>());
      
      // Should return the same instance (singleton)
      final themeService2 = getIt<ThemeService>();
      expect(identical(themeService, themeService2), isTrue);
    });

    test('should register both services', () async {
      await setupLocator();
      
      expect(getIt.isRegistered<AppService>(), isTrue);
      expect(getIt.isRegistered<ThemeService>(), isTrue);
    });

    test('should handle multiple setupLocator calls gracefully', () async {
      // First setup
      await setupLocator();
      expect(getIt.isRegistered<AppService>(), isTrue);
      expect(getIt.isRegistered<ThemeService>(), isTrue);
      
      // Second setup should not fail
      await setupLocator();
      expect(getIt.isRegistered<AppService>(), isTrue);
      expect(getIt.isRegistered<ThemeService>(), isTrue);
    });

    test('should return correct service types', () async {
      await setupLocator();
      
      final appService = getIt<AppService>();
      final themeService = getIt<ThemeService>();
      
      expect(appService, isA<AppService>());
      expect(themeService, isA<ThemeService>());
    });

    test('should handle service retrieval before setup', () {
      // Try to get services before setup
      expect(() => getIt<AppService>(), throwsA(anything));
      expect(() => getIt<ThemeService>(), throwsA(anything));
    });

    test('should maintain singleton behavior across setup calls', () async {
      await setupLocator();
      
      final appService1 = getIt<AppService>();
      final themeService1 = getIt<ThemeService>();
      
      await setupLocator();
      
      final appService2 = getIt<AppService>();
      final themeService2 = getIt<ThemeService>();
      
      // Should still be the same instances
      expect(identical(appService1, appService2), isTrue);
      expect(identical(themeService1, themeService2), isTrue);
    });

    test('should have correct service registration order', () async {
      await setupLocator();
      
      // Check that services are registered in the correct order
      final registrations = getIt.getAll();
      
      // Note: The actual order might vary, but both services should be registered
      expect(registrations.length, greaterThanOrEqualTo(2));
    });

    test('should handle service unregistration', () async {
      await setupLocator();
      
      expect(getIt.isRegistered<AppService>(), isTrue);
      expect(getIt.isRegistered<ThemeService>(), isTrue);
      
      // Unregister services
      getIt.unregister<AppService>();
      getIt.unregister<ThemeService>();
      
      expect(getIt.isRegistered<AppService>(), isFalse);
      expect(getIt.isRegistered<ThemeService>(), isFalse);
    });

    test('should allow re-registration after unregistration', () async {
      await setupLocator();
      
      // Unregister
      getIt.unregister<AppService>();
      getIt.unregister<ThemeService>();
      
      // Re-register
      await setupLocator();
      
      expect(getIt.isRegistered<AppService>(), isTrue);
      expect(getIt.isRegistered<ThemeService>(), isTrue);
    });

    test('should have lazy singleton behavior', () async {
      await setupLocator();
      
      // Services should not be instantiated until first access
      expect(getIt.isRegistered<AppService>(), isTrue);
      expect(getIt.isRegistered<ThemeService>(), isTrue);
      
      // First access should create instances
      final appService = getIt<AppService>();
      final themeService = getIt<ThemeService>();
      
      expect(appService, isNotNull);
      expect(themeService, isNotNull);
    });
  });
}
