import 'package:bookario/models/pass_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String clubId;
  final Timestamp dateTime;
  final String desc;
  final int maxPasses;
  final int maxTables;
  final String name;
  final int femaleRatio;
  final int maleRatio;
  final String eventThumbnail;
  final String location;
  final List<PassType> stagFemaleEntry;
  final List<PassType> stagMaleEntry;
  final List<PassType> coupleEntry;
  final List<PassType> tableOption;
  final int totalMale;
  final int totalFemale;
  final int totalTable;
  final List? bookedPasses;

  final int remainingPasses;

  Event({
    required this.id,
    required this.clubId,
    required this.dateTime,
    required this.desc,
    required this.maxPasses,
    required this.name,
    required this.femaleRatio,
    required this.maleRatio,
    required this.eventThumbnail,
    required this.location,
    required this.stagFemaleEntry,
    required this.stagMaleEntry,
    required this.coupleEntry,
    required this.tableOption,
    required this.remainingPasses,
    required this.maxTables,
    required this.totalMale,
    required this.totalFemale,
    required this.totalTable,
    this.bookedPasses,
  });

  factory Event.fromJson(Map<String, dynamic> json, String id) {
    final List<PassType> stagFemaleEntry = json['stagFemaleEntry'] != null
        ? List<PassType>.from(
            (json['stagFemaleEntry'] as List).map(
              (model) => PassType.fromJson(model as Map<String, dynamic>),
            ),
          )
        : [];
    final List<PassType> stagMaleEntry = json['stagMaleEntry'] != null
        ? List<PassType>.from(
            (json['stagMaleEntry'] as List).map(
              (model) => PassType.fromJson(model as Map<String, dynamic>),
            ),
          )
        : [];
    final List<PassType> coupleEntry = json['coupleEntry'] != null
        ? List<PassType>.from(
            (json['coupleEntry'] as List).map(
              (model) => PassType.fromJson(model as Map<String, dynamic>),
            ),
          )
        : [];

    final List<PassType> tableOption = json['tableOption'] != null
        ? List<PassType>.from(
            (json['tableOption'] as List).map(
              (model) => PassType.fromJson(model as Map<String, dynamic>),
            ),
          )
        : [];

    return Event(
      id: id,
      clubId: json['clubId'] as String,
      dateTime: json['dateTime'] as Timestamp,
      desc: json['desc'] as String,
      name: json['name'] as String,
      maxPasses: json['maxPasses'] as int,
      femaleRatio: json['femaleRatio'] as int,
      maleRatio: json['maleRatio'] as int,
      eventThumbnail: json['eventThumbnail'] as String,
      location: json['location'] as String,
      stagFemaleEntry: stagFemaleEntry,
      stagMaleEntry: stagMaleEntry,
      coupleEntry: coupleEntry,
      tableOption: tableOption,
      remainingPasses: json['remainingPasses'] as int,
      bookedPasses: json['bookedPasses'] as List,
      maxTables: json['maxTables'] as int,
      totalMale: json['totalMale'] as int,
      totalFemale: json['totalFemale'] as int,
      totalTable: json['totalTable'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> stagFemaleEntryJson =
        stagFemaleEntry.map((pass) => pass.toJson()).toList();
    final List<Map<String, dynamic>> stagMaleEntryJson =
        stagMaleEntry.map((pass) => pass.toJson()).toList();
    final List<Map<String, dynamic>> coupleEntryJson =
        coupleEntry.map((pass) => pass.toJson()).toList();
    final List<Map<String, dynamic>> tableOptionJson =
        tableOption.map((pass) => pass.toJson()).toList();
    return {
      "clubId": clubId,
      "dateTime": dateTime,
      "desc": desc,
      "name": name,
      "maxPasses": maxPasses,
      "femaleRatio": femaleRatio,
      "maleRatio": maleRatio,
      "eventThumbnail": eventThumbnail,
      "location": location,
      "stagFemaleEntry": stagFemaleEntryJson,
      "stagMaleEntry": stagMaleEntryJson,
      "coupleEntry": coupleEntryJson,
      "tableOption": tableOptionJson,
      "bookedPasses": bookedPasses,
      "remainingPasses": remainingPasses,
    };
  }
}
