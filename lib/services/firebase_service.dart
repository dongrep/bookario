import 'dart:convert';
import 'dart:developer';

import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/event_pass_model.dart';
import 'package:bookario/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _eventsCollectionReference =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference _passesCollectionReference =
      FirebaseFirestore.instance.collection('passes');
  final CollectionReference _promotersCollectionReference =
      FirebaseFirestore.instance.collection('promoters');
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
    try {
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
    } catch (e) {
      log(e.toString());
      return <Event>[];
    }
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

  Future<bool> bookPasses(
      {required List<Passes> passes,
      required int maleCount,
      required int femaleCount,
      required int tableCount,
      required Event event,
      required UserModel user,
      required double total}) async {
    try {
      Map<String, dynamic> data;
      data = {
        "user": user.id!,
        "total": total,
        "passes": passes
            .map((e) => e.toJson()..removeWhere((key, value) => value == null))
            .toList(),
        "timeStamp": DateTime.now()
      };
      final docRef = _passesCollectionReference.doc();
      await docRef.set(data);

      //* Add pass to user profile
      data = {
        "bookedPasses": [...user.bookedPasses ?? [], docRef.id]
      };
      await _usersCollectionReference.doc(user.id).set(
            data,
            SetOptions(merge: true),
          );

      //* Add pass to event details
      data = {
        "bookedPasses": [...event.bookedPasses ?? [], docRef.id],
        "remainingPasses": event.remainingPasses - passes.length,
        "totalMale": event.totalMale + maleCount,
        "totalFemale": event.totalFemale + femaleCount,
        "totalTable": event.totalTable + tableCount,
      };
      await _eventsCollectionReference.doc(event.id).set(
            data,
            SetOptions(merge: true),
          );

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
