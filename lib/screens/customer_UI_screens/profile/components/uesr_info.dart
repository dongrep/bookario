import 'package:bookario/components/loading.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/profile/profile_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserDetails extends StatelessWidget {
  final TextStyle textStyle =
      const TextStyle(fontSize: 15, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileScreenViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.populateDetails(),
        viewModelBuilder: () => ProfileScreenViewModel(),
        builder: (context, viewModel, child) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            height: SizeConfig.screenHeight * 0.25,
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    Text(
                      "Phone no.",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    Text(
                      "Email ID",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    Text(
                      "Age",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    Text(
                      "Gender",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                if (viewModel.isBusy)
                  const Expanded(child: Loading())
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ":  ${viewModel.user.name}",
                        style: textStyle,
                      ),
                      Text(
                        ":  ${viewModel.user.phone}",
                        style: textStyle,
                      ),
                      Text(
                        ":  ${viewModel.user.email}",
                        style: textStyle,
                      ),
                      Text(
                        ":  ${viewModel.user.age} yrs",
                        style: textStyle,
                      ),
                      Text(
                        ":  ${viewModel.user.gender}",
                        style: textStyle,
                      ),
                    ],
                  ),
              ],
            ),
          );
        });
  }
}
