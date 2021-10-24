import 'package:bookario/app.locator.dart';
import 'package:bookario/components/networking.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeScreenViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  int offset = 0, limit = 10;
  List<dynamic> eventData = [], locations = [];
  List<String> allLocations = [];
  bool hasEvents = false,
      homeLoading = true,
      loadMore = false,
      loadingMore = false,
      filterApplied = false;
  String location = 'Magarpatta';

  getAllEvents() async {
    try {
      setBusy(true);
      // final response = await Networking.getData('events/get-all-events', {
      //   "limit": limit.toString(),
      //   "offset": offset.toString(),
      // });
      // if (response['data'].length > 0) {
      //   hasEvents = true;
      //   loadMore = true;
      //   loadingMore = false;
      //   eventData += response['data'];
      // } else {
      //   homeLoading = false;
      //   loadMore = false;
      // }

    } catch (e) {
      setBusy(false);
      print(e);
    }
  }

  // void addLocation(uniqueLocation) {
  //   allLocations.add(uniqueLocation['location']);
  // }

  getAllLocations() async {
    try {
      // final response =
      //     await Networking.getData('events/get-unique-locations', {});
      // if (response['data'].length > 0) {
      //   hasEvents = true;
      //   loadMore = true;
      //   loadingMore = false;
      //   locations = response['data'];
      //   for (int i = 0; i < locations.length; i++) {
      //     addLocation(locations[i]);
      //   }
      // } else {
      //   homeLoading = false;
      //   loadMore = false;
      // }
      setBusy(false);
    } catch (e) {
      setBusy(false);
      print(e);
    }
  }

  getEventsByLocation() async {
    hasEvents = false;

    try {
      // final response = await Networking.getData('events/get-event-by-location', {
      //   "location": location,
      //   "limit": limit.toString(),
      //   "offset": offset.toString(),
      // });
      // if (response['data'].length > 0) {
      //   if (!filterApplied) {
      //     filterApplied = true;
      //     hasEvents = true;
      //     loadMore = true;
      //     loadingMore = false;
      //     eventData = response['data'];
      //   } else {
      //     hasEvents = true;
      //     loadMore = true;
      //     loadingMore = false;
      //     eventData += response['data'];
      //   }
      // } else {
      //   hasEvents = true;
      //   loadMore = false;
      // }
    } catch (e) {
      print(e);
    }
  }
}
