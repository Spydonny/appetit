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

  final ValueNotifier<bool> isKazakh = ValueNotifier<bool>(false);

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
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _birthDateController.text = DateFormat('dd.MM.yyyy').format(picked);
    }
  }

  final Set<TextEditingController> _editableControllers = {};

  final Map<TextEditingController, FocusNode> _focusNodes = {};

  FocusNode _focusOf(TextEditingController c) =>
      _focusNodes.putIfAbsent(c, () => FocusNode());

  Widget _buildGestureEditableField({
    required TextEditingController controller,
    required String hintText,
    VoidCallback? onBoubleTap, // как просили, именно так назвать
  }) {
    final focusNode = _focusOf(controller);
    final enabled = _editableControllers.contains(controller);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        if (onBoubleTap != null) {
          onBoubleTap();
          return;
        }
        if (!enabled) {
          setState(() {
            _editableControllers.add(controller);
          });
          // после включения — сфокусировать и поставить курсор в конец
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
        onFocusChange: (hasFocus) {
          if (!hasFocus && _editableControllers.contains(controller)) {
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
                onBoubleTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        Scaffold(appBar: AppBar(),
                          body: DefaultContainer(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                              child: DefaultMap(
                                addressController: _addressController,
                                selectable: true,
                              )
                          ),
                        )
                    )
                )
              ),
              const SizedBox(height: 16),

              _buildGestureEditableField(
                controller: _birthDateController,
                hintText: tr("birth_date"),
                onBoubleTap: _pickBirthday
              ),
            ],
          ),


          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),

          // Переключатель языка
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: isKazakh,
                  builder: (context, value, _) {
                    return InsetSwitch(
                      label: '${tr("change_language")}  ${value ? '🇰🇿' : '🇷🇺'}',
                      value: value,
                      onChanged: (newValue) {
                        isKazakh.value = newValue;
                        context.setLocale(Locale(newValue ? 'kk' : 'ru'));
                      },
                    );
                  },
                )
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
