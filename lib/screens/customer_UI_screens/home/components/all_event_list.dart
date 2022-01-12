import 'package:bookario/components/loading.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/home/home_screen_viewmodel.dart';
import 'package:flutter/material.dart';

import 'home_club_card.dart';

class AllEventList extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  const AllEventList({Key? key, required this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (viewModel.hasEvents) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...List.generate(
              viewModel.filteredEvents.length,
              (index) {
                return EventCard(
                  event: viewModel.filteredEvents[index],
                );
              },
            ),
            SizedBox(width: getProportionateScreenWidth(10)),
          ],
        ),
      );
    } else {
      return viewModel.isBusy
          ? const Loading()
          : Container(
              alignment: Alignment.center,
              child: const Text(
                'No events listed yet.\n Please visit after sometime.',
                textAlign: TextAlign.center,
              ),
            );
    }
  }
}
