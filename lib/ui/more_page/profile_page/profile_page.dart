// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/divider.dart';
import 'package:with_you_app/common/material/drop_down_menu_single_select.dart';
import 'package:with_you_app/common/material/languages_drop_down.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/use_cases/user/set_user_data_use_case.dart';
import 'package:with_you_app/ui/more_page/profile_page/full_image_page.dart';
import 'package:with_you_app/ui/more_page/profile_page/set_profile_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userInfo}) : super(key: key);
  final UserEntity userInfo;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SetUserDataUseCase _setUserDataUseCase = SetUserDataUseCase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  String? _gender;
  String? _country;
  String? _countryOfResidence;
  String _image = '';
  List<String> _languages = [];
  bool _enableEdit = false;
  bool _isLoading = false;
  @override
  void initState() {
    _nameController.text = widget.userInfo.name;
    _phoneController.text = widget.userInfo.phoneNumber;
    _ageController.text = widget.userInfo.age;
    _gender = widget.userInfo.gender;
    _country = widget.userInfo.country;
    _image = widget.userInfo.image;
    _languages = widget.userInfo.languages.map((e) => e).toList();
    _experienceController.text = widget.userInfo.experience;
    _countryOfResidence = widget.userInfo.countryOfResidence;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultAppBar(context, title: 'Profile', actions: [
        IconButton(
            onPressed: () {
              _enableEdit = !_enableEdit;
              setState(() {});
            },
            icon: Icon(
              _enableEdit ? Iconsax.edit5 : Iconsax.edit4,
              color: AppColors.primaryColor,
            ))
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // const ProfileImageWidget(),
              !_enableEdit
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImageAlert();
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.width * .37,
                              width: MediaQuery.of(context).size.width * .37,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: AppNetworkImage(path: _image)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(widget.userInfo.emailAddress,
                            style: TextStyles.bold(
                                fontSize: 20, color: AppColors.neutral_600)),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              AppTextFormField(
                isEnabled: _enableEdit,
                controller: _nameController,
                hint: "Name",
                label: "Name",
                keyboardType: TextInputType.emailAddress,
              ),
              AppTextFormField(
                controller: _phoneController,
                isEnabled: _enableEdit,
                hint: "Phone Number",
                label: "Phone Number",
                maxLength: 11,
                keyboardType: TextInputType.phone,
              ),
              AppTextFormField(
                controller: _ageController,
                isEnabled: _enableEdit,
                hint: "Age",
                label: "Age",
                maxLength: 3,
                keyboardType: TextInputType.number,
              ),
              AppTextFormField(
                controller: _experienceController,
                isEnabled: _enableEdit,
                hint: "Experience",
                label: "Experience",
                maxLength: 3,
                keyboardType: TextInputType.number,
              ),
              SingleSelectDropDown<String?>(
                isEnabled: _enableEdit,
                onChanged: (selectedItem) {
                  _gender = selectedItem ?? '';
                  setState(() {});
                },
                itemsValues: const ['Male', 'Female'],
                showItems: const ['Male', 'Female'],
                hint: "Gender",
                label: "Gender",
                value: _gender,
                selectedText: _gender,
              ),
              SingleSelectDropDown<String?>(
                isEnabled: _enableEdit,
                label: "Country Of Residence",
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
              SingleSelectDropDown<String?>(
                isEnabled: _enableEdit,
                onChanged: (selectedItem) {
                  _country = selectedItem ?? '';
                  setState(() {});
                },
                itemsValues: countries,
                showItems: countries,
                hint: "Country",
                label: "Country",
                value: _country,
                selectedText: _country,
              ),
              LanguagesDropDown(
                label: "Languages",
                isEnabled: _enableEdit,
                initialValues: _languages,
                onchange: (languages) {
                  _languages = languages;
                },
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _enableEdit
          ? Material(
              elevation: 1,
              color: Colors.white,
              child: Container(
                height: 100,
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 40),
                child: AppButtons.primaryButton(
                  text: "Save",
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
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
                        UserEntity user = UserEntity(
                            name: _nameController.text,
                            phoneNumber: _phoneController.text,
                            age: _ageController.text,
                            emailAddress: widget.userInfo.emailAddress,
                            password: widget.userInfo.password,
                            gender: _gender ?? '',
                            countryOfResidence: _countryOfResidence ?? '',
                            experience: _experienceController.text,
                            languages: _languages,
                            country: _country ?? '');
                        final result =
                            await _setUserDataUseCase.execute(context, user);
                        if (result) {
                          _enableEdit = false;
                          AppSnackBars.success(context,
                              title: 'Profile Updated Successfully');
                        }
                      }
                      _isLoading = false;
                      setState(() {});
                    }
                  },
                  isLoading: _isLoading,
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Future<void> _showImageAlert() async {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppButtons.textButton(
                    text: 'Show Full Image',
                    onPressed: () {
                      pop(context);
                      navigate(context,
                          FullImagePage(imagePath: widget.userInfo.image));
                    },
                  ),
                  const AppDivider(verticalPadding: 0, height: 1),
                  AppButtons.textButton(
                    text: 'Update Image',
                    onPressed: () {
                      pop(context);
                      navigate(
                          context,
                          const SetUserProfileImagePage(
                            canPop: true,
                          )).then((value) {
                        if (value != null) {
                          _image = value;
                          setState(() {});
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
