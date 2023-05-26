import 'dart:async';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/domain/use_cases/authentication/check_if_user_login_use_case.dart';
import 'package:with_you_app/ui/authentication/log_in_page.dart';
import 'package:with_you_app/ui/host_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final CheckIfUserLogInUseCase _ifUserLogInUseCase = CheckIfUserLogInUseCase();

  @override
  void initState() {
    Timer(const Duration(seconds: 4), () => _navigateTo());
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
          ),
        ),
        child: Image.asset(
          ImagesPaths.logo,
          scale: 1.2,
          isAntiAlias: true,
        ),
      ),
    );
  }

  void _navigateTo() {
    final isLogIn = _ifUserLogInUseCase.execute();
    if (isLogIn) {
      navigateRemoveReplacement(context, const HostPage());
    } else {
      navigateRemoveReplacement(context, const LogInPage());
    }
  }

}
