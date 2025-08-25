import 'package:appetite_app/core/theme/app_theme.dart';
import 'package:appetite_app/features/main/view/pages_screens/main_page.dart';
import 'package:appetite_app/features/shared/services/services.dart';
import 'package:flutter/material.dart';
import 'features/auth/view/pages/signup_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  setupLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru'),
        Locale('kk'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const MyApp(),
    ),
  );
}
final themeService = getIt<ThemeService>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeService.themeMode,
        builder: (context, mode, _) {
          return MaterialApp(
            title: 'Appetite',
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
              home: const MainPage(),
          );
        });
  }
}


