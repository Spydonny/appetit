import 'package:appetite_app/features/shared/services/analytics_service.dart';
import 'package:appetite_app/features/shared/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../logic/bloc/cart_bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  bool get isCafeClosed {
    final nowHour = DateTime.now().hour;
    return nowHour > 2 && nowHour < 7;
  }

  void _openMap(BuildContext context) {
    getIt<AppService>().openMap(context, TextEditingController());
  }

  void _takeOrder(BuildContext context, CartState state) {
    if (isCafeClosed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('cafe_closed'.tr()),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    getIt<AnalyticsService>().logPurchase(
      orderId: '',
      totalPrice: state.total,
      items: state.items,
    );

    try {
      context.read<CartBloc>().add(CartOrderSubmitted());
    }catch(e){
      debugPrint(e.toString());
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('order_done'.tr()),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
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
                      title: tr("receiving_method"),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _buildDeliverySwitch(context, state),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              if (!state.isDelivery) {
                                _choosePickupAddress(context);
                              } else {
                                _openMap(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      !state.isDelivery
                                          ? (state.pickupAddress ??
                                          tr("choose_pickup_address"))
                                          : (state.deliveryAddress ??
                                          tr("enter_delivery_address")),
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
                      title: tr("cart"),
                      child: Column(
                        children: state.items.asMap().entries.map((entry) {
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["title"],
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item["description"],
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
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
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        onPressed: () {
                                          if (item["quantity"] > 1) {
                                            context.read<CartBloc>().add(
                                              CartItemQuantityChanged(
                                                index: i,
                                                quantity:
                                                (item["quantity"] - 1),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      Text(
                                        "${item["quantity"]}",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                            CartItemQuantityChanged(
                                              index: i,
                                              quantity:
                                              (item["quantity"] + 1),
                                            ),
                                          );
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
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.redAccent),
                                        onPressed: () => context
                                            .read<CartBloc>()
                                            .add(CartItemRemoved(i)),
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
                      title: tr("discounts"),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          InsetTextField(
                            hintText: tr("promo"),
                            onSubmitted: (v) => context
                                .read<CartBloc>()
                                .add(CartPromoApplied(v)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: InsetSwitch(
                                  value: state.useBonuses,
                                  onChanged: (v) => context
                                      .read<CartBloc>()
                                      .add(CartUseBonusesChanged(v)),
                                  label: tr("use_bonus"),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Способ оплаты ---
                    SectionContainer(
                      title: tr("payment_method"),
                      child: InsetDropdown<String>(
                        hintText: tr("select_payment"),
                        value: state.payment,
                        items: [
                          DropdownMenuItem(
                            value: "Kaspi",
                            child: Text(tr("pay_kaspi")),
                          ),
                          DropdownMenuItem(
                            value: "Cash",
                            child: Text(tr("pay_cash")),
                          ),
                        ],
                        onChanged: (value) => context
                            .read<CartBloc>()
                            .add(CartPaymentChanged(value!)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Комментарии ---
                    SectionContainer(
                      title: tr("comment_order"),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InsetTextField(
                          hintText: tr("comment"),
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Детали заказа ---
                    SectionContainer(
                      title: tr("order_details"),
                      child: Column(
                        children: [
                          _priceRow(tr("products"),
                              "${state.productsTotal.toInt()} ₸", context),
                          _priceRow(tr("delivery"),
                              "${state.deliveryPrice.toInt()} ₸", context),
                          _priceRow(
                              state.useBonuses
                                  ? tr("use_bonus")
                                  : tr("bonuses"),
                              "${state.bonusValue.toInt()} ₸",
                              context),
                          const Divider(),
                          _priceRow(tr("total"), "${state.total.toInt()} ₸",
                              context,
                              isTotal: true),
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
                  onPressed: () => _takeOrder(context, state),
                  child: Text(
                    tr("order"),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _priceRow(String label, String value, BuildContext context,
      {bool isTotal = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
            isTotal ? theme.textTheme.titleLarge : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style:
            isTotal ? theme.textTheme.titleLarge : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySwitch(BuildContext context, CartState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DeliveryChoiceChip(
            label: tr("pickup"),
            selected: !state.isDelivery,
            onSelected: () => context
                .read<CartBloc>()
                .add(const CartDeliveryChanged(false)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DeliveryChoiceChip(
            label: tr("delivery"),
            selected: state.isDelivery,
            onSelected: () => context
                .read<CartBloc>()
                .add(const CartDeliveryChanged(true)),
          ),
        ),
      ],
    );
  }

  Future<void> _choosePickupAddress(BuildContext context) async {
    final pickupAddresses = [
      "Казахстан, 70А",
      "Сатпаева, 8А",
      "Новаторов, 18/2",
      "Жибек Жолы, 1к8",
      "Самарское шоссе, 5/1",
      "Кабанбай батыра, 148",
      "Назарбаева, 28А",
    ];

    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(tr("choose_pickup_address")),
        children: pickupAddresses
            .map(
              (addr) => SimpleDialogOption(
            onPressed: () => Navigator.pop(context, addr),
            child: Text(addr),
          ),
        )
            .toList(),
      ),
    );
    if (result != null) {
      context.read<CartBloc>().add(CartPickupAddressSelected(result));
    }
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white12,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: (selected ? FontWeight.w500 : FontWeight.w300),
              color: (selected ? Colors.white : Colors.black)
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


