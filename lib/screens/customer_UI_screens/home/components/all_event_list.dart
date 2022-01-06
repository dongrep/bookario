import 'package:bookario/components/constants.dart';
import 'package:bookario/components/loading.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/home/home_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_club_card.dart';

class AllEventList extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  const AllEventList({Key? key, required this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenWidth(10)),
        if (viewModel.hasEvents)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
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
              ),
            ],
          )
        else
          viewModel.isBusy
              ? const Loading()
              : Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'No events listed yet.\n Please visit after sometime.',
                    textAlign: TextAlign.center,
                  ),
                ),
      ],
    );
  }
}
