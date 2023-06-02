import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/network_image.dart';

class FullImagePage extends StatelessWidget {
  const FullImagePage({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.leadingAppBar(context),
      body: InteractiveViewer(
          maxScale: 5,
          child: Container(
            alignment: Alignment.center,
            child: AppNetworkImage(
              path: imagePath,
              width: MediaQuery.of(context).size.width,
            ),
          )),
    );
  }
}
