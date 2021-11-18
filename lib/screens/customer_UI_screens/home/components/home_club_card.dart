import 'dart:developer';

import 'package:bookario/app.locator.dart';
import 'package:bookario/app.router.dart';
import 'package:bookario/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../components/size_config.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * .96,
      height: getProportionateScreenWidth(200),
      child: GestureDetector(
        onTap: () => locator<NavigationService>().navigateTo(
          Routes.detailsScreen,
          arguments: DetailsScreenArguments(event: event),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFF343434).withOpacity(0.3),
                          const Color(0xFF343434).withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Hero(
                      tag: event.id,
                      child: Image.network(
                        event.eventThumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  child: SizedBox(
                    width: SizeConfig.screenWidth * 0.96,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF343434).withOpacity(0.8),
                            const Color(0xFF343434).withOpacity(0.4),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: event.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'on ${getDateOfEvent(event.dateTime)}',
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  'Time: ${getTimeOfEvent(event.dateTime)}',
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTimeOfEvent(Timestamp dateTime) {
    final DateTime temp =
        DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch);
    return "${temp.hour}:${temp.minute < 10 ? "0${temp.minute}" : temp.minute}";
  }

  String getDateOfEvent(Timestamp dateTime) {
    return "${dateTime.toDate().day}/${dateTime.toDate().month}/${dateTime.toDate().year}";
  }
}
