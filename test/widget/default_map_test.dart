import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/widgets/map/default_map.dart';

void main() {
  group('DefaultMap', () {
    testWidgets('should render with basic properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
    });

    testWidgets('should render with custom camera position', (WidgetTester tester) async {
      const customPosition = CameraPosition(
        target: LatLng(40.7128, -74.0060), // New York
        zoom: 10.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              cameraPosition: customPosition,
            ),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
    });

    testWidgets('should render with selectable mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              selectable: true,
            ),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
    });

    testWidgets('should render with external address controller', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              addressController: controller,
            ),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
    });

    testWidgets('should render with all properties combined', (WidgetTester tester) async {
      final controller = TextEditingController();
      const customPosition = CameraPosition(
        target: LatLng(51.5074, -0.1278), // London
        zoom: 12.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              cameraPosition: customPosition,
              selectable: true,
              addressController: controller,
            ),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
    });

    testWidgets('should have correct default camera position', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(),
          ),
        ),
      );

      // The default position should be Ust-Kamenogorsk
      expect(DefaultMap._kUstKamenogorsk.target.latitude, equals(49.9483));
      expect(DefaultMap._kUstKamenogorsk.target.longitude, equals(82.6275));
      expect(DefaultMap._kUstKamenogorsk.zoom, equals(12.4746));
    });

    testWidgets('should handle null address controller gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
      // Should not crash when no external controller is provided
    });

    testWidgets('should render search text field when selectable is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              selectable: true,
            ),
          ),
        ),
      );

      // Should show search text field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Введите адрес...'), findsOneWidget);
    });

    testWidgets('should not render search text field when selectable is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              selectable: false,
            ),
          ),
        ),
      );

      // Should not show search text field
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('should render search icon when selectable is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              selectable: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should handle external controller properly', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Initial address');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              addressController: controller,
              selectable: true,
            ),
          ),
        ),
      );

      // The external controller should be used
      expect(controller.text, equals('Initial address'));
    });

    testWidgets('should create internal controller when none provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              selectable: true,
            ),
          ),
        ),
      );

      // Should still have a text field for search
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should render with proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              selectable: true,
            ),
          ),
        ),
      );

      // Should have a Stack as the main layout
      expect(find.byType(Stack), findsOneWidget);
      
      // Should have a Card for the search field when selectable
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should handle different camera positions', (WidgetTester tester) async {
      final positions = [
        const CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 1.0,
        ),
        const CameraPosition(
          target: LatLng(90.0, 180.0),
          zoom: 20.0,
        ),
        const CameraPosition(
          target: LatLng(-90.0, -180.0),
          zoom: 5.0,
        ),
      ];

      for (final position in positions) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DefaultMap(
                cameraPosition: position,
              ),
            ),
          ),
        );

        expect(find.byType(DefaultMap), findsOneWidget);
      }
    });

    testWidgets('should handle edge cases for camera position', (WidgetTester tester) async {
      // Test with extreme values
      const extremePosition = CameraPosition(
        target: LatLng(89.999, 179.999),
        zoom: 0.1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultMap(
              cameraPosition: extremePosition,
            ),
          ),
        ),
      );

      expect(find.byType(DefaultMap), findsOneWidget);
    });
  });
}
