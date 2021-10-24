// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'screens/customer_UI_screens/home/home_screen.dart';
import 'screens/customer_UI_screens/profile/components/edit_profile.dart';
import 'screens/customer_UI_screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String signInScreen = '/sign_in';
  static const String signUpScreen = '/sign_up';
  static const String homeScreen = '/home';
  static const String profileScreen = '/my-profile';
  static const String editProfile = '/edit-profile';
  static const String splashScreen = '/splash_screen';
  static const all = <String>{
    startUpView,
    signInScreen,
    signUpScreen,
    homeScreen,
    profileScreen,
    editProfile,
    splashScreen,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.signInScreen, page: SignInScreen),
    RouteDef(Routes.signUpScreen, page: SignUpScreen),
    RouteDef(Routes.homeScreen, page: HomeScreen),
    RouteDef(Routes.profileScreen, page: ProfileScreen),
    RouteDef(Routes.editProfile, page: EditProfile),
    RouteDef(Routes.splashScreen, page: SplashScreen),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartUpView(),
        settings: data,
      );
    },
    SignInScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInScreen(),
        settings: data,
      );
    },
    SignUpScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignUpScreen(),
        settings: data,
      );
    },
    HomeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeScreen(),
        settings: data,
      );
    },
    ProfileScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProfileScreen(),
        settings: data,
      );
    },
    EditProfile: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditProfile(),
        settings: data,
      );
    },
    SplashScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashScreen(),
        settings: data,
      );
    },
  };
}
