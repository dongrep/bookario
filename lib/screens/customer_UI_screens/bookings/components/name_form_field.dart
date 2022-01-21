import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  const NameFormField({
    Key? key,
    required this.nameController,
    required this.viewModel,
  }) : super(key: key);

  final TextEditingController nameController;
  final BookPassViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.name,
      controller: nameController,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.go,
      onChanged: (value) {
        if (value.isNotEmpty) {
          viewModel.removeError(error: "Name cannot be empty");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          viewModel.addError(error: "Name cannot be empty");
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Booking by name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
