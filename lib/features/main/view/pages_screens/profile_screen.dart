import 'package:appetite_app/widgets/switches/inset_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthDateController;

  bool isKazakh = false;

  // Заглушка для истории заказов
  final List<Map<String, dynamic>> orders = [
    {"title": "Маргарита", "date": "15.08.2025", "price": 2000},
    {"title": "Пепперони", "date": "12.08.2025", "price": 2500},
    {"title": "Филадельфия", "date": "10.08.2025", "price": 3000},
  ];

  @override
  void initState() {
    super.initState();

    // Пока заглушка
    _firstNameController = TextEditingController(text: "Алихан");
    _lastNameController = TextEditingController(text: "Касымов");
    _phoneController = TextEditingController(text: "+7 701 123 4567");
    _addressController = TextEditingController(text: "г. Алматы, ул. Абая, 25");
    _birthDateController = TextEditingController(text: "15.03.2002");
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Аватар
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Disabled поля
          InsetTextField(
            controller: _firstNameController,
            enabled: false,
            hintText: tr("first_name"), // 🔑
          ),
          const SizedBox(height: 16),
          InsetTextField(
            controller: _lastNameController,
            enabled: false,
            hintText: tr("last_name"), // 🔑
          ),
          const SizedBox(height: 16),
          InsetTextField(
            controller: _phoneController,
            enabled: false,
            hintText: tr("phone"), // 🔑
          ),
          const SizedBox(height: 16),
          InsetTextField(
            controller: _addressController,
            enabled: false,
            hintText: tr("address"), // 🔑
          ),
          const SizedBox(height: 16),
          InsetTextField(
            controller: _birthDateController,
            enabled: false,
            hintText: tr("birth_date"), // 🔑
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),

          // Переключатель языка
          Row(
            children: [
              Expanded(
                child: InsetSwitch(
                  label: '${tr("change_language")}  ${isKazakh ? '🇰🇿' : '🇷🇺'}',
                  value: isKazakh,
                  onChanged: (value) {
                    setState(() {
                      isKazakh = value;
                    });
                    context.setLocale(Locale(isKazakh ? 'kk' : 'ru'));
                  },
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),

          // История заказов
          Text(
            tr("order_history"), // 🔑
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DefaultContainer(
                  child: ListTile(
                    title: Text(order["title"]),
                    subtitle: Text("${tr("date")}: ${order["date"]}"), // 🔑
                    trailing: Text("${order["price"]} ₸"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
