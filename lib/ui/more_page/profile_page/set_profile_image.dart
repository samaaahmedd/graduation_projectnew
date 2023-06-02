// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/common/material/app_tile.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/use_cases/user/set_user_image_use_case.dart';
import 'package:with_you_app/ui/host_page.dart';

class SetUserProfileImagePage extends StatefulWidget {
  const SetUserProfileImagePage({Key? key, this.canPop = false})
      : super(key: key);
  final bool canPop;

  @override
  State<SetUserProfileImagePage> createState() =>
      _SetUserProfileImagePageState();
}

class _SetUserProfileImagePageState extends State<SetUserProfileImagePage> {
  final SetUserImageUseCase _setUserImageUseCase = SetUserImageUseCase();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: widget.canPop ? AppBars.leadingAppBar(context) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Set Your Profile Image',
                  style: TextStyles.bold(
                      fontSize: 22, color: AppColors.neutral_300)),
              const SizedBox(
                height: 50,
              ),
              Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.height * .2,
                  decoration: BoxDecoration(
                    color: AppColors.neutral_30,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          offset: const Offset(.7, .2),
                          blurRadius: .5,
                          spreadRadius: .2)
                    ],
                    shape: BoxShape.circle,
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _image == null
                      ? const Icon(
                          Iconsax.image5,
                          size: 35,
                          color: AppColors.neutral_70,
                        )
                      : null),
              SizedBox(
                height: MediaQuery.of(context).size.width * .1,
              ),
              AppTile(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: Iconsax.gallery,
                  text: 'Select From Gallery'),
              AppTile(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                icon: Iconsax.camera,
                text: 'Select From Camera',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .3,
              ),
              AppButtons.primaryButton(
                isLoading: _isLoading,
                text: 'Save Image',
                onPressed: () async {
                  if (_image != null) {
                    _isLoading = true;
                    setState(() {});
                    final result =
                        await _setUserImageUseCase.execute(context, _image!);
                    if (result != null) {
                      if (widget.canPop == true) {
                        Navigator.of(context).pop(result);
                      } else {
                        navigateRemoveReplacement(context, const HostPage());
                      }
                    }
                    _isLoading = false;
                    setState(() {});
                  } else {
                    AppSnackBars.hint(context,
                        title: 'Please , Select Image First');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      setState(() {});
    }
  }
}
