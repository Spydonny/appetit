import 'package:appetite_app/features/auth/view/pages/login_page.dart';
import 'package:appetite_app/features/main/view/pages_screens/main_page.dart';
import 'package:appetite_app/features/shared/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/view/pages/signup_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'features/main/logic/bloc/cart_bloc/cart_bloc.dart';
import 'features/main/logic/bloc/menu_bloc/menu_bloc.dart';
import 'firebase_options.dart';
import 'core/core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Future<bool> _initFuture;
  bool _navigated = false; // 🔹 защита от повторной навигации

  @override
  void initState() {
    super.initState();
    _initFuture = _initSession();
  }

  Future<bool> _initSession() async {
    try {
      final auth = getIt<AuthService>();
      await auth.loadSession();
      debugPrint(auth.accessToken);
      return auth.accessToken != null;
    } catch (e) {
      debugPrint('Error loading session: $e');
      return false; // Default: not authed
    }
  }

  void _navigate(bool isAuthed) {
    if (_navigated) return;
    _navigated = true;

    final page = isAuthed ? const MainPage() : const LoginPage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder<bool>(
      future: _initFuture,
      builder: (context, snapshot) {
        // 🔹 Лоадер
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(screenWidth, screenHeight);
        }

        // 🔹 Ошибка
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Ошибка сервера",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initFuture = _initSession();
                        _navigated = false; // сброс
                      });
                    },
                    child: const Text("Повторить"),
                  ),
                ],
              ),
            ),
          );
        }

        // 🔹 Успешный результат
        final isAuthed = snapshot.data ?? false;
        _navigate(isAuthed);

        // Показ временного экрана с логотипом пока идёт навигация
        return _buildLoading(screenWidth, screenHeight);
      },
    );
  }

  Widget _buildLoading(double w, double h) {
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: AppIcons.logoAppetiteRound, height: 80),
              const SizedBox(height: 16),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("FCM background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Firebase init ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- FCM background handler ---
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // --- Запрос разрешений (для Android 13+ и iOS) ---
  await FirebaseMessaging.instance.requestPermission();

  final token = await FirebaseMessaging.instance.getToken();
  print("Web FCM token: $token");

  // --- Localizations ---
  await EasyLocalization.ensureInitialized();

  // --- Service locator ---
  setupLocator();

  // --- HydratedBloc storage ---
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

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

  // --- Обработка сообщений в активном приложении ---
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint("FCM foreground: ${message.notification?.title}");
  });

  // --- Обработка клика по пушу ---
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint("FCM opened: ${message.data}");
  });
}

final themeService = getIt<ThemeService>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return ValueListenableBuilder(
      valueListenable: themeService.themeMode,
      builder: (context, mode, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CartBloc>(
              create: (_) => CartBloc(),
            ),
            BlocProvider<MenuBloc>(
              create: (_) => MenuBloc(),
            ),
          ],
          child: MaterialApp(
            title: 'Appetite',
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: const SplashPage(),
          ),
        );
      },
    );
  }
}


