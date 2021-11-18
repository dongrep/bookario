import 'package:bookario/screens/customer_UI_screens/bookings/book_pass.dart';
import 'package:bookario/screens/customer_UI_screens/details/details_screen.dart';
import 'package:bookario/screens/customer_UI_screens/history/booking_history.dart';
import 'package:bookario/screens/customer_UI_screens/home/home_screen.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/edit_profile.dart';
import 'package:bookario/screens/customer_UI_screens/profile/profile_screen.dart';
import 'package:bookario/screens/landing_view/landing_view.dart';
import 'package:bookario/screens/sign_in/sign_in_screen.dart';
import 'package:bookario/screens/sign_up/sign_up_screen.dart';
import 'package:bookario/screens/splash/splash_screen.dart';
import 'package:bookario/screens/startup/startup_view.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:bookario/services/local_storage_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: SplashScreen, path: "/splash_screen"),
    MaterialRoute(page: LandingView, path: "/landing-page"),

    //*Login flow
    MaterialRoute(page: SignInScreen, path: "/sign_in"),
    MaterialRoute(page: SignUpScreen, path: "/sign_up"),

    //*Home Screen flow
    MaterialRoute(page: HomeScreen, path: "/home"),
    MaterialRoute(page: DetailsScreen, path: "/event-details"),
    MaterialRoute(page: BookPass, path: "/book-pass"),

    //*Profile Screen flow
    MaterialRoute(page: ProfileScreen, path: "/my-profile"),
    MaterialRoute(page: EditProfile, path: "/edit-profile"),
    MaterialRoute(page: BookingHistory, path: "/booking-history"),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: LocalStorageService),
    LazySingleton(classType: FirebaseService),
    LazySingleton(classType: AuthenticationService),
  ],
)
class App {}
