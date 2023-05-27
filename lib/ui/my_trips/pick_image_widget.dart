import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/common/material/divider.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/extenstions.dart';

class PickImageWidget extends StatefulWidget {
  const PickImageWidget({
    Key? key,
    this.label,
    required this.onchange,
  }) : super(key: key);
  final String? label;

  final void Function(List<File>) onchange;

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  List<File> pickedImage = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: widget.label != null,
            replacement: const SizedBox(),
            child: Column(
              children: [
                Text(
                  widget.label ?? '',
                  style: TextStyles.medium(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            )),
        InkWell(
          onTap: () {
            _pickImages();
          },
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.forthColor,
                border: Border.all(color: AppColors.neutral_40)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_outlined),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  'Tap To Select Images',
                  softWrap: true,
                  style: TextStyles.medium(),
                )
              ],
            ),
          ),
        ),
        Column(
          children:
              pickedImage.mapIndexed((e, i) => _pickedImageTile(e, i)).toList(),
        ),
        pickedImage.isNotEmpty ? const AppDivider() : const SizedBox(),
      ],
    );
  }

  Widget _pickedImageTile(File image, int index) {
    return ListTile(
      minLeadingWidth: 20,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        image.path.split('/').last,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyles.regular(),
      ),
      leading: const Icon(Icons.image, size: 22),
      trailing: IconButton(
          onPressed: () {
            pickedImage.removeAt(index);
            widget.onchange(pickedImage);
            setState(() {});
          },
          icon: const Icon(
            Icons.delete_outline,
            size: 20,
          )),
    );
  }

  Future<void> _pickImages() async {
    if (pickedImage.length < 5) {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        pickedImage.addAll(images.map((e) => File(e.path)).toList());
        widget.onchange(pickedImage);
        setState(() {});
      }
    } else {
      AppSnackBars.hint(context,
          title: 'Note , images number must be at least 3 and at most 5');
    }
  }
}
