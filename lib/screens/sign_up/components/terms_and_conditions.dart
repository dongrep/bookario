import 'package:bookario/constants/strings.dart';
import 'package:bookario/screens/customer_UI_screens/profile/components/policy_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../components/constants.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PolicyPage(
              policyDetails: tAndCPolicyDetails,
              policyTitle: "Terms And Conditions",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: "By continuing your confirm that you agree \nwith our ",
            style: const TextStyle(color: Colors.white),
            children: [
              TextSpan(
                text: "Term and Condition",
                style: const TextStyle(color: kSecondaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PolicyPage(
                              policyDetails: tAndCPolicyDetails,
                              policyTitle: "Terms And Conditions",
                            ),
                          ),
                        )
                      },
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
