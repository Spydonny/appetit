import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/theme_service_test.dart' as theme_service_test;
import 'unit/app_service_test.dart' as app_service_test;
import 'unit/app_theme_test.dart' as app_theme_test;
import 'unit/calligraphy_test.dart' as calligraphy_test;
import 'unit/service_locator_test.dart' as service_locator_test;

import 'widget/pill_button_test.dart' as pill_button_test;
import 'widget/inset_textfield_test.dart' as inset_textfield_test;
import 'widget/default_container_test.dart' as default_container_test;
import 'widget/default_map_test.dart' as default_map_test;
import 'widget/main_app_test.dart' as main_app_test;

import 'integration/app_integration_test.dart' as app_integration_test;

/// Main test runner that executes all tests in the project
void main() {
  // Run unit tests
  group('Unit Tests', () {
    theme_service_test.main();
    app_service_test.main();
    app_theme_test.main();
    calligraphy_test.main();
    service_locator_test.main();
  });

  // Run widget tests
  group('Widget Tests', () {
    pill_button_test.main();
    inset_textfield_test.main();
    default_container_test.main();
    default_map_test.main();
    main_app_test.main();
  });

  // Run integration tests
  group('Integration Tests', () {
    app_integration_test.main();
  });
}

/// Test categories for better organization
class TestCategories {
  static const String unit = 'unit';
  static const String widget = 'widget';
  static const String integration = 'integration';
  static const String smoke = 'smoke';
  static const String performance = 'performance';
}

/// Test utilities for common operations
class TestUtils {
  /// Runs a specific test category
  static void runCategory(String category) {
    switch (category) {
      case TestCategories.unit:
        _runUnitTests();
        break;
      case TestCategories.widget:
        _runWidgetTests();
        break;
      case TestCategories.integration:
        _runIntegrationTests();
        break;
      case TestCategories.smoke:
        _runSmokeTests();
        break;
      case TestCategories.performance:
        _runPerformanceTests();
        break;
      default:
        print('Unknown test category: $category');
    }
  }

  /// Runs all unit tests
  static void _runUnitTests() {
    print('Running unit tests...');
    theme_service_test.main();
    app_service_test.main();
    app_theme_test.main();
    calligraphy_test.main();
    service_locator_test.main();
  }

  /// Runs all widget tests
  static void _runWidgetTests() {
    print('Running widget tests...');
    pill_button_test.main();
    inset_textfield_test.main();
    default_container_test.main();
    default_map_test.main();
    main_app_test.main();
  }

  /// Runs all integration tests
  static void _runIntegrationTests() {
    print('Running integration tests...');
    app_integration_test.main();
  }

  /// Runs smoke tests (basic functionality)
  static void _runSmokeTests() {
    print('Running smoke tests...');
    // Run basic tests to ensure app doesn't crash
    theme_service_test.main();
    app_theme_test.main();
    pill_button_test.main();
  }

  /// Runs performance tests
  static void _runPerformanceTests() {
    print('Running performance tests...');
    // Performance tests would go here
    print('Performance tests not implemented yet');
  }

  /// Runs tests with coverage
  static void runWithCoverage() {
    print('Running tests with coverage...');
    // This would typically be run from command line with flutter test --coverage
    print('Use: flutter test --coverage');
  }

  /// Runs tests in parallel
  static void runInParallel() {
    print('Running tests in parallel...');
    // This would typically be run from command line with flutter test --concurrency
    print('Use: flutter test --concurrency=4');
  }
}

/// Test configuration
class TestConfiguration {
  static const int defaultTimeout = 30; // seconds
  static const bool enableVerboseLogging = false;
  static const bool enablePerformanceProfiling = false;
  
  /// Test environment setup
  static void setupTestEnvironment() {
    if (enableVerboseLogging) {
      print('Setting up test environment with verbose logging...');
    }
    
    if (enablePerformanceProfiling) {
      print('Setting up test environment with performance profiling...');
    }
  }
  
  /// Test environment cleanup
  static void cleanupTestEnvironment() {
    if (enableVerboseLogging) {
      print('Cleaning up test environment...');
    }
  }
}
