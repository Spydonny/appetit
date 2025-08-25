import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/widgets/text_field/inset_textfield.dart';

void main() {
  group('InsetTextField', () {
    testWidgets('should render with basic properties', (WidgetTester tester) async {
      const hintText = 'Enter text here';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              hintText: hintText,
            ),
          ),
        ),
      );

      expect(find.byType(InsetTextField), findsOneWidget);
      expect(find.text(hintText), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should render with controller', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Initial text');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Initial text'), findsOneWidget);
    });

    testWidgets('should handle text input', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test input');
      await tester.pump();

      expect(controller.text, equals('Test input'));
    });

    testWidgets('should show password visibility toggle when obscureText is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              obscureText: true,
            ),
          ),
        ),
      );

      // Should show visibility toggle icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('should toggle password visibility when icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              obscureText: true,
            ),
          ),
        ),
      );

      // Initial state - password is hidden
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap the visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Should now show password
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('should not show password visibility toggle when obscureText is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              obscureText: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsNothing);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('should handle multiline input when maxLines > 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              maxLines: 3,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.multiline));
      expect(textField.textInputAction, equals(TextInputAction.newline));
    });

    testWidgets('should handle single line input when maxLines is 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.emailAddress));
      expect(textField.textInputAction, equals(TextInputAction.done));
    });

    testWidgets('should call onSubmitted for single line text fields', (WidgetTester tester) async {
      String? submittedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              maxLines: 1,
              onSubmitted: (value) => submittedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedValue, equals('Test'));
    });

    testWidgets('should not call onSubmitted for multiline text fields', (WidgetTester tester) async {
      String? submittedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              maxLines: 3,
              onSubmitted: (value) => submittedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.testTextInput.receiveAction(TextInputAction.newline);
      await tester.pump();

      expect(submittedValue, isNull);
    });

    testWidgets('should respect enabled property', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('should have correct styling and decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.ancestor(
        of: find.byType(TextField),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      
      // Check border radius
      expect(decoration.borderRadius, equals(BorderRadius.circular(15)));
      
      // Check padding
      expect(container.padding, equals(const EdgeInsets.symmetric(horizontal: 20, vertical: 5)));
    });

    testWidgets('should handle different keyboard types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsetTextField(
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.number));
    });
  });
}
