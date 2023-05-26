// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/domain/use_cases/authentication/update_password_use_case.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final UpdatePasswordUseCase _updatePasswordUseCase = UpdatePasswordUseCase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultAppBar(context, title: 'Update Password'),
      backgroundColor: AppColors.appBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .05),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              10,
            ),
            elevation: .5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: _confirmPasswordController,
                      hint: "New Password",
                      maxLength: 50,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextFormField(
                      controller: _passwordController,
                      hint: "Confirm Password",
                      maxLength: 50,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    AppButtons.primaryButton(
                        text: "Update Pasword",
                        onPressed: _onUpdate,
                        isLoading: _isLoading),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdate() async {
    _isLoading = true;
    setState(() {});
    if (_formKey.currentState?.validate() ?? false) {
      final result = await _updatePasswordUseCase.execute(context,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text);
      if (result) {
        pop(context);
      }
    }
    _isLoading = false;
    setState(() {});
  }
}
