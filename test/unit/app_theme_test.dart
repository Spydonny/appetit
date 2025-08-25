import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    group('lightTheme', () {
      test('should be defined', () {
        expect(AppTheme.lightTheme, isA<ThemeData>());
      });

      test('should use Material 3', () {
        expect(AppTheme.lightTheme.useMaterial3, isTrue);
      });

      test('should have correct color scheme', () {
        final colorScheme = AppTheme.lightTheme.colorScheme;
        expect(colorScheme.primary, equals(Colors.red));
        expect(colorScheme.secondary, equals(Colors.redAccent));
        expect(colorScheme.surface, equals(Colors.white));
        expect(colorScheme.onSurface, equals(Colors.black87));
        expect(colorScheme.primaryContainer, equals(Colors.white));
        expect(colorScheme.onPrimaryContainer, equals(Colors.black12));
      });

      test('should have text theme', () {
        expect(AppTheme.lightTheme.textTheme, isNotNull);
      });

      test('should have input decoration theme', () {
        final inputTheme = AppTheme.lightTheme.inputDecorationTheme;
        expect(inputTheme.border, equals(InputBorder.none));
        expect(inputTheme.hintStyle?.color, equals(Colors.black45));
        expect(inputTheme.suffixIconColor, equals(Colors.black54));
      });
    });

    group('darkTheme', () {
      test('should be defined', () {
        expect(AppTheme.darkTheme, isA<ThemeData>());
      });

      test('should use Material 3', () {
        expect(AppTheme.darkTheme.useMaterial3, isTrue);
      });

      test('should have correct scaffold background color', () {
        expect(AppTheme.darkTheme.scaffoldBackgroundColor, equals(const Color(0xFF1E1E1E)));
      });

      test('should have correct color scheme', () {
        final colorScheme = AppTheme.darkTheme.colorScheme;
        expect(colorScheme.primary, equals(Colors.red));
        expect(colorScheme.secondary, equals(Colors.redAccent));
        expect(colorScheme.surface, equals(const Color(0xFF1E1E1E)));
        expect(colorScheme.onSurface, equals(Colors.white70));
        expect(colorScheme.primaryContainer, equals(const Color.fromARGB(20, 0, 0, 0)));
        expect(colorScheme.onPrimaryContainer, equals(Colors.transparent));
      });

      test('should have text theme', () {
        expect(AppTheme.darkTheme.textTheme, isNotNull);
      });

      test('should have input decoration theme', () {
        final inputTheme = AppTheme.darkTheme.inputDecorationTheme;
        expect(inputTheme.border, equals(InputBorder.none));
        expect(inputTheme.hintStyle?.color, equals(Colors.white54));
        expect(inputTheme.suffixIconColor, equals(Colors.white60));
      });
    });

    test('should have different themes for light and dark', () {
      expect(AppTheme.lightTheme, isNot(equals(AppTheme.darkTheme)));
    });

    test('should have consistent text theme structure across themes', () {
      final lightTextTheme = AppTheme.lightTheme.textTheme;
      final darkTextTheme = AppTheme.darkTheme.textTheme;
      
      // Check that both themes have the same text theme structure
      expect(lightTextTheme.displayLarge, isNotNull);
      expect(darkTextTheme.displayLarge, isNotNull);
      expect(lightTextTheme.displayMedium, isNotNull);
      expect(darkTextTheme.displayMedium, isNotNull);
      expect(lightTextTheme.bodyLarge, isNotNull);
      expect(darkTextTheme.bodyLarge, isNotNull);
    });
  });
}
