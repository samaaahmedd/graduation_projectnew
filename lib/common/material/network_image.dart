import 'package:flutter/material.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
      {Key? key, required this.path, this.width, this.height, this.scale})
      : super(key: key);
  final String path;
  final double? width;
  final double? height;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FadeInImage.assetNetwork(
        image: path,
        fit: BoxFit.cover,
        width: width,
        height: height,
        imageScale: scale ?? 1,
        placeholder: ImagesPaths.noImage,
        placeholderFit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.withOpacity(.3),
          );
        },
        placeholderErrorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.withOpacity(.3),
          );
        },
      ),
    );
  }
}
