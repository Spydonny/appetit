import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/widgets/buttons/pill_button.dart';

void main() {
  group('PillButton', () {
    testWidgets('should render with correct properties', (WidgetTester tester) async {
      const testText = 'Test Button';
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () => buttonPressed = true,
              child: const Text(testText),
              colorPrimary: Colors.blue,
              colorOnPrimary: Colors.white,
            ),
          ),
        ),
      );

      // Verify button is rendered
      expect(find.byType(PillButton), findsOneWidget);
      expect(find.text(testText), findsOneWidget);
      
      // Verify button has correct colors
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      
      expect(buttonStyle?.backgroundColor?.resolve({}), equals(Colors.blue));
      expect(buttonStyle?.foregroundColor?.resolve({}), equals(Colors.white));
    });

    testWidgets('should have correct styling properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Test'),
              colorPrimary: Colors.red,
              colorOnPrimary: Colors.white,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      
      // Check shape (rounded corners)
      final shape = buttonStyle?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      
      // Check elevation
      expect(buttonStyle?.elevation?.resolve({}), equals(0));
      
      // Check fixed size
      final size = buttonStyle?.fixedSize?.resolve({});
      expect(size?.height, equals(56));
      
      // Check padding
      final padding = buttonStyle?.padding?.resolve({});
      expect(padding, equals(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)));
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () => buttonPressed = true,
              child: const Text('Test'),
              colorPrimary: Colors.blue,
              colorOnPrimary: Colors.white,
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(PillButton));
      await tester.pump();

      expect(buttonPressed, isTrue);
    });

    testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: null, // Disabled
              child: const Text('Test'),
              colorPrimary: Colors.blue,
              colorOnPrimary: Colors.white,
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(PillButton));
      await tester.pump();

      expect(buttonPressed, isFalse);
    });

    testWidgets('should apply theme text style', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Test'),
              colorPrimary: Colors.blue,
              colorOnPrimary: Colors.white,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      final textStyle = buttonStyle?.textStyle?.resolve({});
      
      expect(textStyle?.fontSize, equals(18));
      expect(textStyle?.fontWeight, equals(FontWeight.w600));
      expect(textStyle?.letterSpacing, equals(0.2));
    });

    testWidgets('should have correct overlay color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Test'),
              colorPrimary: Colors.blue,
              colorOnPrimary: Colors.white,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      final overlayColor = buttonStyle?.overlayColor?.resolve({});
      
      // Should be white with 20 alpha
      expect(overlayColor, equals(Colors.white.withAlpha(20)));
    });

    testWidgets('should render with custom child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 8),
                  Text('Star Button'),
                ],
              ),
              colorPrimary: Colors.yellow,
              colorOnPrimary: Colors.black,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star Button'), findsOneWidget);
    });
  });
}
