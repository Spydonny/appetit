import 'package:appetite_app/features/main/view/pages_screens/cart_screen.dart';
import 'package:appetite_app/features/main/view/pages_screens/menu_screen.dart';
import 'package:appetite_app/features/main/view/pages_screens/profile_screen.dart';
import 'package:appetite_app/features/shared/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/core.dart';
import '../../../auth/services/services.dart';
import '../../../shared/data/users/models/user.dart';
import '../../data/models/orders/order.dart';
import '../../logic/service/order_service.dart';

final ValueNotifier<bool> isKazakh = ValueNotifier(false);
final ValueNotifier<bool> isLight = ValueNotifier(true);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  late SharedPreferences sharedPrefs;
  bool isLoadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    sharedPrefs = await SharedPreferences.getInstance();

    final language = sharedPrefs.getString('language') ?? 'ru';
    final strTheme = sharedPrefs.getString('theme') ?? 'light';

    setState(() {
      isKazakh.value = language == 'kk';
      isLight.value = strTheme == 'light';
      isLoadingPrefs = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingPrefs) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final screens = [
      const MenuScreen(),
      ProfileScreen(sharedPrefs: sharedPrefs), // 👈 теперь он сам грузит профиль и заказы
      const CartScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Appetit')),
        bottom: isCafeClosed
            ? PreferredSize(
          preferredSize: Size(screenWidth, screenHeight * 0.035),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: Text(
                tr('cafe_closed'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        )
            : const PreferredSize(preferredSize: Size(0, 0), child: SizedBox()),
      ),
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt),
            label: tr("menu"),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_box),
            label: tr("profile"),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_basket),
            label: tr("cart"),
          ),
        ],
      ),
    );
  }

  bool get isCafeClosed {
    final nowHour = DateTime.now().hour;
    return nowHour > 2 && nowHour < 7;
  }
}


