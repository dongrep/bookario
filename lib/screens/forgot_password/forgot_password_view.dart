import 'package:bookario/app.locator.dart';
import 'package:bookario/components/constants.dart';
import 'package:bookario/components/custom_suffix_icon.dart';
import 'package:bookario/components/default_button.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/services/authentication_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key, required this.email}) : super(key: key);

  final String email;

  Future _confirmForgotPassword(BuildContext context, String email) {
    return showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            "Confirm?",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              splashColor: Colors.red[50],
              child: Text(
                "No",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
            MaterialButton(
              onPressed: () {
                locator<AuthenticationService>().resetPassword(email.trim());
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              splashColor: kPrimaryColor,
              child: Text(
                "Yes",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: email);
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            buildEmailFormField(context, emailController),
            const SizedBox(
              height: 20,
            ),
            DefaultButton(
              text: "Forgot",
              press: () async {
                await _confirmForgotPassword(context, emailController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailFormField(
      BuildContext context, TextEditingController emailController) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.go,
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
