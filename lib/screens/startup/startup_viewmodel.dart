import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:bookario/services/local_storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future checkAuthentification() async {
    setBusy(true);
    await locator<LocalStorageService>().init();
    final bool isLoggedIn =
        await locator<AuthenticationService>().checkUserLoggedIn();

    if (isLoggedIn) {
      _navigationService.replaceWith(Routes.landingView);
    } else {
      _navigationService.clearStackAndShow(Routes.splashScreen);
    }

    setBusy(false);
  }
}
