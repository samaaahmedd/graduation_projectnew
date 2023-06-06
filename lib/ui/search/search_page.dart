import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/ui/explore/taps/trip_user_info_tap.dart';
import 'package:with_you_app/ui/user_details_page/explore_user_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText = '';
  final CollectionReference _user =
      FirebaseFirestore.instance.collection(FireBaseUserKeys.userCollection);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AppTextFormField(
            onchange: (text) {
              Timer(const Duration(milliseconds: 350), () {
                _searchText = text;
                setState(() {});
              });
            },
            hint: "Search For Guide",
            suffix:
                const Icon(Iconsax.search_normal, color: AppColors.neutral_600),
            maxLines: 1,
          ),
        ),
        body: Visibility(
            replacement: Center(
                child: Image.asset(
              ImagesPaths.searchIllustration,
              scale: 2,
            )),
            visible: _searchText.isNotEmpty,
            child: FutureBuilder<QuerySnapshot>(
              future: _user.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const FailWidget();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppLoader();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  List<UserEntity> users =
                      UserDataMapper.convertList(snapshot.data!);
                  List<UserEntity> searchList = [];
                  users.map((e) {
                    if (e.name.toLowerCase().contains(_searchText)) {
                      searchList.add(e);
                    }
                  }).toList();
                  if (searchList.isEmpty) {
                    return Center(
                      child: Text('No Result',
                          style: TextStyles.regular(fontSize: 16)),
                    );
                  }
                  return ListView.builder(
                    itemCount: searchList.length,
                    itemBuilder: (context, index) {
                      return _SearchCard(
                        user: searchList[index],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            )),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final UserEntity user;
  const _SearchCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(
            context,
            UserDetailsPage(
              user: user,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(Random().nextInt(0xff091E42)),
              ),
              child: FittedBox(
                  child: Text(
                user.name[0].toUpperCase(),
                style: TextStyles.bold(),
              )),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(
                        fontSize: 15, color: AppColors.neutral_500)),
                const SizedBox(
                  height: 8,
                ),
                Text('${user.type}  -  ${user.countryOfResidence}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(
                        fontSize: 12, color: AppColors.neutral_100)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
