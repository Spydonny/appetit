import 'package:appetite_app/features/auth/view/pages/login_page.dart';
import 'package:appetite_app/features/auth/view/pages/pages.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/theme/app_icons.dart';
import '../widgets/auth_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AssetImage logoAppetite = AppIcons.logoAppetite;

  // Контроллеры
  final TextEditingController firstnameCtrl = TextEditingController();
  final TextEditingController lastnameCtrl = TextEditingController();
  final TextEditingController birthdayCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _pickBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdayCtrl.text = "${picked.day}.${picked.month}.${picked.year}";
      });
    }
  }
  void _submit() {
    // Здесь обработка регистрации
    debugPrint("Имя: ${firstnameCtrl.text}");
    debugPrint("Фамилия: ${lastnameCtrl.text}");
    debugPrint("Дата рождения: ${birthdayCtrl.text}");
    debugPrint("Адрес: ${addressCtrl.text}");
    debugPrint("Телефон: ${phoneCtrl.text}");
    debugPrint("Пароль: ${passwordCtrl.text}");
    debugPrint("Повтор пароля: ${confirmPasswordCtrl.text}");

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пароли не совпадают")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneAccPage(
          phone: phoneCtrl.text,
          firstname: firstnameCtrl.text,
          lastname: lastnameCtrl.text,
          birthday: birthdayCtrl.text,
          address: addressCtrl.text,
          password: passwordCtrl.text,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DefaultContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 350, // ограничиваем ширину контейнера
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // минимальная высота
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: logoAppetite, height: 50 ,),
                const SizedBox(height: 16),

                Text(
                  'Регистрация',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Индикатор шагов
                Text(
                  "Шаг ${_currentPage + 1} из 3",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 12),

                // PageView для шагов
                SizedBox(
                  height: 200, // фиксированная высота под поля
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // Шаг 1 - Личные данные
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InsetTextField(
                            controller: firstnameCtrl,
                            hintText: "Имя",
                          ),
                          const SizedBox(height: 8),
                          InsetTextField(
                            controller: lastnameCtrl,
                            hintText: "Фамилия",
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _pickBirthday,
                            child: AbsorbPointer(
                              child: InsetTextField(
                                controller: birthdayCtrl,
                                hintText: "День рождения",
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Шаг 2 - Контакты
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InsetTextField(
                            controller: addressCtrl,
                            hintText: "Адрес",
                          ),
                        ],
                      ),

                      // Шаг 3 - Безопасность
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InsetTextField(
                            controller: phoneCtrl,
                            hintText: "Телефон",
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 8),
                          InsetTextField(
                            controller: passwordCtrl,
                            hintText: "Пароль",
                            obscureText: true,
                          ),
                          const SizedBox(height: 8),
                          InsetTextField(
                            controller: confirmPasswordCtrl,
                            hintText: "Повторите пароль",
                            obscureText: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text('У вас уже есть аккаунт?',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                    ),
                    SizedBox()
                  ],
                ),

                const SizedBox(height: 16),

                // Кнопки навигации
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      AuthButton(
                        onPressed: _prevPage,
                        child: const Text("Назад"),
                      )
                    else
                      const SizedBox(width: 80), // пустое место

                    if (_currentPage < 2)
                      AuthButton(
                        onPressed: _nextPage,
                        child: const Text("Далее"),
                      )
                    else
                      AuthButton(
                        onPressed: _submit,
                        child: const Text("Подтвердить номер"),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

