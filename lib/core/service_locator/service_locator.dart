import 'package:get_it/get_it.dart';
import '../../features/shared/shared.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AppService>(() => AppService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());

  // если будут другие сервисы:
  // getIt.registerLazySingleton<DialogService>(() => DialogService());
  // getIt.registerSingletonAsync<SomeService>(() async => await SomeService.create());
}
