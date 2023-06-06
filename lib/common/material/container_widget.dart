import 'package:flutter/material.dart';

import 'app_colors.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(color: AppColors.neutral_30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.neutral_30,
            spreadRadius: .7,
            blurRadius: 2,
            offset: Offset(1, .4), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
