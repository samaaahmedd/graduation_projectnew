// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/drop_down_menu_single_select.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/use_cases/authentication/register_use_case.dart';
import 'package:with_you_app/ui/authentication/complete_register_page.dart';
import 'package:with_you_app/ui/host_page.dart';
import 'package:with_you_app/ui/more_page/profile_page/set_profile_image.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterUseCase _registerUseCase = RegisterUseCase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _userType;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.leadingAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s Join us\nAnd Discover The World!',
              style: TextStyles.bold(
                  fontSize: 28, color: AppColors.neutral_700, height: 1.4),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
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
                        controller: _nameController,
                        hint: "Name",
                      ),
                      AppTextFormField(
                        controller: _emailController,
                        hint: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      AppTextFormField(
                        controller: _passwordController,
                        hint: "Password",
                        maxLength: 25,
                        obscureText: true,
                      ),
                      SingleSelectDropDown<String?>(
                        onChanged: (selectedItem) {
                          _userType = selectedItem ?? '';
                          setState(() {});
                        },
                        itemsValues: const [
                          'Tourist',
                          'Tour Guide',
                          'Photographer'
                        ],
                        showItems: const [
                          'Tourist',
                          'Tour Guide',
                          'Photographer'
                        ],
                        hint: "User Type",
                        value: _userType,
                        selectedText: _userType,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      AppButtons.primaryButton(
                        text: "Register",
                        onPressed: _onRegister,
                        isLoading: _isLoading,
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
                const Text("Already Have an Account?"),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => pop(context),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_userType != null) {
        _isLoading = true;
        setState(() {});
        final result = await _registerUseCase.execute(context,
            password: _passwordController.text, email: _emailController.text);
        if (result) {
          navigateRemoveReplacement(
              context,
              CompleteRegisterPage(
                userType: _userType ?? '',
                email: _emailController.text,
                name: _nameController.text,
                password: _passwordController.text,
              ));
        }
        _isLoading = false;
        setState(() {});
      } else {
        AppSnackBars.hint(context, title: 'Please , Select User Type First');
      }
    }
  }
}
