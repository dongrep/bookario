import 'package:bookario/components/constants.dart';
import 'package:bookario/components/loading.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/home/home_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_club_card.dart';

class AllEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeScreenViewModel>.reactive(
      onModelReady: (viewModel) async {
        await viewModel.getAllEvents();
        await viewModel.getAllLocations();
      },
      builder: (context, viewModel, child) => Column(
        children: [
          if (viewModel.hasEvents)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Events in Pune",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 32,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.sort,
                        size: 20,
                      ),
                      onPressed: () {
                        filterSearchDialog(context, viewModel);
                      },
                    ),
                  )
                ],
              ),
            )
          else
            Container(),
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
                if (viewModel.loadMore)
                  viewModel.loadingMore
                      ? const Loading()
                      : MaterialButton(
                          onPressed: () {
                            viewModel.offset += viewModel.limit;
                            viewModel.loadingMore = true;

                            !viewModel.filterApplied
                                ? viewModel.getAllEvents()
                                : viewModel.getEventsByLocation();
                          },
                          splashColor: Theme.of(context).primaryColorLight,
                          child: const Text(
                            'load more',
                            style: TextStyle(color: Colors.white38),
                          ),
                        )
                else
                  Container(),
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
      ),
      viewModelBuilder: () => HomeScreenViewModel(),
    );
  }

  Future filterSearchDialog(
      BuildContext context, HomeScreenViewModel viewModel) {
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
          title: const Text('Filter by',
              style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          content: Row(
            children: [
              const Text('Location: ', style: TextStyle(color: Colors.white)),
              selectLocation(viewModel)
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              splashColor: Theme.of(context).primaryColorLight,
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 14, letterSpacing: .8, color: Colors.white),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.getEventsByLocation();
              },
              splashColor: Theme.of(context).primaryColorLight,
              color: kSecondaryColor,
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: .8,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Expanded selectLocation(HomeScreenViewModel viewModel) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: viewModel.selectedLocation,
        style: const TextStyle(color: Colors.white70),
        onChanged: (String? value) {
          viewModel.selectedLocation = value;
        },
        items: viewModel.allLocations
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: kSecondaryColor),
            ),
          );
        }).toList(),
        validator: (value) => value == null ? 'Select Location' : null,
        decoration: const InputDecoration(
          labelText: 'Select',
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }
}
