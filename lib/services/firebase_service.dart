import 'dart:developer';

import 'package:bookario/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future updateUser(
    UserModel user,
  ) async {
    try {
      await _usersCollectionReference.doc(user.id).set(
        {
          'name': user.name,
          'phone': user.phone,
          'age': user.age,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final userData = await _usersCollectionReference.doc(uid).get();
      log(userData.data().toString());
      return UserModel.fromJson(
        userData.data()! as Map<String, dynamic>,
        userData.id,
      );
    } catch (e) {
      print(e.toString());
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
}
