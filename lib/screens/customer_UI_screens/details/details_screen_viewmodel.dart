import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:bookario/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DetailsScreenViewModel extends BaseViewModel {
  bool promoterIdValid = false;
  List<CouponModel> couponsForEvent = [];

  TextEditingController promoterId = TextEditingController();

  late EventModel event;
  late String clubName;

  final FirebaseService _firebaseService = locator<FirebaseService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  CouponModel? selectedCoupon;

  Future<void> setEvent(EventModel thisEvent) async {
    event = thisEvent;
    setBusyForObject("clubName", true);
    clubName = await _firebaseService.getClubName(event.clubId);
    setBusyForObject("clubName", false);
  }

  Future<void> updatePromoterIdValid({required bool value}) async {
    if (value) {
      promoterIdValid = value;
      await getCouponsForEvevnt();
      locator<NavigationService>().back();
      notifyListeners();
    } else {
      locator<DialogService>().showDialog(title: "Promoter not found!");
      promoterId.clear();
    }
  }

  Future getCouponsForEvevnt() async {
    couponsForEvent =
        await _firebaseService.getCouponsForEvent(eventId: event.id);
  }

  void updateSelectedCoupon(CouponModel couponModel) {
    if (selectedCoupon == couponModel) {
      selectedCoupon = null;
    } else {
      selectedCoupon = couponModel;
    }
    notifyListeners();
  }

  bookPass() async {
    final response = await locator<NavigationService>().navigateTo(
      Routes.bookPass,
      arguments: BookPassArguments(
        event: event,
        promoterId: promoterId.text,
        coupon: selectedCoupon,
      ),
    );
    if (response as bool? ?? false) {
      refreshEvent();
    }
  }

  Future refreshEvent() async {
    promoterId.clear();
    locator<AuthenticationService>()
        .refreshUser(_localStorageService.getter("uid")!);
    event = await _firebaseService.getEvent(event.id);
    notifyListeners();
  }
}
