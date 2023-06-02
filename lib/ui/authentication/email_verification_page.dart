// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/use_cases/authentication/check_if_email_verified.dart';
import 'package:with_you_app/domain/use_cases/authentication/send_verification_email_use_case.dart';
import 'package:with_you_app/ui/host_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final SendVerificationEmail _sendVerificationEmail = SendVerificationEmail();
  final CheckIfEmailVerified _checkIfEmailVerified = CheckIfEmailVerified();

  bool _resendIsLoading = false;
  bool _verifyLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: AppBars.leadingAppBar(context),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Just One Step To Join Us',
                style: TextStyles.bold(
                    fontSize: 30, color: AppColors.neutral_700, height: 1.5),
              ),
            ),
            Text(
              'Please check your email\nYou have received email with verification link for verifying your email',
              style: TextStyles.regular(
                  fontSize: 20, color: AppColors.neutral_300, height: 1.5),
            ),
            const SizedBox(height: 30),
            Text(
              'Note :\n After verifying your email address just click on (I Verify) button',
              style: TextStyles.regular(
                  fontSize: 16, color: AppColors.neutral_80, height: 1.5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            AppButtons.primaryButton(
              text: "I  Verify",
              isLoading: _verifyLoading,
              onPressed: () async {
                _verifyLoading = true;
                setState(() {});
                final result = await _checkIfEmailVerified.execute(context);
                _verifyLoading = false;
                setState(() {});
                if (result) {
                  navigateRemoveReplacement(context, const HostPage());
                }
              },
            ),
            const SizedBox(height: 25),
            AppButtons.textButton(
              text: "Resend Verification Email",
              isLoading: _resendIsLoading,
              onPressed: () async {
                _resendIsLoading = true;
                setState(() {});
                await _sendVerificationEmail.execute(context);
                _resendIsLoading = false;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
