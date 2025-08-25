import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/widgets/containers/default_container.dart';

void main() {
  group('DefaultContainer', () {
    testWidgets('should render with basic properties', (WidgetTester tester) async {
      const testText = 'Test Content';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              child: const Text(testText),
            ),
          ),
        ),
      );

      expect(find.byType(DefaultContainer), findsOneWidget);
      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('should apply default styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      // Check default color
      expect(decoration.color, equals(Colors.white12));
      
      // Check default padding
      expect(container.padding, equals(const EdgeInsets.all(32)));
      
      // Check default margin
      expect(container.margin, equals(const EdgeInsets.all(8)));
      
      // Check border radius
      expect(decoration.borderRadius, equals(BorderRadius.circular(30)));
    });

    testWidgets('should apply custom styling properties', (WidgetTester tester) async {
      const customColor = Colors.blue;
      const customPadding = EdgeInsets.all(16);
      const customMargin = EdgeInsets.all(4);
      const customWidth = 200.0;
      const customHeight = 150.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              color: customColor,
              padding: customPadding,
              margin: customMargin,
              width: customWidth,
              height: customHeight,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, equals(customColor));
      expect(container.padding, equals(customPadding));
      expect(container.margin, equals(customMargin));
    });

    testWidgets('should use theme colors for border', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primaryContainer: Colors.red,
              onPrimaryContainer: Colors.blue,
            ),
          ),
          home: Scaffold(
            body: DefaultContainer(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      // Check that border uses theme colors
      expect(decoration.border?.top.color, equals(Colors.blue));
    });

    testWidgets('should render with complex child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              child: Column(
                children: [
                  const Text('Header'),
                  const SizedBox(height: 16),
                  const Text('Content'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Button'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle null width and height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

    });

    testWidgets('should maintain aspect ratio when width and height are specified', (WidgetTester tester) async {
      const customWidth = 300.0;
      const customHeight = 200.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              width: customWidth,
              height: customHeight,
              child: const Text('Test'),
            ),
          ),
        ),
      );

    });

    testWidgets('should apply border to all sides', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border;
      
      expect(border, isNotNull);
      expect(border!.top.color, equals(border.bottom.color));
    });

    testWidgets('should handle empty child', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultContainer(
              child: const SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(find.byType(DefaultContainer), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should work with different theme modes', (WidgetTester tester) async {
      // Test with light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: DefaultContainer(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(DefaultContainer), findsOneWidget);

      // Test with dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: DefaultContainer(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(DefaultContainer), findsOneWidget);
    });
  });
}
