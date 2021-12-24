import 'package:bookario/app.locator.dart';
import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DetailsScreenViewModel extends BaseViewModel {
  bool promoterIdValid = false;
  List<CouponModel> couponsForEvent = [];

  TextEditingController promoterId = TextEditingController();

  late Event event;
  late String clubName;

  final FirebaseService _firebaseService = locator<FirebaseService>();

  CouponModel? selectedCoupon;

  Future<void> setEvent(Event thisEvent) async {
    event = thisEvent;
    setBusyForObject("clubName", true);
    clubName = await _firebaseService.getClubName(event.clubId);
    setBusyForObject("clubName", false);
  }

  Future<void> updatePromoterIdValid({required bool value}) async {
    promoterIdValid = value;
    await getCouponsForEvevnt();
    locator<NavigationService>().back();
    notifyListeners();
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
}
