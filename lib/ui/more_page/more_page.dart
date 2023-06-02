// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_tile.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/use_cases/authentication/log_out_use_case.dart';
import 'package:with_you_app/ui/authentication/log_in_page.dart';
import 'package:with_you_app/ui/more_page/about_app_page/about_app_page.dart';
import 'package:with_you_app/ui/more_page/contact_us_page/contact_us_page.dart';
import 'package:with_you_app/ui/more_page/terms_privacy_page/terms_privacy_page.dart';
import 'package:with_you_app/ui/more_page/update_password/update_password_page.dart';

import 'profile_page/profile_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final LogOutUseCase _logOutUseCase = LogOutUseCase();
  final CollectionReference _userInfo =
      FirebaseFirestore.instance.collection(FireBaseUserKeys.userCollection);

  final _user = FirebaseFirestore.instance
      .collection(FireBaseUserKeys.userCollection)
      .doc(FirebaseAuth.instance.currentUser?.email)
      .snapshots();

  bool _logOutLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _user,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const FailWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasData && snapshot.data?.data() != null) {
            UserEntity userInfo = UserDataMapper.convert(snapshot.data!);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      navigate(
                          context,
                          ProfilePage(
                            userInfo: userInfo,
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                color: AppColors.neutral_30,
                                borderRadius: BorderRadius.circular(50)),
                            child: AppNetworkImage(path: userInfo.image),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userInfo.name,
                                  style: TextStyles.bold(fontSize: 18)),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(userInfo.emailAddress,
                                  style: TextStyles.medium(fontSize: 15)),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  AppTile(
                    icon: Iconsax.key,
                    onTap: () => navigate(context, const UpdatePasswordPage()),
                    text: "Update Password",
                  ),
                  AppTile(
                    icon: Icons.payment_outlined,
                    onTap: () {},
                    text: "Payment",
                  ),
                  AppTile(
                    icon: Icons.mail_outline_rounded,
                    onTap: () => navigate(context, const ContactUsPage()),
                    text: "Contact Us",
                  ),
                  AppTile(
                    icon: Icons.error_outline,
                    onTap: () => navigate(context, const AboutAppPage()),
                    text: "About App",
                  ),
                  AppTile(
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => navigate(context, const TermsPrivacyPage()),
                    text: "Terms And Privacy",
                  ),
                  AppTile(
                    icon: Icons.logout,
                    onTap: _onLogOut,
                    text: "Log Out",
                    isLoading: _logOutLoading,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            );
          }
          print('else ---------------------- ${snapshot.data.toString()}');

          return const SizedBox();
        },
      ),
    );
  }

  void _onLogOut() async {
    _logOutLoading = true;
    setState(() {});
    final bool result = await _logOutUseCase.execute(context);
    if (result) {
      navigateRemoveReplacement(context, const LogInPage());
    }
    _logOutLoading = false;
    setState(() {});
  }
}
