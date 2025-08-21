import 'package:appetite_app/widgets/drop_down_buttons/drop_down_buttons.dart';
import 'package:appetite_app/widgets/switches/inset_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_combo_box/flutter_combo_box.dart';
import '../../../../widgets/widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? payment;

  bool isDelivery = false;
  String? selectedPickupAddress;
  bool useBonuses = false;
  final TextEditingController promoController = TextEditingController();

  List<Map<String, dynamic>> cartItems = [
    {
      "title": "Маргарита",
      "description": "30 см, классика",
      "price": 2000,
      "quantity": 1,
    },
    {
      "title": "Пепперони",
      "description": "35 см, острое",
      "price": 2500,
      "quantity": 1,
    },
    {
      "title": "Филадельфия",
      "description": "8 шт",
      "price": 3000,
      "quantity": 1,
    },
  ];

  late Future<List<dynamic>> datas;

  Future<List<String>> _loadGenders() async {
    await Future.delayed(Duration(seconds: 1)); // имитация загрузки
    return ['Оплата Kaspi.kz', 'Оплата наличными'];
  }

  final List<String> pickupAddresses = [
    "ул. Абая 10",
    "пр. Назарбаева 50",
    "ул. Пушкина 7",
  ];

  static const deliveryAddress = "ул. Сатпаева 25";

  void _choosePickupAddress() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) =>
          SimpleDialog(
            title: const Text("Выберите адрес самовывоза"),
            children: pickupAddresses
                .map(
                  (addr) =>
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, addr),
                    child: Text(addr),
                  ),
            )
                .toList(),
          ),
    );
    if (result != null) {
      setState(() => selectedPickupAddress = result);
    }
  }

  void _removeItem(int index) {
    setState(() => cartItems.removeAt(index));
  }

  @override
  void initState() {
    datas = _loadGenders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final productsTotal =
    cartItems.fold<int>(0, (sum, item) => sum + item["price"] as int);
    final deliveryPrice = !isDelivery ? 0 : 500;
    final bonusValue = useBonuses ? 300 : 0;
    final total = productsTotal + deliveryPrice - bonusValue;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Способ получения ---
                SectionContainer(
                  title: "Способ получения",
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      _buildDeliverySwitch(),
                      SizedBox(height: 8),
                      InkWell(

                        onTap: () =>
                        !isDelivery ? _choosePickupAddress() : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  !isDelivery
                                      ? (selectedPickupAddress ??
                                      "Выберите адрес самовывоза")
                                      : deliveryAddress,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- Ваш заказ ---
                SectionContainer(
                  title: "Ваш заказ",
                  child: Column(
                    children: cartItems.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Название + описание
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["title"],
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item["description"],
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Счетчик количества
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        if (item["quantity"] > 1) item["quantity"]--;
                                      });
                                    },
                                  ),
                                  Text(
                                    "${item["quantity"]}",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        item["quantity"]++;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(width: 12),

                              // Цена + удалить
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${item["price"] * item["quantity"]} ₸",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent),
                                    onPressed: () => _removeItem(i),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Скидки ---
                SectionContainer(
                  title: "Скидки",
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      InsetTextField(
                        controller: promoController,
                        hintText: "Промокод",
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: InsetSwitch(
                            value: useBonuses,
                            onChanged: (v) =>
                                setState(() => useBonuses = v), label: 'Использовать бонусы',
                          ),)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- Способ оплаты ---
                SectionContainer(
                  title: 'Способ оплаты',
                  child: InsetDropdown<String>(
                    hintText: "Выберите способ оплаты",
                    value: payment, // текущее выбранное значение
                    items: const [
                      DropdownMenuItem(
                        value: "Kaspi",
                        child: Text("Оплата Kaspi.kz"),
                      ),
                      DropdownMenuItem(
                        value: "Cash",
                        child: Text("Оплата наличными"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        payment = value;
                      });
                      debugPrint("Выбрано: $value");
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // --- Коментарий ---
                SectionContainer(
                    title: 'Коментарии к заказу',
                    child: Padding(padding: EdgeInsets.symmetric(vertical: 8),
                      child: InsetTextField(
                        hintText: 'Коментарии',
                        minLines: 1,
                        maxLines: 3,
                      ),
                    )
                ),
                const SizedBox(height: 16),

                // --- Детали заказа ---
                SectionContainer(
                  title: "Детали заказа",
                  child: Column(
                    children: [
                      _priceRow("Товары", "$productsTotal ₸"),
                      _priceRow("Доставка", "$deliveryPrice ₸"),
                      _priceRow(
                        useBonuses
                            ? "Использовано бонусов"
                            : "Начислится бонусов",
                        "$bonusValue ₸",
                      ),
                      const Divider(),
                      _priceRow("Итого", "$total ₸", isTotal: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Кнопка заказа ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: PillButton(
              colorPrimary: theme.colorScheme.primary,
              colorOnPrimary: theme.colorScheme.onPrimary,
              onPressed: () {},
              child: Text(
                'Заказать',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleLarge
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleLarge
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DeliveryChoiceChip(
            label: "Самовывоз",
            selected: !isDelivery,
            onSelected: () => setState(() => isDelivery = false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DeliveryChoiceChip(
            label: "Доставка",
            selected: isDelivery,
            onSelected: () => setState(() => isDelivery = true),
          ),
        ),
      ],
    );
  }

}

class DeliveryChoiceChip extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onSelected;

  const DeliveryChoiceChip({
    super.key,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
            ),
          ),
        )
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultContainer(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}


