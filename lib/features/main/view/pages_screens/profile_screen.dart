import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/widgets.dart';
import '../../../auth/services/services.dart';
import '../../../shared/shared.dart';
import '../../data/models/orders/order.dart';
import '../../logic/service/order_service.dart';
import '../../../../core/core.dart';
import 'main_page.dart';

class ProfileScreen extends StatefulWidget {
  final SharedPreferences sharedPrefs;

  const ProfileScreen({
    super.key,
    required this.sharedPrefs,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthDateController;

  late final SharedPreferences sharedPrefs;

  final Set<TextEditingController> _editableControllers = {};
  final Map<TextEditingController, FocusNode> _focusNodes = {};

  User? user;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    sharedPrefs = widget.sharedPrefs;

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _birthDateController = TextEditingController();

    _loadProfileAndOrders();
  }

  Future<void> _loadProfileAndOrders() async {
    final auth = getIt<AuthService>();
    final orderService = getIt<OrderService>();

    final results = await Future.wait([
      auth.refreshUser(),
      orderService.getMyOrders(),
    ]);

    final loadedUser = results[0] as User?;
    final myOrders = results[1] as List<Order>;

    setState(() {
      user = loadedUser;
      orders = myOrders.map((o) => {
        "title": o.items.map((e) => e.nameSnapshot).join(", "),
        "date": o.createdAt,
        "price": o.total,
        "status": o.status
      }).toList();
      isLoading = false;
    });

    _fillProfileFields();
  }

  void _fillProfileFields() {
    if (user != null) {
      final parts = (user!.fullName).split(" ");
      _firstNameController.text = parts.isNotEmpty ? parts.first : "";
      _lastNameController.text =
      parts.length > 1 ? parts.sublist(1).join(" ") : "";
      _phoneController.text = user!.phone ?? "";
      _addressController.text = 'Утепова 21';
      _birthDateController.text = user!.dob ?? '';
    }
  }

  Future<void> _saveProfile() async {
    final auth = getIt<AuthService>();

    final updated = await auth.updateProfile(
      fullName: "${_firstNameController.text} ${_lastNameController.text}",
      phone: _phoneController.text,
      email: auth.currentUser?.email,
      dob: _birthDateController.text,
      address: _addressController.text
    );

    setState(() {
      user = updated;
      _fillProfileFields();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr("profile_updated"))),
    );
  }

  Future<void> _pickBirthday() async {
    await getIt<AppService>().openDatePicker(context, _birthDateController);
    await Future.delayed(const Duration(milliseconds: 200)); // задержка
    await _saveProfile();
  }

  Future<void> _pickAddress() async {
    getIt<AppService>().openMap(context, _addressController);
    await Future.delayed(const Duration(milliseconds: 200)); // задержка
    await _saveProfile();
  }

  FocusNode _focusOf(TextEditingController c) =>
      _focusNodes.putIfAbsent(c, () => FocusNode());

  Widget _buildGestureEditableField({
    required TextEditingController controller,
    required String hintText,
    VoidCallback? onDoubleTap,
  }) {
    final focusNode = _focusOf(controller);
    final enabled = _editableControllers.contains(controller);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () async {
        if (onDoubleTap != null) {
          onDoubleTap();
          return;
        }
        if (!enabled) {
          setState(() {
            _editableControllers.add(controller);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            focusNode.requestFocus();
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          });
        }
      },
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) async {
          if (!hasFocus && _editableControllers.contains(controller)) {
            await _saveProfile();
            setState(() {
              _editableControllers.remove(controller);
            });
          }
        },
        child: InsetTextField(
          controller: controller,
          enabled: enabled,
          hintText: hintText,
          maxLines: 1,
        ),
      ),
    );
  }

  Padding _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Аватар
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

          // 🔹 Editable поля
          Column(
            children: [
              _buildGestureEditableField(
                controller: _firstNameController,
                hintText: tr("first_name"),
              ),
              const SizedBox(height: 16),
              _buildGestureEditableField(
                controller: _lastNameController,
                hintText: tr("last_name"),
              ),
              const SizedBox(height: 16),
              _buildGestureEditableField(
                controller: _phoneController,
                hintText: tr("phone"),
              ),
              const SizedBox(height: 16),
              _buildGestureEditableField(
                controller: _addressController,
                hintText: tr("address"),
                onDoubleTap: _pickAddress,
              ),
              const SizedBox(height: 16),
              _buildGestureEditableField(
                controller: _birthDateController,
                hintText: tr("birth_date"),
                onDoubleTap: _pickBirthday,
              ),
            ],
          ),

          _buildDivider(),

          // 🔹 Переключатели
          _LocalSwitch(
            notifier: isKazakh,
            label:
            '${tr("change_language")}  ${isKazakh.value ? '🇰🇿' : '🇷🇺'}',
            onChanged: (newValue) {
              isKazakh.value = newValue;
              context.setLocale(Locale(newValue ? 'kk' : 'ru'));
              sharedPrefs.setString('language', newValue ? 'kk' : 'ru');
            },
          ),
          const SizedBox(height: 16),
          _LocalSwitch(
            notifier: isLight,
            label: isLight.value ? tr("light_theme") : tr("dark_theme"),
            onChanged: (newValue) {
              getIt<ThemeService>().setTheme(
                newValue ? ThemeMode.light : ThemeMode.dark,
              );
              sharedPrefs.setString('theme', newValue ? 'light' : 'dark');
            },
          ),

          _buildDivider(),

          // 🔹 История заказов
          Text(
            tr("order_history"),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (orders.isEmpty)
            Text(tr("no_orders"))
          else
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
                      subtitle: Text("${tr("date")}: ${order["date"]}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${order["price"]} ₸"),
                          Text('${order["status"].value}'.tr()),
                        ],
                      ),
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


class _LocalSwitch extends StatelessWidget {
  const _LocalSwitch({
    required this.notifier,
    required this.label,
    required this.onChanged,
  });

  final ValueNotifier<bool> notifier;
  final String label;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (context, value, _) {
              return InsetSwitch(
                label: label, // ✅ используем переданный label
                value: value,
                onChanged: (newValue) {
                  notifier.value = newValue;
                  onChanged(newValue); // ✅ вызываем переданный callback
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
