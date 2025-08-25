import 'package:flutter/material.dart';

class InsetDropdown<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const InsetDropdown({
    super.key,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-2, -2),
            blurRadius: 4,
            color: scheme.brightness == Brightness.light
                ? Colors.white
                : Colors.black.withOpacity(0.4),
          ),
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 6,
            color: scheme.shadow.withOpacity(0.3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText ?? "",
            style: TextStyle(color: scheme.onSurface.withOpacity(0.5)),
          ),
          dropdownColor: scheme.surface,
          icon: Icon(Icons.arrow_drop_down, color: scheme.onSurface.withOpacity(0.6)),
          isExpanded: true,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 16,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
