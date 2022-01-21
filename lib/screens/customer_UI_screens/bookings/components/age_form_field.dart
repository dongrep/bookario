import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:flutter/material.dart';

class AgeFormField extends StatelessWidget {
  const AgeFormField({
    Key? key,
    required this.ageController,
    required this.viewModel,
  }) : super(key: key);

  final TextEditingController ageController;
  final BookPassViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.number,
      cursorColor: Colors.white70,
      controller: ageController,
      textInputAction: TextInputAction.go,
      onChanged: (value) {
        if (value.isNotEmpty) {
          viewModel.removeError(error: "Please Enter age");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          viewModel.addError(error: "Please Enter age");
          return "";
        } else if (int.tryParse(value) is! int) {
          viewModel.addError(error: "Please Enter valid value");
          return "";
        } else if (int.tryParse(value)! > 100 || int.tryParse(value)! < 13) {
          viewModel.addError(error: "Please Enter age");
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
