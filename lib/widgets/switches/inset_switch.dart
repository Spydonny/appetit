import 'package:flutter/material.dart';

class InsetSwitch extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const InsetSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<InsetSwitch> createState() => _InsetSwitchState();
}

class _InsetSwitchState extends State<InsetSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = scheme.brightness == Brightness.dark;

    final bool isOn = _value;

    return InkWell(
      onTap: () {
        setState(() => _value = !_value);
        widget.onChanged(_value);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: scheme.surface,
          boxShadow: [
            BoxShadow(
              offset: const Offset(-2, -2),
              blurRadius: 4,
              color: isDark ? Colors.black45 : Colors.white,
            ),
            BoxShadow(
              offset: const Offset(2, 2),
              blurRadius: 6,
              color: scheme.shadow.withAlpha(76),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label,
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface)),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isOn
                    ? scheme.primary
                    : (isDark ? Colors.black : Colors.black12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isOn ? scheme.onPrimary : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
