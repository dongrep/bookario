import 'package:bookario/components/constants.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/models/pass_type_model.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:flutter/material.dart';

class PassTypeSelectionDropDown extends StatelessWidget {
  const PassTypeSelectionDropDown({Key? key, required this.viewModel})
      : super(key: key);

  final BookPassViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PassTypeModel>(
      onTap: () => FocusScope.of(context).unfocus(),
      value: viewModel.selectedPass,
      dropdownColor: kSecondaryColor,
      style: const TextStyle(color: kPrimaryColor),
      onChanged: (PassTypeModel? value) {
        viewModel.updatePassEntrySelectedPass(value);
      },
      items: getDropDownItems(viewModel),
      validator: (value) => value == null ? 'Select Pass Type' : null,
      decoration: const InputDecoration(
        labelText: 'Pass Type',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  List<DropdownMenuItem<PassTypeModel>>? getDropDownItems(
    BookPassViewModel viewModel,
  ) {
    final List<DropdownMenuItem<PassTypeModel>> items = [];
    for (int i = 0; i < viewModel.applicablePasses!.length; i++) {
      items.add(
        DropdownMenuItem(
          value: viewModel.applicablePasses![i],
          child: SizedBox(
            width: getProportionateScreenWidth(280),
            child: Text(
              "(${i + 1}) ${viewModel.getPassType(viewModel.applicablePasses![i])}",
            ),
          ),
        ),
      );
    }
    return items;
  }
}
