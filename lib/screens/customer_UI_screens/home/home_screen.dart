import 'package:bookario/components/constants.dart';
import 'package:bookario/components/enum.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/home/components/all_event_list.dart';
import 'package:bookario/screens/customer_UI_screens/home/home_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatelessWidget {
  final EventType eventType;

  const HomeScreen({Key? key, required this.eventType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeScreenViewModel>.reactive(
        onModelReady: (viewModel) async {
          await viewModel.getAllEvents(eventType);
          await viewModel.getAllLocations();
        },
        viewModelBuilder: () => HomeScreenViewModel(),
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    "assets/images/onlylogo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text("Home"),
                actions: [
                  Container(
                    height: 32,
                    width: 32,
                    margin: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      onPressed: () {
                        filterSearchDialog(context, viewModel);
                      },
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(5)),
                    AllEventList(
                      viewModel: viewModel,
                    ),
                    SizedBox(height: getProportionateScreenWidth(10)),
                  ],
                ),
              ),
            ),
          );
        });
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
