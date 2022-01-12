// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'components/enum.dart';
import 'components/make_payment.dart';
import 'models/event_model.dart';
import 'models/event_pass_model.dart';
import 'screens/customer_UI_screens/bookings/book_pass.dart';
import 'screens/customer_UI_screens/confirm_booking/confirm_booking_view.dart';
import 'screens/customer_UI_screens/details/details_screen.dart';
import 'screens/customer_UI_screens/history/booking_history.dart';
import 'screens/customer_UI_screens/home/home_screen.dart';
import 'screens/customer_UI_screens/profile/components/edit_profile.dart';
import 'screens/customer_UI_screens/profile/profile_screen.dart';
import 'screens/forgot_password/forgot_password_view.dart';
import 'screens/landing_view/landing_view.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String splashScreen = '/splash_screen';
  static const String landingView = '/landing-page';
  static const String signInScreen = '/sign_in';
  static const String signUpScreen = '/sign_up';
  static const String forgotPasswordView = '/forgot_password';
  static const String homeScreen = '/home';
  static const String detailsScreen = '/event-details';
  static const String bookPass = '/book-pass';
  static const String confirmBookingView = '/confirm-booking';
  static const String makePayment = '/make_payment';
  static const String profileScreen = '/my-profile';
  static const String editProfile = '/edit-profile';
  static const String bookingHistory = '/booking-history';
  static const all = <String>{
    startUpView,
    splashScreen,
    landingView,
    signInScreen,
    signUpScreen,
    forgotPasswordView,
    homeScreen,
    detailsScreen,
    bookPass,
    confirmBookingView,
    makePayment,
    profileScreen,
    editProfile,
    bookingHistory,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.landingView, page: LandingView),
    RouteDef(Routes.signInScreen, page: SignInScreen),
    RouteDef(Routes.signUpScreen, page: SignUpScreen),
    RouteDef(Routes.forgotPasswordView, page: ForgotPasswordView),
    RouteDef(Routes.homeScreen, page: HomeScreen),
    RouteDef(Routes.detailsScreen, page: DetailsScreen),
    RouteDef(Routes.bookPass, page: BookPass),
    RouteDef(Routes.confirmBookingView, page: ConfirmBookingView),
    RouteDef(Routes.makePayment, page: MakePayment),
    RouteDef(Routes.profileScreen, page: ProfileScreen),
    RouteDef(Routes.editProfile, page: EditProfile),
    RouteDef(Routes.bookingHistory, page: BookingHistory),
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
    SplashScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashScreen(),
        settings: data,
      );
    },
    LandingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LandingView(),
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
    ForgotPasswordView: (data) {
      var args = data.getArgs<ForgotPasswordViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForgotPasswordView(
          key: args.key,
          email: args.email,
        ),
        settings: data,
      );
    },
    HomeScreen: (data) {
      var args = data.getArgs<HomeScreenArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeScreen(
          key: args.key,
          eventType: args.eventType,
        ),
        settings: data,
      );
    },
    DetailsScreen: (data) {
      var args = data.getArgs<DetailsScreenArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => DetailsScreen(
          key: args.key,
          event: args.event,
        ),
        settings: data,
      );
    },
    BookPass: (data) {
      var args = data.getArgs<BookPassArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BookPass(
          key: args.key,
          event: args.event,
        ),
        settings: data,
      );
    },
    ConfirmBookingView: (data) {
      var args = data.getArgs<ConfirmBookingViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmBookingView(
          key: args.key,
          event: args.event,
          passes: args.passes,
          totalPrice: args.totalPrice,
        ),
        settings: data,
      );
    },
    MakePayment: (data) {
      var args = data.getArgs<MakePaymentArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MakePayment(
          key: args.key,
          type: args.type,
          amount: args.amount,
        ),
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
    BookingHistory: (data) {
      var args = data.getArgs<BookingHistoryArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BookingHistory(
          key: args.key,
          passes: args.passes,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ForgotPasswordView arguments holder class
class ForgotPasswordViewArguments {
  final Key? key;
  final String email;
  ForgotPasswordViewArguments({this.key, required this.email});
}

/// HomeScreen arguments holder class
class HomeScreenArguments {
  final Key? key;
  final EventType eventType;
  HomeScreenArguments({this.key, required this.eventType});
}

/// DetailsScreen arguments holder class
class DetailsScreenArguments {
  final Key? key;
  final EventModel event;
  DetailsScreenArguments({this.key, required this.event});
}

/// BookPass arguments holder class
class BookPassArguments {
  final Key? key;
  final EventModel event;
  BookPassArguments({this.key, required this.event});
}

/// ConfirmBookingView arguments holder class
class ConfirmBookingViewArguments {
  final Key? key;
  final EventModel event;
  final List<Passes> passes;
  final double totalPrice;
  ConfirmBookingViewArguments(
      {this.key,
      required this.event,
      required this.passes,
      required this.totalPrice});
}

/// MakePayment arguments holder class
class MakePaymentArguments {
  final Key? key;
  final String type;
  final double amount;
  MakePaymentArguments({this.key, required this.type, required this.amount});
}

/// BookingHistory arguments holder class
class BookingHistoryArguments {
  final Key? key;
  final List<String> passes;
  BookingHistoryArguments({this.key, required this.passes});
}
