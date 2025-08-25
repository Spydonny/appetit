import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetite_app/features/shared/services/app_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Генерация моков только для контроллеров
@GenerateMocks([TextEditingController])
import 'app_service_test.mocks.dart';

void main() {
  group('AppService', () {
    late AppService appService;
    late MockTextEditingController mockDateController;
    late MockTextEditingController mockAddressController;

    setUp(() {
      appService = AppService();
      mockDateController = MockTextEditingController();
      mockAddressController = MockTextEditingController();
    });

    group('openDatePicker', () {
      test('should be defined', () {
        expect(appService.openDatePicker, isA<Function>());
      });

      test('should have correct signature', () {
        expect(
          appService.openDatePicker,
          isA<Future<void> Function(BuildContext, TextEditingController)>(),
        );
      });

      // showDatePicker требует widget/integration теста
    });

    group('openMap', () {
      test('should be defined', () {
        expect(appService.openMap, isA<Function>());
      });

      test('should have correct signature', () {
        // если метод возвращает void
        expect(
          appService.openMap,
          isA<void Function(BuildContext, TextEditingController)>(),
        );

        // если метод возвращает Future<void>, замени на:
        // expect(appService.openMap, isA<Future<void> Function(BuildContext, TextEditingController)>());
      });

      // Navigator.push тоже проверяется в widget/integration тестах
    });

    test('should be instantiable', () {
      expect(appService, isA<AppService>());
    });

    test('should have no required parameters in constructor', () {
      expect(() => AppService(), returnsNormally);
    });
  });
}
