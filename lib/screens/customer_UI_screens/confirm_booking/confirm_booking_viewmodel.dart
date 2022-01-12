// ignore_for_file: file_names

import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
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
    int maleCount = 0;
    int femaleCount = 0;
    int tableCount = 0;

    for (final pass in passes) {
      if (pass.entryType!.contains("Couple")) {
        maleCount++;
        femaleCount++;
      } else if (pass.entryType!.contains("Male")) {
        maleCount++;
      } else if (pass.entryType!.contains("Female")) {
        femaleCount++;
      } else if (pass.entryType!.contains("Table")) {
        tableCount++;
      }
    }
    final response = await locator<DialogService>().showConfirmationDialog(
      title: "Confirm booking",
      description: "Confirm these passes?",
      cancelTitle: "No",
      confirmationTitle: "Confirm",
    );

    if (response!.confirmed) {
      var paymentResponse;
      if (totalPrice - discount != 0) {
        paymentResponse = await _navigationService.navigateTo(
            Routes.makePayment,
            arguments: MakePaymentArguments(
                type: "Book passes", amount: totalPrice - discount));
      }
      if (paymentResponse?[0] == "SUCCESS" || totalPrice - discount == 0) {
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
          transactionId: paymentResponse?[1].toString() ?? "Free",
          coupon: selectedCoupon,
        );
        if (result) {
          locator<NavigationService>().clearStackAndShow(Routes.landingView);
        }
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
