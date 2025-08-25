import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/core/service_locator/service_locator.dart';
import 'package:appetite_app/features/shared/services/services.dart';
import 'package:appetite_app/core/theme/app_theme.dart';

void main() {
  group('App Integration Tests', () {
    setUp(() async {
      // Setup service locator before each test
      await setupLocator();
    });

    tearDown(() {
      // Clean up services after each test
      if (getIt.isRegistered<AppService>()) {
        getIt.unregister<AppService>();
      }
      if (getIt.isRegistered<ThemeService>()) {
        getIt.unregister<ThemeService>();
      }
    });

    group('Service Integration', () {
      test('should have all required services registered', () {
        expect(getIt.isRegistered<AppService>(), isTrue);
        expect(getIt.isRegistered<ThemeService>(), isTrue);
      });

      test('should return correct service instances', () {
        final appService = getIt<AppService>();
        final themeService = getIt<ThemeService>();

        expect(appService, isA<AppService>());
        expect(themeService, isA<ThemeService>());
      });

      test('should maintain singleton pattern across services', () {
        final appService1 = getIt<AppService>();
        final appService2 = getIt<AppService>();
        final themeService1 = getIt<ThemeService>();
        final themeService2 = getIt<ThemeService>();

        expect(identical(appService1, appService2), isTrue);
        expect(identical(themeService1, themeService2), isTrue);
      });
    });

    group('Theme Integration', () {
      test('should have light and dark themes defined', () {
        expect(AppTheme.lightTheme, isNotNull);
        expect(AppTheme.darkTheme, isNotNull);
      });

      test('should have different themes for light and dark', () {
        expect(AppTheme.lightTheme, isNot(equals(AppTheme.darkTheme)));
      });

      test('should use consistent text theme across themes', () {
        expect(AppTheme.lightTheme.textTheme, equals(AppTheme.darkTheme.textTheme));
      });

      test('should have Material 3 enabled', () {
        expect(AppTheme.lightTheme.useMaterial3, isTrue);
        expect(AppTheme.darkTheme.useMaterial3, isTrue);
      });
    });

    group('Theme Service Integration', () {
      test('should initialize with light theme', () {
        final themeService = getIt<ThemeService>();
        expect(themeService.themeMode.value, equals(ThemeMode.light));
      });

      test('should toggle theme correctly', () {
        final themeService = getIt<ThemeService>();
        
        // Start with light
        expect(themeService.themeMode.value, equals(ThemeMode.light));
        
        // Toggle to dark
        themeService.toggleTheme();
        expect(themeService.themeMode.value, equals(ThemeMode.dark));
        
        // Toggle back to light
        themeService.toggleTheme();
        expect(themeService.themeMode.value, equals(ThemeMode.light));
      });

      test('should set specific theme mode', () {
        final themeService = getIt<ThemeService>();
        
        themeService.setTheme(ThemeMode.dark);
        expect(themeService.themeMode.value, equals(ThemeMode.dark));
        
        themeService.setTheme(ThemeMode.system);
        expect(themeService.themeMode.value, equals(ThemeMode.system));
        
        themeService.setTheme(ThemeMode.light);
        expect(themeService.themeMode.value, equals(ThemeMode.light));
      });
    });

    group('App Service Integration', () {
      test('should be instantiable', () {
        final appService = getIt<AppService>();
        expect(appService, isA<AppService>());
      });

      test('should have required methods', () {
        final appService = getIt<AppService>();
        
        expect(appService.openDatePicker, isA<Function>());
        expect(appService.openMap, isA<Function>());
      });
    });

    group('Service Dependencies', () {
      test('should not have circular dependencies', () {
        // This test ensures that services can be instantiated without circular dependencies
        final appService = getIt<AppService>();
        final themeService = getIt<ThemeService>();
        
        expect(appService, isNotNull);
        expect(themeService, isNotNull);
      });

      test('should handle service disposal correctly', () {
        final themeService = getIt<ThemeService>();
        
        // Add a listener
        bool listenerCalled = false;
        themeService.themeMode.addListener(() {
          listenerCalled = true;
        });
        
        // Change theme
        themeService.toggleTheme();
        expect(listenerCalled, isTrue);
        
        // Dispose
        themeService.themeMode.dispose();
        
        // Should not crash when trying to access disposed notifier
        expect(() => themeService.themeMode.value, returnsNormally);
      });
    });

    group('Theme Consistency', () {
      test('should have consistent color schemes', () {
        final lightColorScheme = AppTheme.lightTheme.colorScheme;
        final darkColorScheme = AppTheme.darkTheme.colorScheme;
        
        // Both themes should have primary colors defined
        expect(lightColorScheme.primary, isNotNull);
        expect(darkColorScheme.primary, isNotNull);
        
        // Both themes should have surface colors defined
        expect(lightColorScheme.surface, isNotNull);
        expect(darkColorScheme.surface, isNotNull);
      });

      test('should have consistent input decoration themes', () {
        final lightInputTheme = AppTheme.lightTheme.inputDecorationTheme;
        final darkInputTheme = AppTheme.darkTheme.inputDecorationTheme;
        
        // Both should have no border
        expect(lightInputTheme.border, equals(InputBorder.none));
        expect(darkInputTheme.border, equals(InputBorder.none));
        
        // Both should have hint styles
        expect(lightInputTheme.hintStyle, isNotNull);
        expect(darkInputTheme.hintStyle, isNotNull);
      });
    });

    group('Service Lifecycle', () {
      test('should handle service reinitialization', () async {
        // First initialization
        await setupLocator();
        expect(getIt.isRegistered<AppService>(), isTrue);
        expect(getIt.isRegistered<ThemeService>(), isTrue);
        
        // Unregister
        getIt.unregister<AppService>();
        getIt.unregister<ThemeService>();
        
        // Reinitialize
        await setupLocator();
        expect(getIt.isRegistered<AppService>(), isTrue);
        expect(getIt.isRegistered<ThemeService>(), isTrue);
      });

      test('should maintain service state across reinitialization', () async {
        // First initialization
        await setupLocator();
        final themeService1 = getIt<ThemeService>();
        themeService1.setTheme(ThemeMode.dark);
        
        // Unregister and reinitialize
        getIt.unregister<ThemeService>();
        await setupLocator();
        
        final themeService2 = getIt<ThemeService>();
        // New instance should start with default theme
        expect(themeService2.themeMode.value, equals(ThemeMode.light));
      });
    });
  });
}
