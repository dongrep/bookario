import 'dart:developer';

import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
import 'package:bookario/components/constants.dart';
import 'package:bookario/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';

import '../../../../components/size_config.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  final EventModel event;

  Widget getTimeOfEvent(Timestamp dateTime) {
    final DateTime temp =
        DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch);
    return Text(
        "${temp.hour}:${temp.minute < 10 ? "0${temp.minute}" : temp.minute}",
        style: const TextStyle(color: Colors.white));
  }

  Widget getDateOfEvent(Timestamp dateTime) {
    final formatter = DateFormat("MMM");
    final DateTime date = dateTime.toDate();
    return Column(
      children: [
        Text(
          formatter.format(date),
          style: const TextStyle(
            color: kPrimaryColor,
            // fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
        Text(
          date.day.toString(),
          style: const TextStyle(
            color: kPrimaryColor,
            // fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => locator<NavigationService>().navigateTo(
        Routes.detailsScreen,
        arguments: DetailsScreenArguments(event: event),
      ),
      child: SizedBox(
        width: SizeConfig.screenWidth * .96,
        height: getProportionateScreenWidth(200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              SizedBox(
                width: SizeConfig.screenWidth,
                child: Hero(
                  tag: event.id,
                  child: Image.network(
                    event.eventThumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: getProportionateScreenWidth(200),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      // const Color(0xFF343434).withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondaryColor,
                                    height: 0.9,
                                  ),
                        ),
                        Flexible(
                          child: getTimeOfEvent(event.dateTime),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Column(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kSecondaryColor,
                      ),
                      child: getDateOfEvent(event.dateTime),
                    ),
                    // getTimeOfEvent(event.dateTime),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
