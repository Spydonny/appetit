import 'package:appetite_app/features/main/view/pages_screens/cart_screen.dart';
import 'package:appetite_app/features/main/view/pages_screens/menu_screen.dart';
import 'package:appetite_app/features/main/view/pages_screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  final List<Widget> screens = [MenuScreen(), ProfileScreen(), CartScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text('Меню', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Главная'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Настройки'),
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
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Меню'),
          NavigationDestination(icon: Icon(Icons.account_box), label: 'Профиль'),
          NavigationDestination(icon: Icon(Icons.shopping_basket), label: 'Корзина',),
        ],
      ),
    );
  }
}