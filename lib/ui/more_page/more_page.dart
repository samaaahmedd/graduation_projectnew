// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_tile.dart';
import 'package:with_you_app/domain/use_cases/authentication/log_out_use_case.dart';
import 'package:with_you_app/ui/authentication/log_in_page.dart';
import 'package:with_you_app/ui/more_page/about_app_page/about_app_page.dart';
import 'package:with_you_app/ui/more_page/contact_us_page/contact_us_page.dart';
import 'package:with_you_app/ui/more_page/terms_privacy_page/terms_privacy_page.dart';
import 'package:with_you_app/ui/more_page/update_password/update_password_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final LogOutUseCase _logOutUseCase = LogOutUseCase();
  bool _logOutLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.header(context, title: 'More'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),

            // Container(
            //   height: 100,
            //   width: 100,
            //   decoration:  BoxDecoration(
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.circular(20),
            //       image: const DecorationImage(
            //           image: NetworkImage(
            //               "https://thumbs.dreamstime.com/b/surprised-female-person-confused-isolated-surprised-female-person-confused-isolated-168304856.jpg"),
            //           fit: BoxFit.cover)),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            // Text('Sama Ahamed',
            //     style: TextStyle(
            //         color: AppColors.textColor,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 20)),
            AppTile(
              icon: Iconsax.key ,
              onTap: ()=> navigate(context, const UpdatePasswordPage()),
              text: "Update Password",
            ),
            AppTile(
              icon: Icons.error_outline,
              onTap: ()=> navigate(context, const AboutAppPage()),
              text: "About App",
            ),
            AppTile(
              icon: Icons.mail_outline_rounded,
              onTap: ()=> navigate(context, const ContactUsPage()),
              text: "Contact Us",
            ),
            AppTile(
              icon: Icons.privacy_tip_outlined,
              onTap: ()=> navigate(context, const TermsPrivacyPage()),
              text: "Terms And Privacy",
            ),
            AppTile(
              icon: Icons.logout,
              onTap: _onLogOut,
              text: "Log Out",
              isLoading: _logOutLoading,
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const ProfilePage(),
            //     ));
            //   },
            //   minLeadingWidth: 24,
            //   leading: Icon(Icons.person_outline,
            //       color: AppColors.textColor, size: 28),
            //   title: Text('Profile',
            //       style: TextStyle(
            //           color: AppColors.textColor,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18)),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Divider(color: AppColors.fifthColor, height: 2),
            // ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContactUsPage(),));
            //   },
            //   minLeadingWidth: 20,
            //   leading:
            //       Icon(Iconsax.message, color: AppColors.textColor, size: 26),
            //   title: Text('Contact Us',
            //       style: TextStyle(
            //           color: AppColors.textColor,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18)),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Divider(color: AppColors.fifthColor, height: 2),
            // ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutAppPage(),));
            //   },
            //   minLeadingWidth: 20,
            //   leading:
            //       Icon(Iconsax.info_circle, color: AppColors.textColor, size: 24),
            //   title: Text('About App',
            //       style: TextStyle(
            //           color: AppColors.textColor,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18)),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Divider(color: AppColors.fifthColor, height: 2),
            // ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsPrivacyPage(),));
            //   },
            //   minLeadingWidth: 20,
            //   leading:
            //   Icon(Iconsax.security, color: AppColors.textColor, size: 24),
            //   title: Text('Terms Of Use && Privacy',
            //       style: TextStyle(
            //           color: AppColors.textColor,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18)),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Divider(color: AppColors.fifthColor, height: 2),
            // ),
            const SizedBox(
              height: 100,
            ),
            // CustomButton(
            //   onPressed: () async {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //       builder: (context) => const WelcomePage(),
            //     ));
            //     await _setLogInUseCase(false);
            //   },
            //   text: 'Log Out',
            // ),
            // CustomButton(
            //   onPressed: () async {},
            //   color: Colors.redAccent,
            //   text: 'Delete Account',
            // ),
          ],
        ),
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
