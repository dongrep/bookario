import 'dart:convert';
import 'dart:developer';

import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/event_pass_model.dart';
import 'package:bookario/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _clubsCollectionReference =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference _eventsCollectionReference =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference _passesCollectionReference =
      FirebaseFirestore.instance.collection('passes');
  final CollectionReference _promotersCollectionReference =
      FirebaseFirestore.instance.collection('promoters');
  final CollectionReference _locationCollectionReference =
      FirebaseFirestore.instance.collection('locations');
  Future updateUser(
    UserModel user,
  ) async {
    try {
      await _usersCollectionReference.doc(user.id).set(
            user.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromJson(
        userData.data()! as Map<String, dynamic>,
        userData.id,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(
            user.toJson(),
          );
    } catch (e) {
      return e.toString();
    }
  }

  Future updatePromoterList(String promoterId, String userId) async {
    try {
      await _promotersCollectionReference.doc(promoterId).set(
          {"userId": userId, "promoterId": promoterId},
          SetOptions(merge: true));
    } catch (e) {
      log("Update Promoter List : $e");
    }
  }

  Future<List<Event>> getEvents() async {
    // try {
    final List<Event> _events = [];
    final QuerySnapshot result = await _eventsCollectionReference.get();
    final List<QueryDocumentSnapshot> allEventsData = result.docs;
    for (int i = 0; i < allEventsData.length; i++) {
      _events.add(
        Event.fromJson(
          allEventsData[i].data()! as Map<String, dynamic>,
          allEventsData[i].id,
        ),
      );
    }
    return _events;
    // } catch (e) {
    //   log(e.toString());
    //   return <Event>[];
    // }
  }

  Future<List<EventPass>> getPasses(String userId) async {
    final List<EventPass> eventPasses = [];
    try {
      final response = await _passesCollectionReference
          .where("user", isEqualTo: userId)
          .get();
      for (final data in response.docs) {
        final EventPass pass =
            EventPass.fromJson(data.data()! as Map<String, dynamic>, data.id);
        eventPasses.add(pass);
      }
      return eventPasses;
    } catch (e) {
      log("Get passes: $e");
      return [];
    }
  }

  Future<bool> bookPasses({
    required EventPass eventPass,
    required int maleCount,
    required int femaleCount,
    required int tableCount,
    required Event event,
    required UserModel user,
    String? promoterId,
  }) async {
    // try {

    final docRef = _passesCollectionReference.doc();
    await docRef.set(eventPass.toJson());

    //* Add pass to user profile
    Map<String, dynamic> data = {
      "bookedPasses": [...user.bookedPasses ?? [], docRef.id]
    };
    await _usersCollectionReference.doc(user.id).set(
          data,
          SetOptions(merge: true),
        );

    //* Add pass to event details
    data = {
      "bookedPasses": [...event.bookedPasses ?? [], docRef.id],
      "remainingPasses": event.remainingPasses - eventPass.passes!.length,
      "totalMale": event.totalMale + maleCount,
      "totalFemale": event.totalFemale + femaleCount,
      "totalTable": event.totalTable + tableCount,
      "passesBookedByPromoter": [
        {promoterId: maleCount + femaleCount + tableCount}
      ],
    };
    await _eventsCollectionReference.doc(event.id).set(
          data,
          SetOptions(merge: true),
        );

    return true;
    // } catch (e) {
    //   log(e.toString());
    //   return false;
    // }
  }

  Future<List<CouponModel>> getCouponsForEvent({String? eventId}) async {
    final List<CouponModel> coupons = [];
    final response = await _eventsCollectionReference
        .doc(eventId)
        .collection("coupons")
        .get();
    for (final doc in response.docs) {
      coupons.add(CouponModel.fromJson(doc.data()));
    }
    return coupons;
  }

  Future<List<String>> getAllLocations() async {
    final List<String> locations = [];
    final response = await _locationCollectionReference.get();
    final list = response.docs.first.data()! as Map<String, dynamic>;
    for (final loc in list["location"]) {
      locations.add(loc.toString());
    }
    return locations;
  }

  Future<String> getClubName(String clubId) async {
    final response = await _clubsCollectionReference.doc(clubId).get();
    final String clubName =
        (response.data()! as Map<String, dynamic>)['name'].toString();
    return clubName;
  }
}
