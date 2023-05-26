// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/authentication/user_auth_state.dart';
import 'package:with_you_app/domain/use_cases/authentication/log_in_use_case.dart';
import 'package:with_you_app/ui/authentication/register_page.dart';
import 'package:with_you_app/ui/host_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final LogInUseCase _logInUseCase = LogInUseCase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Welcome back!\nGlad to see you again!',
                style: TextStyles.bold(
                    fontSize: 30, color: AppColors.neutral_700, height: 1.5),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
              elevation: .5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: _emailController,
                        hint: "Email Address",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextFormField(
                        controller: _passwordController,
                        hint: "Password",
                        maxLength: 50,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      AppButtons.primaryButton(
                          text: "Log In",
                          onPressed: _onLogIn,
                          isLoading: _isLoading),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't Have an Account?"),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    navigate(context, const RegisterPage());
                  },
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onLogIn() async {
    if (_formKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});
      final result = await _logInUseCase.execute(context,
          email: _emailController.text, password: _passwordController.text);
      switch (result) {
        case UserAuthStateEnum.isVerified:
        case UserAuthStateEnum.unVerified:
          navigateRemoveReplacement(context, const HostPage());
          break;
          // navigate(context, const EmailVerificationPage());
          // break;
          case UserAuthStateEnum.unAuthenticated:
          break;
      }
      _isLoading = false;
      setState(() {});
    }
  }
}
