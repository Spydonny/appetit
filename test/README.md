# Appetite App Test Suite

This directory contains comprehensive tests for the Appetite App Flutter project.

## Test Structure

```
test/
├── unit/                    # Unit tests for services and business logic
│   ├── theme_service_test.dart
│   ├── app_service_test.dart
│   ├── app_theme_test.dart
│   ├── calligraphy_test.dart
│   └── service_locator_test.dart
├── widget/                  # Widget tests for UI components
│   ├── pill_button_test.dart
│   ├── inset_textfield_test.dart
│   ├── default_container_test.dart
│   ├── default_map_test.dart
│   └── main_app_test.dart
├── integration/             # Integration tests for app-wide functionality
│   └── app_integration_test.dart
├── test_config.dart         # Common test utilities and configurations
├── test_runner.dart         # Test runner and organization utilities
└── README.md               # This file
```

## Test Categories

### Unit Tests (`test/unit/`)
- **ThemeService**: Tests theme switching and management
- **AppService**: Tests app-level services like date picker and map
- **AppTheme**: Tests theme configuration and properties
- **Calligraphy**: Tests text theme and font configurations
- **ServiceLocator**: Tests dependency injection setup

### Widget Tests (`test/widget/`)
- **PillButton**: Tests button rendering, styling, and interactions
- **InsetTextField**: Tests text input behavior and password visibility
- **DefaultContainer**: Tests container styling and properties
- **DefaultMap**: Tests map widget structure and basic functionality
- **MainApp**: Tests main app structure and configuration

### Integration Tests (`test/integration/`)
- **AppIntegration**: Tests service integration and app-wide functionality

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Run only unit tests
flutter test test/unit/

# Run only widget tests
flutter test test/widget/

# Run only integration tests
flutter test test/integration/
```

### Run Specific Test Files
```bash
# Run a specific test file
flutter test test/unit/theme_service_test.dart

# Run multiple specific test files
flutter test test/unit/theme_service_test.dart test/unit/app_service_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Tests in Parallel
```bash
flutter test --concurrency=4
```

### Run Tests with Verbose Output
```bash
flutter test --verbose
```

## Test Configuration

### Test Utilities (`test_config.dart`)
The `TestConfig` class provides common utilities for:
- Creating test MaterialApp instances
- Waiting for animations
- Common test data and colors
- Custom test matchers

### Test Runner (`test_runner.dart`)
The `TestRunner` class provides:
- Organized test execution
- Test categorization
- Performance and smoke test options

## Writing New Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/path/to/your/class.dart';

void main() {
  group('YourClass', () {
    late YourClass instance;

    setUp(() {
      instance = YourClass();
    });

    tearDown(() {
      // Cleanup if needed
    });

    test('should do something', () {
      // Your test logic here
      expect(instance.someMethod(), equals(expectedValue));
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/widgets/your_widget.dart';

void main() {
  group('YourWidget', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YourWidget(),
          ),
        ),
      );

      expect(find.byType(YourWidget), findsOneWidget);
    });
  });
}
```

## Test Best Practices

1. **Use descriptive test names** that explain what is being tested
2. **Group related tests** using the `group()` function
3. **Set up and tear down** test data properly
4. **Test edge cases** and error conditions
5. **Use meaningful assertions** with clear expected values
6. **Keep tests independent** - each test should not depend on others
7. **Mock external dependencies** when testing in isolation
8. **Test both success and failure scenarios**

## Dependencies

The test suite uses the following Flutter testing packages:
- `flutter_test`: Core Flutter testing framework
- `mockito`: For creating mocks (when needed)

## Coverage Goals

- **Unit Tests**: Aim for 90%+ coverage of business logic
- **Widget Tests**: Cover all user interactions and rendering
- **Integration Tests**: Test critical user flows

## Troubleshooting

### Common Issues

1. **Test fails with "No MediaQuery ancestor"**
   - Wrap your widget in a `MaterialApp` or use `TestConfig.createTestApp()`

2. **Test fails with "No Navigator ancestor"**
   - Use `TestConfig.createTestApp()` with navigator observers

3. **Async test failures**
   - Use `await tester.pumpAndSettle()` for animations
   - Use `await tester.pump()` for state changes

4. **Widget not found**
   - Check that the widget is actually rendered
   - Use `tester.dumpWidgetTree()` to debug widget tree

### Debug Commands

```bash
# Show widget tree for debugging
flutter test --verbose

# Run tests with specific device
flutter test -d <device-id>

# Run tests and show coverage report
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

## Contributing

When adding new tests:
1. Follow the existing naming conventions
2. Add tests to the appropriate category
3. Update this README if adding new test categories
4. Ensure all tests pass before committing
5. Add meaningful test descriptions

## Support

For questions about the test suite, refer to:
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Flutter Test Package](https://pub.dev/packages/flutter_test)
- [Mockito Package](https://pub.dev/packages/mockito)
