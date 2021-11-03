import 'dart:convert';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/pass_type_model.dart';
import 'package:flutter/material.dart';

import 'display_prices.dart';

class AllPrices extends StatelessWidget {
  final Event event;

  const AllPrices({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (event.coupleEntry.isNotEmpty)
          ListofEntryPrices(
            passes: event.coupleEntry,
            passName: "Couple Stag Entry",
          ),
        if (event.stagMaleEntry.isNotEmpty)
          ListofEntryPrices(
            passes: event.stagMaleEntry,
            passName: "Male Stag Entry",
          ),
        if (event.stagFemaleEntry.isNotEmpty)
          ListofEntryPrices(
            passes: event.stagFemaleEntry,
            passName: "Female Stag Entry",
          ),
        if (event.tableOption.isNotEmpty)
          ListofEntryPrices(
            passes: event.tableOption,
            passName: "Book Table",
            isTable: true,
          )
      ],
    );
  }
}
