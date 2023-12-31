import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/ui/explore/explore_page.dart';
import 'more_page./more_page.dart';
import 'my_booking/my_booking_page.dart';
import 'my_requests/my_requests_page.dart';
import 'my_trips/my_trips_page.dart';
import 'search/search_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final PersistentTabController _persistentTabController =
      PersistentTabController();
  final List<Widget> _tabs = const [
    ExplorePage(),
    MyRequestsPage(),
    MyBookingPage(),
    SearchPage(),
    MorePage(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        iconSize: 25,
        icon: const Icon(Icons.explore_outlined),
        title: ("Explore"),
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.neutral_100,
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        icon: const Icon(Iconsax.direct_inbox4),
        title: ("Requests"),
        activeColorPrimary: AppColors.neutral_700,
        inactiveColorPrimary: AppColors.neutral_100,
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        icon: const Icon(
          Iconsax.bookmark,
        ),
        title: ("Booking"),
        activeColorPrimary: AppColors.neutral_700,
        inactiveColorPrimary: AppColors.neutral_100,
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        icon: const Icon(Iconsax.search_normal),
        title: ("Search"),
        activeColorPrimary: AppColors.neutral_700,
        inactiveColorPrimary: AppColors.neutral_100,
      ),
      PersistentBottomNavBarItem(
        iconSize: 25,
        icon: const Icon(Iconsax.more4),
        title: ("More"),
        activeColorPrimary: AppColors.neutral_700,
        inactiveColorPrimary: AppColors.neutral_100,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: .8,
        title: const Text('With You',
            style: TextStyle(
                fontFamily: 'Pacifico',
                fontWeight: FontWeight.bold,
                color: AppColors.neutral_600,
                fontSize: 28)),
      ),
      body: PersistentTabView(
        context,
        controller: _persistentTabController,
        screens: _tabs,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        navBarHeight: 60,
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(15.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style3, // Choose the nav bar style with this property.
      ),
    ); // return Scaffold(
  }
}
