import 'package:flutter/material.dart';

class InsetTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onSubmitted; // ✅ новый колбэк

  const InsetTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled,
    this.minLines,
    this.maxLines,
    this.onSubmitted,
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
    const backgroundColor = Color(0xFF2C2C2C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-3, -3),
            blurRadius: 6,
            color: Color(0xFF3A3A3A),
          ),
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 6,
            color: Color(0xFF1A1A1A),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        enabled: widget.enabled,
        minLines: widget.obscureText ? 1 : widget.minLines,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        keyboardType: (widget.maxLines == null || (widget.maxLines ?? 1) > 1)
            ? TextInputType.multiline   // ✅ многострочный
            : widget.keyboardType,      // ✅ дефолтный
        textInputAction: (widget.maxLines == null || (widget.maxLines ?? 1) > 1)
            ? TextInputAction.newline   // ✅ Enter = перенос строки
            : TextInputAction.done,     // ✅ Enter = submit
        onSubmitted: (value) {
          if ((widget.maxLines ?? 1) == 1 && widget.onSubmitted != null) {
            widget.onSubmitted!(value);
          }
        },
        style: const TextStyle(color: Colors.white),
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
      )
      ,
    );
  }
}


