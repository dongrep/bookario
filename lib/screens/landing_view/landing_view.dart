import 'dart:io';

import 'package:bookario/components/constants.dart';
import 'package:bookario/components/enum.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/home/home_screen.dart';
import 'package:bookario/screens/customer_UI_screens/premium_clubs/premium_club_list.dart';
import 'package:bookario/screens/customer_UI_screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  static String routeName = "/navbar";
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(
      eventType: EventType.home,
    ),
    const HomeScreen(
      eventType: EventType.premium,
    ),
    ProfileScreen()
  ];

  Future<bool?> _exitApp(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            "Want to exit?",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              splashColor: Colors.red[50],
              child: Text(
                "No",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
            MaterialButton(
              onPressed: () => exit(0),
              splashColor: Colors.red[50],
              child: Text(
                "Yes",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF141414),
        unselectedItemColor: Colors.grey,
        fixedColor: kSecondaryColor,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Premium Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: kAnimationDuration,
      curve: Curves.ease,
    );
  }

  void onPageChanged(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
