import 'package:flutter/material.dart';
import 'package:with_you_app/ui/authentication/log_in_page.dart';
import 'package:with_you_app/ui/authentication/register_page.dart';

import 'authentication/log_in_page.dart';
import 'authentication/register_page.dart';
// import 'package:with_me/new%20screens/Login_Screen.dart';
// import 'package:with_me/new%20screens/signup_screen.dart';
// import 'package:with_me/register_page/check_register_type_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/logo.jpeg"), fit: BoxFit.fitHeight),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Let\'s Go',
                style: TextStyle(
                    fontFamily: "Dancing Script",
                    color: Colors.white,
                    fontSize: 75,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'WithYou everywhere',
                style: TextStyle(
                    color: Color.fromARGB(255, 28, 37, 47),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .45,
              ),
              _logInOrRegisterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logInOrRegisterWidget() {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: InkWell(
                  onTap: _onTapLogIn,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white,
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                )),
            Expanded(
                child: InkWell(
                  onTap: _onTapRegister,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Color.fromARGB(255, 28, 37, 47),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                )),
          ]),
    );
  }

  void _onTapLogIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LogInPage()));
  }

  void _onTapRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }
}