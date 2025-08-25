import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/core/theme/calligraphy.dart';

void main() {
  group('Calligraphy', () {
    test('should have correct font family', () {
      expect(Calligraphy.fontFamily, equals('TTHoves'));
    });

    test('should have text theme defined', () {
      expect(Calligraphy.textTheme, isA<TextTheme>());
    });

    group('displayLarge', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.displayLarge;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w700));
        expect(style?.fontSize, equals(48));
        expect(style?.letterSpacing, equals(-1.5));
      });
    });

    group('displayMedium', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.displayMedium;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w700));
        expect(style?.fontSize, equals(36));
        expect(style?.letterSpacing, equals(-0.5));
      });
    });

    group('displaySmall', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.displaySmall;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w500));
        expect(style?.fontSize, equals(28));
      });
    });

    group('headlineMedium', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.headlineMedium;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w500));
        expect(style?.fontSize, equals(24));
      });
    });

    group('headlineSmall', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.headlineSmall;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w500));
        expect(style?.fontSize, equals(20));
      });
    });

    group('titleLarge', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.titleLarge;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w700));
        expect(style?.fontSize, equals(18));
      });
    });

    group('titleMedium', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.titleMedium;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w500));
        expect(style?.fontSize, equals(16));
      });
    });

    group('titleSmall', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.titleSmall;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w300));
        expect(style?.fontSize, equals(14));
      });
    });

    group('bodyLarge', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.bodyLarge;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w500));
        expect(style?.fontSize, equals(16));
      });
    });

    group('bodyMedium', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.bodyMedium;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w300));
        expect(style?.fontSize, equals(14));
      });
    });

    group('bodySmall', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.bodySmall;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w300));
        expect(style?.fontSize, equals(12));
      });
    });

    group('labelLarge', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.labelLarge;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w500));
        expect(style?.fontSize, equals(14));
      });
    });

    group('labelSmall', () {
      test('should have correct properties', () {
        final style = Calligraphy.textTheme.labelSmall;
        expect(style?.fontFamily, equals('TTHoves'));
        expect(style?.fontWeight, equals(FontWeight.w300));
        expect(style?.fontSize, equals(10));
      });
    });

    test('should have consistent font family across all text styles', () {
      final textTheme = Calligraphy.textTheme;
      final styles = [
        textTheme.displayLarge,
        textTheme.displayMedium,
        textTheme.displaySmall,
        textTheme.headlineMedium,
        textTheme.headlineSmall,
        textTheme.titleLarge,
        textTheme.titleMedium,
        textTheme.titleSmall,
        textTheme.bodyLarge,
        textTheme.bodyMedium,
        textTheme.bodySmall,
        textTheme.labelLarge,
        textTheme.labelSmall,
      ];

      for (final style in styles) {
        expect(style?.fontFamily, equals('TTHoves'));
      }
    });

    test('should have appropriate font weights for different text styles', () {
      final textTheme = Calligraphy.textTheme;
      
      // Display and title styles should be bold
      expect(textTheme.displayLarge?.fontWeight, equals(FontWeight.w700));
      expect(textTheme.displayMedium?.fontWeight, equals(FontWeight.w700));
      expect(textTheme.titleLarge?.fontWeight, equals(FontWeight.w700));
      
      // Body and label styles should be medium or light
      expect(textTheme.bodyLarge?.fontWeight, equals(FontWeight.w500));
      expect(textTheme.bodyMedium?.fontWeight, equals(FontWeight.w300));
      expect(textTheme.labelLarge?.fontWeight, equals(FontWeight.w500));
    });
  });
}
