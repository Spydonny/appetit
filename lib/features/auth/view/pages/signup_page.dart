import 'dart:async';

import 'package:appetite_app/features/auth/view/pages/pages.dart';
import 'package:appetite_app/features/shared/services/app_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/core.dart';
import '../widgets/widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final logoAppetite = AppIcons.logoAppetite;

  final _pageController = PageController();
  int _currentPage = 0;

  final firstnameCtrl = TextEditingController();
  final lastnameCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  void _nextPage() {
    // проверка в зависимости от шага
    if (_currentPage == 0) {
      if (firstnameCtrl.text.trim().isEmpty ||
          lastnameCtrl.text.trim().isEmpty ||
          birthdayCtrl.text.trim().isEmpty) {
        _showError("Заполните все поля");
        return;
      }
    } else if (_currentPage == 1) {
      if (addressCtrl.text.trim().isEmpty) {
        _showError("Введите адрес");
        return;
      }
    }
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _submit() {
    if (phoneCtrl.text.trim().isEmpty ||
        passwordCtrl.text.trim().isEmpty ||
        confirmPasswordCtrl.text.trim().isEmpty) {
      _showError("Заполните все поля");
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      _showError("passwords_do_not_match".tr());
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneAccPage(
          phone: phoneCtrl.text.trim(),
          firstname: firstnameCtrl.text.trim(),
          lastname: lastnameCtrl.text.trim(),
          birthday: birthdayCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickBirthday() async {
    getIt<AppService>().openDatePicker(context, birthdayCtrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            ChangeLanguageRow()
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

                Text("signup".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),

                Text(
                  "step".tr(namedArgs: {
                    "current": "${_currentPage + 1}",
                    "total": "3"
                  }),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 200,
                  child: _buildPageView(),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Text('already_have_account'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _buildNavigationRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentPage > 0)
          AuthButton(onPressed: _prevPage, child: Text("back".tr()))
        else
          const SizedBox(width: 80),

        if (_currentPage < 2)
          AuthButton(onPressed: _nextPage, child: Text("next".tr()))
        else
          AuthButton(
            width: 195,
            onPressed: _submit,
            child: Text("confirm_phone".tr()),
          ),
      ],
    );
  }

  PageView _buildPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() => _currentPage = index);
      },
      children: [
        _StepOne(
          firstnameCtrl: firstnameCtrl,
          lastnameCtrl: lastnameCtrl,
          birthdayCtrl: birthdayCtrl,
          pickBirthday: _pickBirthday,
        ),
        _StepTwo(addressCtrl: addressCtrl),
        _StepThree(
          phoneCtrl: phoneCtrl,
          passwordCtrl: passwordCtrl,
          confirmPasswordCtrl: confirmPasswordCtrl,
        ),
      ],
    );
  }
}

// === Шаги формы ===

class _StepOne extends StatelessWidget {
  final TextEditingController firstnameCtrl;
  final TextEditingController lastnameCtrl;
  final TextEditingController birthdayCtrl;
  final Future<void> Function() pickBirthday;

  const _StepOne({
    required this.firstnameCtrl,
    required this.lastnameCtrl,
    required this.birthdayCtrl,
    required this.pickBirthday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InsetTextField(controller: firstnameCtrl, hintText: "firstname".tr()),
        const SizedBox(height: 8),
        InsetTextField(controller: lastnameCtrl, hintText: "lastname".tr()),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickBirthday,
          child: AbsorbPointer(
            child:
            InsetTextField(controller: birthdayCtrl, hintText: "birthday".tr()),
          ),
        ),
      ],
    );
  }
}

class _StepTwo extends StatelessWidget {
  final TextEditingController addressCtrl;

  const _StepTwo({required this.addressCtrl});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InsetTextField(controller: addressCtrl, hintText: "address".tr()),
        Expanded(
            child: Padding(padding: EdgeInsets.all(8),
              child: GestureDetector(
                onDoubleTap: () => getIt<AppService>().openMap(context, addressCtrl),
                child: DefaultMap(
                  addressController: addressCtrl,
                ),
              ),
            )
        )
      ],
    );
  }
}

class _StepThree extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmPasswordCtrl;

  const _StepThree({
    required this.phoneCtrl,
    required this.passwordCtrl,
    required this.confirmPasswordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        const SizedBox(height: 8),
        InsetTextField(
          controller: confirmPasswordCtrl,
          hintText: "confirm_password".tr(),
          obscureText: true,
        ),
      ],
    );
  }
}
