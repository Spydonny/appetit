import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../widgets/widgets.dart';

class PhoneAccPage extends StatefulWidget {
  final String phone;
  final String firstname;
  final String lastname;
  final String birthday;
  final String address;
  final String password;
  final VoidCallback onResend; // колбэк для пересылки кода

  const PhoneAccPage({
    super.key,
    required this.phone,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.address,
    required this.password,
    required this.onResend,
  });

  @override
  State<PhoneAccPage> createState() => _PhoneAccPageState();
}

class _PhoneAccPageState extends State<PhoneAccPage> {
  final TextEditingController codeCtrl = TextEditingController();

  void _verify() {
    debugPrint("Код: ${codeCtrl.text}");
    debugPrint("Имя: ${widget.firstname}");
    debugPrint("Фамилия: ${widget.lastname}");
    debugPrint("Дата рождения: ${widget.birthday}");
    debugPrint("Адрес: ${widget.address}");
    debugPrint("Телефон: ${widget.phone}");
    debugPrint("Пароль: ${widget.password}");
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DefaultContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Подтверждение телефона",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                InsetTextField(
                  controller: codeCtrl,
                  hintText: "Введите код из SMS",
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pop(context),
                    child: Text(
                      "Перепроверить номер",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                AuthButton(
                  width: 120,
                  onPressed: _verify,
                  child: const Text("Подтвердить"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

