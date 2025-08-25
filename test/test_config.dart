import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common test utilities and configurations for the appetite_app tests
class TestConfig {
  /// Creates a test MaterialApp with basic configuration
  static Widget createTestApp({
    required Widget child,
    ThemeData? theme,
    List<NavigatorObserver>? navigatorObservers,
  }) {
    return MaterialApp(
      home: Scaffold(body: child),
      theme: theme ?? ThemeData.light(),
      navigatorObservers: navigatorObservers ?? [],
    );
  }

  /// Creates a test MaterialApp with theme support
  static Widget createTestAppWithTheme({
    required Widget child,
    required ThemeData theme,
  }) {
    return MaterialApp(
      home: Scaffold(body: child),
      theme: theme,
    );
  }

  /// Creates a test MaterialApp with localization support
  static Widget createTestAppWithLocalization({
    required Widget child,
    List<Locale> supportedLocales = const [Locale('en')],
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      home: Scaffold(body: child),
      supportedLocales: supportedLocales,
      locale: locale,
    );
  }

  /// Waits for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Taps a widget and waits for animations
  static Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enters text and waits for animations
  static Future<void> enterTextAndWait(
      WidgetTester tester,
      Finder finder,
      String text,
      ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Finds a widget by type and text
  static Finder findByTypeAndText<T extends Widget>(String text) {
    return find.ancestor(
      of: find.text(text),
      matching: find.byType(Type),
    );
  }

  /// If you need BuildContext, get it from tester
  static BuildContext getContext(WidgetTester tester, Finder finder) {
    return tester.element(finder);
  }

  /// Common test data
  static const testText = 'Test Text';
  static const testHint = 'Test Hint';
  static const testError = 'Test Error';

  /// Common colors for testing
  static const testPrimaryColor = Colors.blue;
  static const testSecondaryColor = Colors.green;
  static const testErrorColor = Colors.red;

  /// Common sizes for testing
  static const testWidth = 100.0;
  static const testHeight = 50.0;
  static const testPadding = 16.0;
  static const testMargin = 8.0;

  /// Common durations for testing
  static const testDuration = Duration(milliseconds: 300);
  static const testDelay = Duration(milliseconds: 100);
}

/// Test data generators
class TestData {
  /// Generates a list of test strings
  static List<String> generateTestStrings(int count) {
    return List.generate(count, (index) => 'Test String $index');
  }

  /// Generates a list of test numbers
  static List<int> generateTestNumbers(int count) {
    return List.generate(count, (index) => index);
  }

  /// Generates a list of test doubles
  static List<double> generateTestDoubles(int count) {
    return List.generate(count, (index) => index.toDouble());
  }

  /// Generates a test date
  static DateTime generateTestDate() {
    return DateTime(2024, 1, 1);
  }

  /// Generates a list of test dates
  static List<DateTime> generateTestDates(int count) {
    return List.generate(
      count,
      (index) => DateTime(2024, 1, 1 + index),
    );
  }
}

/// Test matchers
class TestMatchers {
  /// Matches a widget that has a specific text style
  static Matcher hasTextStyle(TextStyle style) {
    return _HasTextStyle(style);
  }

  /// Matches a widget that has a specific color
  static Matcher hasColor(Color color) {
    return _HasColor(color);
  }

  /// Matches a widget that has a specific size
  static Matcher hasSize(Size size) {
    return _HasSize(size);
  }
}

/// Custom matcher for text style
class _HasTextStyle extends Matcher {
  final TextStyle _style;

  _HasTextStyle(this._style);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Text) {
      return item.style == _style;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('has text style $_style');
  }
}

/// Custom matcher for color
class _HasColor extends Matcher {
  final Color _color;

  _HasColor(this._color);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Container) {
      final decoration = item.decoration as BoxDecoration?;
      return decoration?.color == _color;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('has color $_color');
  }
}

class _HasSize extends Matcher {
  final Size expectedSize;

  _HasSize(this.expectedSize);

  @override
  bool matches(item, Map matchState) {
    if (item is Finder) {
      final element = item.evaluate().first;
      final renderBox = element.renderObject as RenderBox;
      return renderBox.size == expectedSize;
    } else if (item is RenderBox) {
      return item.size == expectedSize;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('виджет имеет размер $expectedSize');
  }
}
