// ignore_for_file: file_names

import 'package:bookario/app.locator.dart';
import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/event_pass_model.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ConfirmBookingViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  late EventModel event;
  late String clubName;

  final FirebaseService _firebaseService = locator<FirebaseService>();

  List<Passes> passes = [];

  bool promoterIdValid = false;
  List<CouponModel> couponsForEvent = [];

  TextEditingController promoterId = TextEditingController();

  CouponModel? selectedCoupon;

  double totalPrice = 0.0;

  double discount = 0.0;

  void init(EventModel event, double totalPrice, List<Passes> passes) {
    this.event = event;
    this.totalPrice = totalPrice;
    this.passes = passes;
  }

  void updateFinalPrice() {
    if (selectedCoupon != null) {
      if (totalPrice > selectedCoupon!.minAmountRequired) {
        if (selectedCoupon!.percentOff != null) {
          discount = selectedCoupon!.percentOff! / 100 * totalPrice;

          discount = discount > selectedCoupon!.maxAmount
              ? selectedCoupon!.maxAmount
              : discount;
        } else {
          discount = selectedCoupon!.maxAmount;
        }
      }
    }
  }

  Future<void> updatePromoterIdValid({required bool value}) async {
    if (value) {
      promoterIdValid = value;
      await getCouponsForEvevnt();
      _navigationService.back();
      notifyListeners();
    } else {
      _dialogService.showDialog(title: "Promoter not found!");
      promoterId.clear();
    }
  }

  Future book() async {
    final response = await locator<DialogService>().showConfirmationDialog(
      title: "Confirm booking",
      description: "Confirm these passes?",
      cancelTitle: "No",
      confirmationTitle: "Confirm",
    );
    int maleCount = 0;
    int femaleCount = 0;
    int tableCount = 0;

    for (final pass in passes) {
      if (pass.passType!.contains("Couple")) {
        maleCount++;
        femaleCount++;
      } else if (pass.passType!.contains("Male")) {
        maleCount++;
      } else if (pass.passType!.contains("Female")) {
        femaleCount++;
      } else if (pass.passType!.contains("Table")) {
        tableCount++;
      }
    }

    if (response!.confirmed) {
      final EventPass eventPass = EventPass(
        eventName: event.name,
        eventId: event.id,
        user: _authenticationService.currentUser!.id!,
        timeStamp: Timestamp.now(),
        total: totalPrice - discount,
        passes: passes,
        promoterId: promoterId.text == "" ? null : promoterId.text,
      );
      final bool result = await _firebaseService.bookPasses(
        eventPass: eventPass,
        maleCount: maleCount,
        femaleCount: femaleCount,
        tableCount: tableCount,
        event: event,
        user: _authenticationService.currentUser!,
        coupon: selectedCoupon,
      );
      if (result) {
        locator<NavigationService>().back(result: true);
      }
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
    updateFinalPrice();
    notifyListeners();
  }
}
