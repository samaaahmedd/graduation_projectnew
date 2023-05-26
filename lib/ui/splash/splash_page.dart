import 'dart:async';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/ui/log_in_page/log_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // final GetLogInStatus _getLogInStatus = GetLogInStatus();
  bool isLogIn = false;

  @override
  void initState() {
    _checkIfLogIn();
    Timer(const Duration(seconds: 3), () => _navigateToHomePage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3843d9),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradiantColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),        ),
        child: Image.asset(
          ImagesPaths.logo,
          scale: 1.2,
          isAntiAlias: true,
        ),
      ),
    );
  }

  void _navigateToHomePage() {
      navigateReplacement(context, const LogInPage());
    if (isLogIn) {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => const HostPage(),
      // ));
    } else {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => const  WelcomePage(),
      // ));
    }
  }

  Future<void> _checkIfLogIn() async {
    // isLogIn = await _getLogInStatus();
  }
}
