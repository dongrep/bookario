import 'package:bookario/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../../components/size_config.dart';

class HelpAndSupportScreen extends StatefulWidget {
  @override
  _HelpAndSupportScreenState createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  FocusNode subjectFocusNode = FocusNode();
  FocusNode bodyFocusNode = FocusNode();

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController();
  final _recipientController = TextEditingController(
    text: '4techventures@gmail.com',
  );

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Email Sent';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  bool validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Help & Support"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Write to us:"),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  emailSubject(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  emailBody(),
                  SizedBox(height: getProportionateScreenHeight(25)),
                  DefaultButton(
                    text: "Send",
                    press: () async {
                      if (validateAndSave()) {
                        setState(() {
                          loading = true;
                        });
                        send();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField emailSubject() {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      controller: _subjectController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.go,
      focusNode: subjectFocusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter the subject";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Subject",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onFieldSubmitted: (value) {
        subjectFocusNode.unfocus();
        FocusScope.of(context).requestFocus(bodyFocusNode);
      },
    );
  }

  TextFormField emailBody() {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      controller: _bodyController,
      keyboardType: TextInputType.text,
      minLines: 1,
      maxLines: 10,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.done,
      focusNode: bodyFocusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email body cannot be empty";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Body",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onFieldSubmitted: (value) {
        bodyFocusNode.unfocus();
      },
    );
  }
}
