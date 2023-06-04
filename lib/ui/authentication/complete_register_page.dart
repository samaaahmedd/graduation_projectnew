// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/common/material/languages_drop_down.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/drop_down_menu_single_select.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/use_cases/user/set_user_data_use_case.dart';
import 'package:with_you_app/ui/host_page.dart';
import 'package:with_you_app/ui/more_page/profile_page/set_profile_image.dart';

class CompleteRegisterPage extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  const CompleteRegisterPage({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
  }) : super(key: key);

  @override
  State<CompleteRegisterPage> createState() => _CompleteRegisterPageState();
}

class _CompleteRegisterPageState extends State<CompleteRegisterPage> {
  final SetUserDataUseCase _setUserDataUseCase = SetUserDataUseCase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  String? _gender;
  List<String> _languages = [];
  String? _country;
  String? _countryOfResidence;

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
              'Just One Step\nComplete Your Profile',
              style: TextStyles.bold(
                  fontSize: 28, color: AppColors.neutral_700, height: 1.5),
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
                        controller: _phoneController,
                        hint: "Phone Number",
                        maxLength: 11,
                        keyboardType: TextInputType.phone,
                      ),
                      AppTextFormField(
                        controller: _ageController,
                        hint: "Age",
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                      ),
                      AppTextFormField(
                        controller: _experienceController,
                        hint: "Experience",
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                      ),
                      LanguagesDropDown(
                        onchange: (languages) {
                          _languages = languages;
                        },
                      ),
                      SingleSelectDropDown<String?>(
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
                      SingleSelectDropDown<String?>(
                        onChanged: (selectedItem) {
                          _country = selectedItem ?? '';
                          setState(() {});
                        },
                        itemsValues: countries,
                        showItems: countries,
                        hint: "Country",
                        value: _country,
                        selectedText: _country,
                      ),
                      SingleSelectDropDown<String?>(
                        onChanged: (selectedItem) {
                          _countryOfResidence = selectedItem ?? '';
                          setState(() {});
                        },
                        itemsValues: countries,
                        showItems: countries,
                        hint: "Country Of Residence",
                        value: _countryOfResidence,
                        selectedText: _countryOfResidence,
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
      if (_gender == null ||
          _country == null ||
          _countryOfResidence == null ||
          _languages.isEmpty) {
        AppSnackBars.hint(context,
            title:
                'Please Make Sure That , Gender Or Country Or Country Of Residence Or Languages arent empty');
      } else {
        UserEntity registerEntity = UserEntity(
          name: widget.name,
          phoneNumber: _phoneController.text,
          age: _ageController.text,
          emailAddress: widget.email,
          password: widget.password,
          gender: _gender!,
          country: _country!,
        );
        final result =
            await _setUserDataUseCase.execute(context, registerEntity);
        if (result) {
          navigateRemoveReplacement(
              context,
              const SetUserProfileImagePage(
                canPop: false,
              ));
        }
      }

      _isLoading = false;
      setState(() {});
    }
  }
}
