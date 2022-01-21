import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/age_form_field.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/name_form_field.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/pass_selection_dd.dart';
import 'package:flutter/material.dart';

class TablePassFormWidget extends StatelessWidget {
  const TablePassFormWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final BookPassViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(
        child: Text(
          "Book Table",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      NameFormField(
          viewModel: viewModel,
          nameController: viewModel.passEntry['name'] as TextEditingController),
      const SizedBox(
        height: 20,
      ),
      AgeFormField(
          viewModel: viewModel,
          ageController: viewModel.passEntry['age'] as TextEditingController),
      const SizedBox(
        height: 20,
      ),
      PassTypeSelectionDropDown(viewModel: viewModel),
    ]);
  }
}
