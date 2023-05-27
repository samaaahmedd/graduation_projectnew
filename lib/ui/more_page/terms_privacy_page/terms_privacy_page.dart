import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class TermsPrivacyPage extends StatefulWidget {
  const TermsPrivacyPage({Key? key}) : super(key: key);

  @override
  State<TermsPrivacyPage> createState() => _TermsPrivacyPageState();
}

class _TermsPrivacyPageState extends State<TermsPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.defaultAppBar(context, title: 'Terms And Privacy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms Of Use : ', style: TextStyles.medium(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            Text(
                "These Terms of Use govern your use of WITH YOU,and any information, text, graphics, photos or other materials "
                "appearing on the NOTA app, referencing these Terms. you must read and,"
                " understand these terms.",
                style: TextStyles.regular(color: AppColors.neutral_500)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 25),
              child: Divider(color: AppColors.neutral_50, height: 2),
            ),
            Text('Privacy : ', style: TextStyles.medium(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            Text(
                "The NOTA app Privacy Policy is incorporated into these Terms. By accepting these Terms, you agree to access your storage and microphone through the Services in accordance with the Privacy Policy,",
                style: TextStyles.regular(color: AppColors.neutral_500)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 25),
              child: Divider(color: AppColors.neutral_50, height: 2),
            ),
            Text('User Content  : ', style: TextStyles.medium(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            Text(
                "The Services consist of interactive features and areas that allow users to create, delete or update, including but not limited to photos,"
                " voices, text, items, or other materials (collectively,). You understand that you are responsible for all data charges you incur by using the Services."
                " You also understand that your User Content can't be viewable by others and you only have the ability to control who can access such content by adjusting your privacy settings."
                " And you agree to abide by our Community Guidelines, which may be updated from time to time.",
                style: TextStyles.regular(color: AppColors.neutral_500)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 25),
              child: Divider(color: AppColors.neutral_50, height: 2),
            ),
            Text('Feedback  : ', style: TextStyles.medium(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            Text(
                "You agree that any feedback, suggestions, ideas, or other information or materials regarding SNOW or the Services that you provide, whether by email or otherwise (Feedback),"
                " are non-confidential and shall become the sole property of SNOW. We will be entitled to the unrestricted use and dissemination of such Feedback for any purpose,"
                " commercial or otherwise, without acknowledging or compensating you. You waive any rights you may have to the Feedback (including any copyrights or moral rights)."
                " We like hearing from users, but please do not share your ideas with us if you expect to be paid or want to continue to own or claim rights in them.",
                style: TextStyles.regular(color: AppColors.neutral_500)),
          ],
        ),
      ),
    );
  }
}
