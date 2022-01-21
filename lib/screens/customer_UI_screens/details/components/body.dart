import 'dart:io';

import 'package:bookario/components/constants.dart';
import 'package:bookario/components/hovering_back_button.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/screens/customer_UI_screens/details/details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'club_description.dart';

class Body extends StatelessWidget {
  final EventModel event;

  const Body({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailsScreenViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.setEvent(event),
      viewModelBuilder: () => DetailsScreenViewModel(),
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Hero(
                          tag: event.id,
                          child: Image.network(
                            event.eventThumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () => viewModel.goBack(),
                      //   child: Container(
                      //     margin: const EdgeInsets.only(left: 12, top: 16),
                      //     height: 35,
                      //     width: 35,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20),
                      //       color: Colors.white54,
                      //     ),
                      //     child: const Padding(
                      //       padding: EdgeInsets.only(left: 8),
                      //       child: Center(
                      //         child: Icon(
                      //           Icons.arrow_back_ios,
                      //           size: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Container(height: 50, color: Colors.black),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        EventDescription(
                          event: event,
                          viewModel: viewModel,
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: kSecondaryColor,
                height: Platform.isIOS ? 80 : 60,
                child: InkWell(
                  onTap: event.remainingPasses > 0
                      ? () => viewModel.bookPass()
                      : null,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Book",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
