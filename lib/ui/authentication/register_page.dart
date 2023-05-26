import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/ui/home_page/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                        controller: _phoneController,
                        hint: "Phone Number",
                        keyboardType: TextInputType.phone,
                      ),
                      AppTextFormField(
                        controller: _ageController,
                        hint: "Age",
                        keyboardType: TextInputType.number,
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
                      const SizedBox(
                        height: 25,
                      ),
                      AppButtons.primaryButton(
                        text: "Log In",
                        onPressed: _onLogIn,
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
            )
          ],
        ),
      ),
    );
  }

  void _onLogIn() async {
    if (_formKey.currentState!.validate()) {
      navigateRemoveReplacement(context, const HomePage());
    }
  }

}
