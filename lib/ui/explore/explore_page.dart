import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/bottom_sheet.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/common/material/radio_button/radio_button.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/ui/explore/filter/filter_utils.dart';
import 'package:with_you_app/ui/user_details_page/explore_user_details.dart';
import 'explore_user_card.dart';
import 'filter/filter_model.dart';
import 'filter/filter_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  final Stream<QuerySnapshot> _tripsStream = FirebaseFirestore.instance
      .collection(FireBaseUserKeys.userCollection)
      .snapshots();
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  final ValueNotifier<FilterModel> _filterNotifier =
      ValueNotifier(FilterModel.initial());
  final FilterUtils _filterUtils = FilterUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        body: StreamBuilder<QuerySnapshot>(
          stream: _tripsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const FailWidget();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoader();
            }
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data?.docs != null) {
              List<UserEntity> users = snapshot.data?.docs
                      .map((e) => UserDataMapper.convert(e))
                      .toList() ??
                  [];
              _filterUtils.users = users;
              return ValueListenableBuilder(
                valueListenable: _filterNotifier,
                builder: (context, value, child) {
                  _filterUtils.filterModel = value;
                  _filterUtils.filter();
                  print('rebuild ValueListenableBuilder');
                  return ListView.builder(
                    key: ValueKey(_filterUtils.filterModel.languages.length),
                    itemCount: _filterUtils.filteredList.length,
                    itemBuilder: (context, index) {
                      print('build list view . builder');
                      final int count = _filterUtils.filteredList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      _animationController?.forward();
                      return UserCard(
                        onTap: () {
                          navigate(
                              context,
                              UserDetailsPage(
                                user: _filterUtils.filteredList[index],
                              ));
                        },
                        animation: animation,
                        animationController: _animationController,
                        user: _filterUtils.filteredList[index],
                      );
                    },
                    padding: const EdgeInsets.all(0),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconButton(
                onTap: () {
                  _showFilterBottomSheet();
                },
                icon: Iconsax.filter),
            _iconButton(
              onTap: () {
                _showSortBottomSheet();
              },
              icon: Iconsax.sort,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget _iconButton({required VoidCallback onTap, required IconData icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: AppColors.neutral_600),
        child: Icon(icon, color: AppColors.forthColor),
      ),
    );
  }

  Future<void> _showSortBottomSheet() async {
    appBottomSheet(
      context,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Sort By :",
                    style: TextStyles.bold(
                        color: AppColors.neutral_300, fontSize: 20)),
              ),
              GroupRadioButton(
                textList: sortList,
                value: _filterNotifier.value.sortValue,
                onChanged: (value) {
                  _filterNotifier.value =
                      _filterNotifier.value.modify(sortValue: value);
                  pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showFilterBottomSheet() async {
    await appBottomSheet(
      context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .9,
          child: FilterPage(
            filterModel: _filterNotifier.value,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        _filterNotifier.value = value;
        setState(() {});
      }
    });
  }
}
