import 'package:appetite_app/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/theme/app_icons.dart';
import '../../view/widgets/auth_button.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logoAppetite = AppIcons.logoAppetite;

  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  void _login() {
    debugPrint("Телефон: ${phoneCtrl.text}");
    debugPrint("Пароль: ${passwordCtrl.text}");
    // Здесь логика авторизации
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    passwordCtrl.dispose();
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
              children: [
                Image(image: logoAppetite, height: 50),
                const SizedBox(height: 16),
                const Text(
                  "Вход",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                InsetTextField(
                  controller: phoneCtrl,
                  hintText: "Телефон",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                InsetTextField(
                  controller: passwordCtrl,
                  hintText: "Пароль",
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      ),
                      child: Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
                const SizedBox(height: 20),
                AuthButton(
                  onPressed: _login,
                  child: const Text("Войти"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}