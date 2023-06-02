// import 'package:flutter/material.dart';
//
// class UserTypeRadioGroupWidget extends StatelessWidget {
//   final void Function(Enum?)? onChanged;
//   final UserType? value;
//   const UserTypeRadioGroupWidget(
//       {Key? key, this.onChanged, this.value})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         RadioListTile(
//           value: UserType.Tour_Guide,
//           groupValue: value,
//           activeColor: Colors.white,
//           contentPadding: EdgeInsets.zero,
//           onChanged: onChanged,
//           title:
//               const Text("Tour Guide", style: TextStyle(color: Colors.white)),
//         ),
//         RadioListTile(
//           contentPadding: EdgeInsets.zero,
//           activeColor: Colors.white,
//           value: UserType.Photographer,
//           groupValue: value,
//           onChanged: onChanged,
//           title:
//               const Text("Photographer", style: TextStyle(color: Colors.white)),
//         ),
//         RadioListTile(
//           value: UserType.Tourist,
//           groupValue: value,
//           contentPadding: EdgeInsets.zero,
//           activeColor: Colors.white,
//           onChanged: onChanged,
//           title: const Text("Tourist", style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }
