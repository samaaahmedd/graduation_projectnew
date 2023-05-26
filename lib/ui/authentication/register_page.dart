// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/drop_down_menu_single_select.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/authentication/register_use_case.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';
import 'package:with_you_app/ui/home_page/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterUseCase _registerUseCase = RegisterUseCase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _gender = 'Male';
  String _country = 'Egypt';
  final List<String> _countries = [
    'Egypt',
    'United Status',
    'Saudi Arabia',
    'Tunis',
    'Emirates',
    'Angola',
    'japan',
    'Spain',
    'Brazil',
    'China',
    'France',
    'Greece',
  ];

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
                        keyboardType: TextInputType.emailAddress,
                      ),
                      AppTextFormField(
                        controller: _emailController,
                        hint: "Email Address",
                      ),
                      AppTextFormField(
                        controller: _passwordController,
                        hint: "Password",
                        maxLength: 50,
                        obscureText: true,
                      ),
                      AppTextFormField(
                        controller: _phoneController,
                        hint: "Phone Number",
                        keyboardType: TextInputType.phone,
                      ),
                      AppTextFormField(
                        controller: _ageController,
                        hint: "Age",
                        keyboardType: TextInputType.number,
                      ),
                      SingleSelectDropDown(
                        onChanged: (selectedItem) {
                          _gender = selectedItem ?? '';
                          setState(() {});
                        },
                        itemsValues: const ['Male', 'Female'],
                        showItems: const ['Male', 'Female'],
                        hint: "Gender",
                        value: _gender,
                        selectedText: _gender,
                      ),
                      SingleSelectDropDown(
                        onChanged: (selectedItem) {
                          _country = selectedItem ?? '';
                          setState(() {});
                        },
                        itemsValues: _countries,
                        showItems: _countries,
                        hint: "Country",
                        value: _country,
                        selectedText: _country,
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
      _isLoading = true;
      setState(() {});
      UserRegisterEntity registerEntity = UserRegisterEntity(
        _nameController.text,
        _phoneController.text,
        _ageController.text,
        _emailController.text,
        _passwordController.text,
        _gender,
        _country,
      );
      final result = await _registerUseCase.execute(context, registerEntity);
      if (result) {
        navigateRemoveReplacement(context, const HomePage());
      }
      _isLoading = false;
      setState(() {});
    }
  }
}
