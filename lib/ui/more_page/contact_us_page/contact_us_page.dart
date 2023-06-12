import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.defaultAppBar(context, title: 'Contact Us'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_30, height: 3, thickness: 1),
              ),
              const Text(
                'You Can Contact Us Via',
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.neutral_600,
                    fontWeight: FontWeight.w700),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_400, height: 3, thickness: 1),
              ),
              ListTile(
                minLeadingWidth: 20,
                leading: const Icon(Icons.email_outlined,
                    color: AppColors.neutral_700, size: 26),
                onTap: () {
                  sendEmail();
                },
                title: const Text('withyou.withueverywhere@gmail.com',
                    style: TextStyle(
                        color: AppColors.neutral_700,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_50, height: 3, thickness: 1),
              ),
              const Text(
                'OR Via Our Social',
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.neutral_700,
                    fontWeight: FontWeight.w700),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_50, height: 3, thickness: 1),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _launchUrl(
                          'https://www.facebook.com/sama.ahmed.16503323?mibextid=LQQJ4d');
                    },
                    child: const FaIcon(FontAwesomeIcons.facebook,
                        color: Colors.blue, size: 40),
                  ),
                  InkWell(
                    onTap: () {
                      _launchUrl(
                          'https://www.instagram.com/withyouu_app/?igshid=MzRlODBiNWFlZA==');
                    },
                    child: const FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.redAccent, size: 40),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendEmail() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'withyou.withueverywhere@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'How Can We Help You, Hope To Be More HelpFull.',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
