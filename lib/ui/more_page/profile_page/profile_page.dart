import 'package:flutter/material.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userInfo}) : super(key: key);
  final UserEntity userInfo;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
