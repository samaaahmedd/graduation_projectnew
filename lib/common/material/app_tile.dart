import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class AppTile extends StatelessWidget {
  const AppTile(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.text,
      this.trailing, this.isLoading = false})
      : super(key: key);
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Icon? trailing;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(8) ),
      // padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
      child: ListTile(
        trailing: isLoading
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 3,
                ),
              )
            : trailing ??
                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
        minLeadingWidth: 24,
        leading: Icon(
          icon,
          color: AppColors.neutral_700,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15,),
        title: Text(text,
            style: TextStyles.medium(
              fontSize: 17,
              color: AppColors.neutral_700,
            )),
      ),
    );
  }
}
