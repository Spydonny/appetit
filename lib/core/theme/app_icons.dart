import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._(); // приватный конструктор, чтобы нельзя было создать экземпляр

  static const String _basePath = 'assets/images';

  static const String logoAppetitePath = '$_basePath/logo_appetite.png';
  static const String logoAppetiteRoundPath = '$_basePath/logo_appetit_round.png';

  static const AssetImage logoAppetite = AssetImage(logoAppetitePath);
  static const AssetImage logoAppetiteRound = AssetImage(logoAppetiteRoundPath);
}