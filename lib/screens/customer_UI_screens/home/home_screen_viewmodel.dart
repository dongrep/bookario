import 'dart:developer';

import 'package:bookario/app.locator.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:stacked/stacked.dart';

class HomeScreenViewModel extends BaseViewModel {
  final FirebaseService _firebaseService = locator<FirebaseService>();

  int offset = 0;
  int limit = 10;
  List<Event> allEvents = [];
  List<Event> filteredEvents = [];
  List locations = [];
  List<String> allLocations = [];
  bool hasEvents = false;
  bool homeLoading = true;
  bool loadMore = false;
  bool loadingMore = false;
  bool filterApplied = false;
  String? selectedLocation;

  Future getAllEvents() async {
    try {
      setBusy(true);
      final List<Event> events = await _firebaseService.getEvents();
      allEvents.addAll(events);
      if (allEvents.isNotEmpty) {
        hasEvents = true;
      }
      filteredEvents = allEvents;
      setBusy(false);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      setBusy(false);
    }
  }

  // void addLocation(uniqueLocation) {
  //   allLocations.add(uniqueLocation['location']);
  // }

  Future<void> getAllLocations() async {
    try {
      allLocations = await _firebaseService.getAllLocations();
      setBusy(false);
    } catch (e) {
      setBusy(false);
      log(e.toString());
    }
  }

  void getEventsByLocation() {
    filteredEvents = allEvents
        .where((element) => element.location == selectedLocation)
        .toList();

    notifyListeners();
  }
}
