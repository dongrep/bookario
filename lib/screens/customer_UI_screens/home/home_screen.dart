import 'package:flutter/material.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Body(),
    );
  }
}
