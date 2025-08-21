import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

class DishContainer extends StatefulWidget {
  const DishContainer({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.additions,
    required this.reductions,
  });

  final AssetImage image;
  final String name;
  final double price;
  final String description;
  final List<Map<String, double>> additions;
  final List<Map<String, double>> reductions;

  @override
  State<DishContainer> createState() => _DishContainerState();
}

class _DishContainerState extends State<DishContainer> {
  int quantity = 1;
  final Set<String> selectedAdditions = {};
  final Set<String> selectedReductions = {};

  double get totalPrice {
    final additionsPrice = widget.additions
        .where((map) => selectedAdditions.contains(map.keys.first))
        .fold<double>(0, (sum, map) => sum + map.values.first);

    final reductionsPrice = widget.reductions
        .where((map) => selectedReductions.contains(map.keys.first))
        .fold<double>(0, (sum, map) => sum + map.values.first);

    return widget.price * quantity + additionsPrice - reductionsPrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery
        .sizeOf(context)
        .width;

    return DefaultContainer(
      child: Column(
        children: [SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: widget.image),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text('От ${widget.price}₸',style: theme.textTheme.headlineSmall),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(widget.description, style: theme.textTheme.titleSmall),
              ),
              _buildGrid(
                theme,
                'Добавить вкуса',
                12,
                widget.additions,
                selectedAdditions,
                    (title) =>
                    setState(() {
                      if (selectedAdditions.contains(title)) {
                        selectedAdditions.remove(title);
                      } else {
                        selectedAdditions.add(title);
                      }
                    }),
              ),
              _buildGrid(
                theme,
                'Убрать лишнее',
                6,
                widget.reductions,
                selectedReductions,
                    (title) =>
                    setState(() {
                      if (selectedReductions.contains(title)) {
                        selectedReductions.remove(title);
                      } else {
                        selectedReductions.add(title);
                      }
                    }),
              ),
            ],
          ),
        ),
          SizedBox(
            width: screenWidth,
            child: _QuantityRow(
              quantity: quantity,
              onQuantityChanged: (newQuantity) =>
                  setState(() => quantity = newQuantity),
              total: totalPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
      ThemeData theme,
      String header,
      int max,
      List<Map<String, double>> arr,
      Set<String> selectedSet,
      void Function(String title) onTap,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text("Максимум: $max", style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: arr.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,       // по 2 в ряд
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3,     // ширина : высота
            ),
            itemBuilder: (context, index) {
              final String title = arr[index].keys.first;
              final double price = arr[index].values.first;
              final bool isSelected = selectedSet.contains(title);

              return GestureDetector(
                onTap: () => onTap(title),
                child: DefaultContainer(
                  // убираем height
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(50)
                      : Colors.white38,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text("+$price ₸", style: theme.textTheme.bodyLarge),
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

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    required this.total,
  });

  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // quantity контрол
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) onQuantityChanged(quantity - 1);
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              '$quantity',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            IconButton(
              onPressed: () {
                onQuantityChanged(quantity + 1);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        Align(
          alignment: Alignment.centerRight,
          child: PillButton(
            onPressed: () {
              // TODO: логика добавления в корзину
            },
            colorPrimary: Theme
                .of(context)
                .colorScheme
                .primary,
            colorOnPrimary: Theme
                .of(context)
                .colorScheme
                .onPrimary,
            child: Text("Добавить • ${total.toStringAsFixed(0)}₸"),
          ),
        ),
      ],
    );
  }
}
