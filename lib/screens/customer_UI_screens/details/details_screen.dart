import 'package:bookario/components/constants.dart';
import 'package:bookario/models/event_model.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  final EventModel event;

  const DetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kPrimaryColor,
      body: Body(event: event),
    );
  }
}
