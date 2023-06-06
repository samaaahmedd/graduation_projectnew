import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/rating_bar.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'send_request_page/send_request_page.dart';

class ExploreUserDetails extends StatelessWidget {
  final UserEntity user;
  const ExploreUserDetails({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _PageAppBar(
              imagePath: user.image,
            ),
            const SizedBox(
              height: 40,
            ),
            _ContainerWidget(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.bold(
                            fontSize: 20, color: AppColors.neutral_500)),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                        '${user.type}  -  ${user.gender}  -  ${user.age} years old',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.bold(
                            fontSize: 12, color: AppColors.neutral_100)),
                    RatingBar(rate: double.tryParse(user.rate) ?? 3),
                  ]),
            ),
            _ContainerWidget(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Country : ${user.country}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Country Of Residence : ${user.countryOfResidence} - City : ${user.city}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    user.pricePerHour.isNotEmpty
                        ? Text('Price Per Hour : ${user.pricePerHour}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.regular(
                                // fontSize: 13,
                                color: AppColors.neutral_600))
                        : const SizedBox(),
                  ]),
            ),
            _ContainerWidget(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone Number : : ${user.phoneNumber}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Experience : ${user.experience}  year',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Languages : ${user.languages.join(' , ')}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                  ]),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(20),
        child: AppButtons.primaryButton(
          text: 'REQUEST  ${user.type}',
          onPressed: () {
            navigate(
                context,
                SendRequestPage(
                  userEntity: user,
                ));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _PageAppBar extends StatelessWidget {
  final String imagePath;
  const _PageAppBar({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .25,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .2,
            decoration: const BoxDecoration(
                color: AppColors.neutral_700,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(100))),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * .1,
            child: Material(
              elevation: .8,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(100)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: AppNetworkImage(
                    path: imagePath,
                    scale: .5,
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.width * .3,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 35, 20, 20),
            child: IconButton(
                onPressed: () => pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}

class _ContainerWidget extends StatelessWidget {
  const _ContainerWidget({Key? key, required this.child}) : super(key: key);
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
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

// class UserInfoPreview extends StatelessWidget {
//   final UserEntity user;
//   const UserInfoPreview({Key? key, required this.user}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(user.name.toUpperCase(),
//                   style: TextStyles.bold(
//                       fontSize: 22, color: AppColors.neutral_500, height: 1.3)),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(user.emailAddress,
//                   style: TextStyles.medium(
//                       fontSize: 18, color: AppColors.neutral_500, height: 1.3)),
//               const SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//         HeaderRowWidget(
//           text: '\t${user.type.toUpperCase()}',
//         ),
//         const HeaderRowWidget(
//           text: "Price ( per hour ) 50",
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('${user.pricePerHour} \$ / h',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         const HeaderRowWidget(
//           text: "Details",
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('Phone Number : ${user.phoneNumber}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text('Rating : ',
//                   style: TextStyles.medium(
//                       fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//               RatingBar(
//                 rate: double.tryParse(user.rate) ?? 2,
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('Languages : ${user.languages.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('Gender : ${user.gender.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('Age : ${user.age.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('Experience : ${user.experience.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         const HeaderRowWidget(
//           text: "Address Details",
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('Country : ${user.country.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text(
//               'Country Of Residence : ${user.countryOfResidence.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//           child: Text('City : ${user.city.toString()}',
//               style: TextStyles.medium(
//                   fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
//         ),
//         const SizedBox(
//           height: 150,
//         ),
//       ],
//     );
//   }
// }
