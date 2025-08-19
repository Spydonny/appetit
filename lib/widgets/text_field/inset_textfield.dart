import 'package:flutter/material.dart';

class InsetTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const InsetTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<InsetTextField> createState() => _InsetTextFieldState();
}

class _InsetTextFieldState extends State<InsetTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF2C2C2C); // тёмный фон

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          // Светлая тень сверху-слева
          BoxShadow(
            offset: Offset(-3, -3),
            blurRadius: 6,
            color: Color(0xFF3A3A3A), // чуть светлее фона
          ),
          // Тёмная тень снизу-справа
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 6,
            color: Color(0xFF1A1A1A), // почти чёрный
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        keyboardType: widget.keyboardType,
        style: const TextStyle(color: Colors.white), // текст белым
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[400],
            ),
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}


