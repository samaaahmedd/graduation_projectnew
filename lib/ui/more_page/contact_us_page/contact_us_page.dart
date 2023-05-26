import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_colors.dart';


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
      appBar:AppBars.defaultAppBar(context, title: 'Contact Us'),
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_30, height: 3, thickness: 1),
              ),
              Text(
                'You Can Contact Us Via',
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.neutral_600,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_400, height: 3, thickness: 1),
              ),
              ListTile(
                minLeadingWidth: 20,
                leading: Icon(Icons.email_outlined,
                    color: AppColors.neutral_700, size: 26),
                title: Text('samaa_ahmed@gmail.com',
                    style: TextStyle(
                        color: AppColors.neutral_700,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
              ),

              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_50, height: 3, thickness: 1),
              ),
              Text(
                'OR Via Our Social',
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.neutral_700,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Divider(
                    color: AppColors.neutral_50, height: 3, thickness: 1),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FaIcon(FontAwesomeIcons.facebook,
                      color: Colors.blue, size: 40),
                  FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.green,
                    size: 40,
                  ),
                  FaIcon(FontAwesomeIcons.twitter,
                      color: Colors.blueAccent, size: 40),
                  FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.redAccent, size: 40),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
