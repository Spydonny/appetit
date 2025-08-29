import 'dart:async';
import 'package:appetite_app/features/auth/services/auth_service.dart';
import 'package:appetite_app/features/main/view/pages_screens/main_page.dart';
import 'package:appetite_app/features/shared/services/analytics_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/core.dart';
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
  final logoAppetite = AppIcons.logoAppetite;
  final codeCtrl = TextEditingController();
  final _service = getIt<AuthService>();

  Timer? _timer;
  int _cooldown = 0;

  void _signup() async {
    try {
       await getIt<AuthService>().register(
          fullName: "${widget.firstname} ${widget.lastname}",
          dob: widget.birthday,
          password: widget.password,
         address: widget.address
      );
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
    getIt<AnalyticsService>().logSignUp(timestamp: DateTime.now());
  }

  void _confirm(BuildContext context) async {
    try {
      final m = await _service.verifyPhoneCode(phone: widget.phone, code: codeCtrl.text.trim());
      debugPrint(m);
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('incorrect_code'.tr())));
      return;
    }
    _signup();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));

  }

  void _resend() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("code_resent".tr())),
    );

    await _service.startPhoneVerification(widget.phone);

    setState(() {
      _cooldown = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _cooldown--;
        });
      }
    });
  }

  @override
  void initState() {
    _service.startPhoneVerification(widget.phone);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
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
              children: [
                Image(image: logoAppetite, height: 50),
                const SizedBox(height: 16),

                Text("confirm_phone".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                Text(
                  "enter_sms_code".tr(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                InsetTextField(
                  controller: codeCtrl,
                  hintText: "enter_code".tr(),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "recheck_number".tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    _cooldown > 0
                        ? Text(
                      "${"resend_code_in".tr()} $_cooldown c",
                      style: const TextStyle(fontSize: 14),
                    )
                        : TextButton(
                      onPressed: _resend,
                      child: Text("resend_code".tr(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                AuthButton(
                  width: 120,
                  onPressed: () => _confirm(context),
                    child: Text("confirm".tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
