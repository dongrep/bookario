import 'package:bookario/components/constants.dart';
import 'package:bookario/screens/customer_UI_screens/profile/profile_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BecomeAPromoterTile extends StatelessWidget {
  const BecomeAPromoterTile({Key? key, required this.viewModel})
      : super(key: key);

  final ProfileScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await viewModel.becomeAPromoter();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: const <Widget>[
                Icon(
                  Icons.person,
                  size: 16,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Become A Promoter',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                "assets/icons/arrow_right.svg",
                height: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
