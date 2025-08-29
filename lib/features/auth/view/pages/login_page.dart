import 'package:appetite_app/features/auth/services/auth_service.dart';
import 'package:appetite_app/features/auth/view/pages/signup_page.dart';
import 'package:appetite_app/features/main/view/pages_screens/main_page.dart';
import 'package:appetite_app/features/shared/services/analytics_service.dart';
import 'package:appetite_app/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/core.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logoAppetite = AppIcons.logoAppetite;

  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void _login() async {
    final phone = phoneCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Введите телефон и пароль")),
      );
      return;
    }

    getIt<AnalyticsService>().logLogin(timestamp: DateTime.now());
    try {
      await getIt<AuthService>().login(emailOrPhone: phone, password: password);
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка входа: $e")),
      );
      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            ChangeLanguageRow(),
          ],
        ),
      ),
      body: Center(
        child: DefaultContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: logoAppetite, height: 50),
                const SizedBox(height: 16),

                Text("login".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                InsetTextField(
                  controller: phoneCtrl,
                  hintText: "phone".tr(),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                InsetTextField(
                  controller: passwordCtrl,
                  hintText: "password".tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Text(
                      "register".tr(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                AuthButton(
                  onPressed: _login,
                  child: Text("login".tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
