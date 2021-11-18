import 'package:cloud_firestore/cloud_firestore.dart';

class EventPass {
  final String user;
  final Timestamp timeStamp;
  final List<Passes>? passes;
  final double total;
  final String passId;

  EventPass({
    required this.user,
    required this.timeStamp,
    this.passes,
    required this.total,
    required this.passId,
  });

  EventPass.fromJson(Map<String, dynamic> json, this.passId)
      : user = json['user'] as String,
        timeStamp = json['timeStamp'] as Timestamp,
        passes = (json['passes'] as List?)
            ?.map((dynamic e) => Passes.fromJson(e as Map<String, dynamic>))
            .toList(),
        total = double.parse(json['total'].toString());

  Map<String, dynamic> toJson() => {
        'user': user,
        'timeStamp': timeStamp,
        'passes': passes?.map((e) => e.toJson()).toList(),
        'total': total,
      };
}

class Passes {
  final String? entryType;
  final String? maleName;
  final int? maleAge;
  final String? maleGender;
  final String? femaleName;
  final int? femaleAge;
  final String? passType;
  final String? femaleGender;
  final String? name;
  final int? age;
  final String? gender;
  final double? passCost;

  Passes({
    this.entryType,
    this.maleName,
    this.maleAge,
    this.maleGender,
    this.femaleName,
    this.femaleAge,
    this.passType,
    this.femaleGender,
    this.passCost,
    this.name,
    this.age,
    this.gender,
  });

  Passes.fromJson(Map<String, dynamic> json)
      : entryType = json['entryType'] as String?,
        maleName = json['maleName'] as String?,
        maleAge = int.tryParse(json['maleAge'].toString()),
        maleGender = json['maleGender'] as String?,
        femaleName = json['femaleName'] as String?,
        femaleAge = int.tryParse(json['femaleAge'].toString()),
        passType = json['passType'] as String?,
        femaleGender = json['femaleGender'] as String?,
        name = json['name'] as String?,
        age = int.tryParse(json['age'].toString()),
        gender = json['gender'] as String?,
        passCost = double.parse(json['passCost'].toString());

  Map<String, dynamic> toJson() => {
        'entryType': entryType,
        'maleName': maleName,
        'maleAge': maleAge,
        'maleGender': maleGender,
        'femaleName': femaleName,
        'femaleAge': femaleAge,
        'passType': passType,
        'femaleGender': femaleGender,
        'passCost': passCost,
        'name': name,
        'age': age,
        'gender': gender
      };
}
