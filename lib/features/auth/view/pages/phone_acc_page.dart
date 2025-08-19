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

  const PhoneAccPage({
    super.key,
    required this.phone,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.address,
    required this.password,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
            minWidth: 280,
          ),
          child: DefaultContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min, // 👈 это главное
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
                const SizedBox(height: 16),
                AuthButton(
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
