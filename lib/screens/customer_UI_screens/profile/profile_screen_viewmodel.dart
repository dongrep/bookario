import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
import 'package:bookario/models/user_model.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:flutter/material.dart';
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
    // final uid = await _localStorageService.getter('uid');
    user = _authenticationService.currentUser!;
    // populateFields();
  }

  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();

  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();

  void populateFields() {
    nameEditingController.text = user.name;
    ageEditingController.text = user.age;
    phoneNumberEditingController.text = user.phone;
    emailId = user.email;
  }

  Future<void> updateUserProfile() async {
    try {
      user = _authenticationService.currentUser!;
      final UserModel newUser = UserModel(
        id: user.id,
        name: nameEditingController.text,
        phone: phoneNumberEditingController.text,
        email: user.email,
        age: ageEditingController.text,
        gender: user.gender,
      );
      _firebaseService.updateUser(newUser);
      await _dialogService.showDialog(
          title: "Success", description: "Profile Updated!");
      _navigationService.back(result: true);
    } catch (e) {
      print('Error updating user profile: ');
      print(e);
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
}
