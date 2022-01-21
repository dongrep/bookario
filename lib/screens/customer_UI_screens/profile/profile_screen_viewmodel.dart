import 'dart:developer';

import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
import 'package:bookario/models/user_model.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileScreenViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> errors = [];

  String emailId = "";

  late UserModel user;

  Future populateDetails() async {
    user = _authenticationService.currentUser!;
    populateFields();
  }

  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();

  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();

  void populateFields() {
    user = _authenticationService.currentUser!;
    nameEditingController.text = user.name;
    ageEditingController.text = user.age;
    phoneNumberEditingController.text = user.phone;
    emailId = user.email;
  }

  Future<void> updateUserProfile() async {
    try {
      final UserModel newUser = UserModel(
          id: user.id,
          name: nameEditingController.text,
          phone: phoneNumberEditingController.text,
          email: user.email,
          age: ageEditingController.text,
          gender: user.gender,
          promoterId: user.promoterId,
          bookedPasses: user.bookedPasses);
      await _firebaseService.updateUser(newUser);
      refreshUser(user.id!);
      await _dialogService.showDialog(
          title: "Success", description: "Profile Updated!");
      _navigationService.back(result: true);
    } catch (e) {
      log('Error updating user profile: ');
      log(e.toString());
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }

  void logout() {
    _authenticationService.userLogout();
    _navigationService.clearStackAndShow(Routes.splashScreen);
  }

  Future navigateToEditScreen() async {
    await _navigationService.navigateTo(Routes.editProfile);
    await _authenticationService.checkUserLoggedIn();
    user = _authenticationService.currentUser!;
    notifyListeners();
  }

  Future becomeAPromoter() async {
    user = _authenticationService.currentUser!;
    try {
      final String promoterId =
          user.name.substring(0, 4) + randomBetween(1000, 9999).toString();
      final UserModel newUser = UserModel(
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        age: user.age,
        gender: user.gender,
        promoterId: promoterId,
        bookedPasses: user.bookedPasses,
      );
      await _firebaseService.updateUser(newUser);
      await _firebaseService.updatePromoterList(
        promoterId,
        newUser.id!,
        newUser.name,
      );
      await _dialogService.showDialog(
        title: "Success",
        description: "Profile Updated!",
      );
      refreshUser(newUser.id!);
    } catch (e) {
      log('Error updating user profile: $e');
    }
  }

  Future refreshUser(String userId) async {
    await _authenticationService.refreshUser(userId);
    populateDetails();
    notifyListeners();
  }
}
