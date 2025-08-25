import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/features/shared/services/theme_service.dart';

void main() {
  group('ThemeService', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
    });

    tearDown(() {
      themeService.themeMode.dispose();
    });

    test('should initialize with light theme', () {
      expect(themeService.themeMode.value, equals(ThemeMode.light));
    });

    test('should toggle theme from light to dark', () {
      // Initial state
      expect(themeService.themeMode.value, equals(ThemeMode.light));
      
      // Toggle to dark
      themeService.toggleTheme();
      expect(themeService.themeMode.value, equals(ThemeMode.dark));
    });

    test('should toggle theme from dark to light', () {
      // Set to dark first
      themeService.setTheme(ThemeMode.dark);
      expect(themeService.themeMode.value, equals(ThemeMode.dark));
      
      // Toggle to light
      themeService.toggleTheme();
      expect(themeService.themeMode.value, equals(ThemeMode.light));
    });

    test('should set specific theme mode', () {
      // Set to dark
      themeService.setTheme(ThemeMode.dark);
      expect(themeService.themeMode.value, equals(ThemeMode.dark));
      
      // Set to system
      themeService.setTheme(ThemeMode.system);
      expect(themeService.themeMode.value, equals(ThemeMode.system));
      
      // Set back to light
      themeService.setTheme(ThemeMode.light);
      expect(themeService.themeMode.value, equals(ThemeMode.light));
    });

    test('should notify listeners when theme changes', () {
      bool listenerCalled = false;
      ThemeMode? lastTheme;
      
      themeService.themeMode.addListener(() {
        listenerCalled = true;
        lastTheme = themeService.themeMode.value;
      });

      // Change theme
      themeService.toggleTheme();
      
      expect(listenerCalled, isTrue);
      expect(lastTheme, equals(ThemeMode.dark));
    });

    test('should handle multiple theme changes correctly', () {
      expect(themeService.themeMode.value, equals(ThemeMode.light));
      
      themeService.toggleTheme();
      expect(themeService.themeMode.value, equals(ThemeMode.dark));
      
      themeService.toggleTheme();
      expect(themeService.themeMode.value, equals(ThemeMode.light));
      
      themeService.toggleTheme();
      expect(themeService.themeMode.value, equals(ThemeMode.dark));
    });
  });
}
