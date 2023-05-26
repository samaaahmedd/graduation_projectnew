import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/splash/splash_page.dart';


class TheApp extends StatelessWidget {
  const TheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashPage());
  }
}
