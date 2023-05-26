// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:with_me/common/color/app_color.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: AppColors.secondaryColor,
//         automaticallyImplyLeading: true,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 120,
//                   width: 120,
//                   decoration: const BoxDecoration(
//                       color: Colors.grey,
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                           image: NetworkImage(
//                               "https://thumbs.dreamstime.com/b/surprised-female-person-confused-isolated-surprised-female-person-confused-isolated-168304856.jpg"),
//                           fit: BoxFit.cover)),
//                 ),
//                 const SizedBox(height: 15,),
//                 Text('Sama Ahmed',style: TextStyle(
//                     color: AppColors.textColor,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 20)),
//                 const SizedBox(height: 25,),
//
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Icon(Icons.email_outlined,
//                       color: AppColors.textColor, size: 22),
//                   title: Text('sama@gmail.com',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                 ),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Icon(Icons.phone_android,
//                       color: AppColors.textColor, size: 22),
//                   title: Text('Phone',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                 ),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Icon(Iconsax.language_square,
//                       color: AppColors.textColor, size: 22),
//                   title: Text('Arabic , English ',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                 ),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Icon(Iconsax.location,
//                       color: AppColors.textColor, size: 22),
//                   title: Text('Zayed , ST.12',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                 ),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Icon(Icons.language,
//                       color: AppColors.textColor, size: 22),
//                   title: Text('Egyptian',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
//                   child: Divider(color: AppColors.fifthColor, height: 1),
//                 ),
//                 Text('More Information',style: TextStyle(
//                     color: AppColors.textColor,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 20)),
//                 const SizedBox(height: 20,),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Text('Experience :',
//                     style: TextStyle(
//                         color: AppColors.textColor,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 18)),
//                   title: Text('2 years',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 17)),
//                 ),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Text('Country :',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                   title: Text('Egypt',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 17)),
//                 ),
//                 ListTile(
//                   minLeadingWidth: 20,
//                   leading: Text('Age :',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18)),
//                   title: Text('26',
//                       style: TextStyle(
//                           color: AppColors.textColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 17)),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
