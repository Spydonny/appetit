import 'package:appetite_app/features/main/view/pages_screens/cart_screen.dart';
import 'package:appetite_app/features/main/view/pages_screens/menu_screen.dart';
import 'package:appetite_app/features/main/view/pages_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  final List<Widget> screens = [
    const MenuScreen(),
    const ProfileScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              child: Text(
                tr("menu"),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(tr("home")), // 🔑
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(tr("settings")), // 🔑
              onTap: () {},
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: const Text('Appetit'),
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
            label: tr("menu"), // 🔑
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_box),
            label: tr("profile"), // 🔑
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_basket),
            label: tr("cart"), // 🔑
          ),
        ],
      ),
    );
  }
}
