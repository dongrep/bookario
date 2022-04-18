import 'package:bookario/constants/strings.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/policy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CancellationPolicy extends StatefulWidget {
  const CancellationPolicy({
    Key? key,
  }) : super(key: key);

  @override
  _CancellationPolicyState createState() => _CancellationPolicyState();
}

class _CancellationPolicyState extends State<CancellationPolicy> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PolicyPage(
              policyDetails: cancellationPolicyDetails,
              policyTitle: "Cancellation Policy",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: const <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Cancellation Policy',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset("assets/icons/arrow_right.svg",
                  height: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
