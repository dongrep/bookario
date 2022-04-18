import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage(
      {Key? key, required this.policyTitle, required this.policyDetails})
      : super(key: key);

  final String policyTitle;
  final String policyDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(policyTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Text(
            policyDetails,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
