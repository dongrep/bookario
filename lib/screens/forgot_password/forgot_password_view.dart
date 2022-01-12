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

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: email);
    return Scaffold(
      appBar: AppBar(title: const Text("ForgotPassword")),
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
                text: "Fogot",
                press: () async {
                  await locator<AuthenticationService>()
                      .resetPassword(emailController.text);
                }),
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
