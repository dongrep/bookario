// ignore_for_file: prefer_const_constructors

import 'package:bookario/components/constants.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/contact_tile.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/logout_tile.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/uesr_info.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/view_bookings_tile.dart';
import 'package:bookario/screens/customer_UI_screens/profile/profile_screen_viewmodel.dart';
import 'package:flutter/material.dart';

import 'become_a_promoter_tile.dart';

class Body extends StatelessWidget {
  final ProfileScreenViewModel viewModel;

  const Body({Key? key, required this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserDetails(),
          divider(),
          ViewBookings(user: viewModel.user),
          divider(),
          const ContactTile(),
          divider(),
          if (viewModel.user.promoterId == null) ...[
            const BecomeAPromoterTile(),
            divider(),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        size: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Promoter ID: ${viewModel.user.promoterId}',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          divider(),
          LogoutTile(),
          divider(),
        ],
      ),
    );
  }
}
