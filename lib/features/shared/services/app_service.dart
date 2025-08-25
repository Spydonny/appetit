import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';

class AppService {
  AppService();

  Future<void> openDatePicker(BuildContext context, TextEditingController dateCtrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      dateCtrl.text = DateFormat('dd.MM.yyyy').format(picked);
    }
  }

  void openMap(BuildContext context, TextEditingController addressCtrl) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            Scaffold(appBar: AppBar(),
              body: DefaultContainer(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: DefaultMap(
                    addressController: addressCtrl,
                    selectable: true,
                  )
              ),
            )
        )
    );
  }

}