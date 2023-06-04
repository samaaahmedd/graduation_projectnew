import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:with_you_app/ui/authentication/complete_register_page.dart';

import 'ui/splash/splash_page.dart';

class TheApp extends StatelessWidget {
  const TheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        theme: ThemeData(fontFamily: "Roboto"),
        debugShowCheckedModeBanner: false,
        home: const CompleteRegisterPage(
            email: 'email', name: 'name', password: 'password'));
  }
}
