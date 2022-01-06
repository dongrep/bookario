import 'package:bookario/components/constants.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/screens/customer_UI_screens/details/details_screen_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'description_text.dart';

Color bodyTextColor = Colors.white;

class EventDescription extends StatelessWidget {
  const EventDescription({
    Key? key,
    required this.event,
    required this.viewModel,
  }) : super(key: key);

  final EventModel event;
  final DetailsScreenViewModel viewModel;

  Widget getTimeOfEvent(Timestamp dateTime) {
    final DateTime temp =
        DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch);
    return Text(
      "${temp.hour}:${temp.minute < 10 ? "0${temp.minute}" : temp.minute}",
      style: TextStyle(color: bodyTextColor, fontSize: 18),
    );
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
            fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
        Text(
          date.day.toString(),
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kSecondaryColor,
                  ),
                  child: Center(
                    child: getDateOfEvent(event.dateTime),
                  ),
                ),
                getTimeOfEvent(event.dateTime),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                          height: 0.9,
                        ),
                  ),
                  SelectableText(
                    "${viewModel.busy("clubName") ? "Club" : viewModel.clubName}, ${event.location}",
                    maxLines: 1,
                    style: TextStyle(color: bodyTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Text(
          "About the event",
          style: TextStyle(
              fontSize: 18,
              color: kSecondaryColor,
              fontWeight: FontWeight.bold),
        ),
        DescriptionTextWidget(text: event.desc),
      ],
    );
  }

  Future promoterError(BuildContext context, String errorMessage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: bodyTextColor),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              splashColor: Colors.red[50],
              child: Text(
                "Ok",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TextRow extends StatelessWidget {
  const TextRow({Key? key, required this.text1, required this.text2})
      : super(key: key);

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text1,
            style: const TextStyle(color: kSecondaryColor, fontSize: 18)),
        Text(text2, style: TextStyle(color: bodyTextColor, fontSize: 18))
      ],
    );
  }
}

class SpacingWidget extends StatelessWidget {
  const SpacingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        divider(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
