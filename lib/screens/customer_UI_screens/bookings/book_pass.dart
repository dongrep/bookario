import 'dart:developer';

import 'package:bookario/components/constants.dart';
import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/pass_type_model.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class BookPass extends StatelessWidget {
  final EventModel event;
  final String? promoterId;
  final CouponModel? coupon;
  const BookPass({Key? key, required this.event, this.promoterId, this.coupon})
      : super(key: key);

  Future confirmDiscard(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            "All added passes will get discarded. Do you still want to go back?",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              splashColor: Colors.red[50],
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
    return ViewModelBuilder<BookPassViewModel>.reactive(
      onModelReady: (viewModel) =>
          viewModel.updateDetails(event, promoterId, coupon),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Book'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => confirmDiscard(context),
              ),
            ),
            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        event.name,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Booking details:",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Price:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  "Rs.${viewModel.totalPrice}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total discount:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  "Rs.${viewModel.discount}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                            MaterialButton(
                              minWidth: double.infinity,
                              elevation: 2,
                              color: kSecondaryColor,
                              onPressed: () => viewModel.book(),
                              child: const Text("Proceed to Payment",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (viewModel.event.coupleEntry.isNotEmpty)
                      _passType(context, "Couple Pass", viewModel),
                    if (viewModel.event.stagMaleEntry.isNotEmpty &&
                        viewModel.checkRatio())
                      _passType(context, "Male Stag Pass", viewModel),
                    if (viewModel.event.stagFemaleEntry.isNotEmpty)
                      _passType(context, "Female Stag Pass", viewModel),
                    if (viewModel.event.tableOption.isNotEmpty)
                      _passType(context, "Book Table", viewModel),
                    if (viewModel.event.remainingPasses > 0)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            if (viewModel.passType == passTypes.male)
                              ...passFormWidget(viewModel, isMale: true),
                            if (viewModel.passType == passTypes.female)
                              ...passFormWidget(viewModel),
                            if (viewModel.passType == passTypes.couple) ...[
                              divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              const Center(
                                child: Text(
                                  "Book Couple Pass",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              divider(),
                              const SizedBox(
                                height: 20,
                              ),
                              const WhiteText(
                                text: "Male Entry",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              bookByNameFormField(
                                  viewModel,
                                  viewModel.passEntry['maleName']
                                      as TextEditingController),
                              const SizedBox(
                                height: 20,
                              ),
                              ageFormField(
                                  viewModel,
                                  viewModel.passEntry['maleAge']
                                      as TextEditingController),
                              const SizedBox(
                                height: 20,
                              ),
                              const WhiteText(text: "Female Entry"),
                              const SizedBox(
                                height: 20,
                              ),
                              bookByNameFormField(
                                  viewModel,
                                  viewModel.passEntry['femaleName']
                                      as TextEditingController),
                              const SizedBox(
                                height: 20,
                              ),
                              ageFormField(
                                  viewModel,
                                  viewModel.passEntry['femaleAge']
                                      as TextEditingController),
                              const SizedBox(
                                height: 20,
                              ),
                              passTypeDropDown(viewModel),
                            ],
                            if (viewModel.passType == passTypes.table) ...[
                              const Center(
                                child: Text(
                                  "Book Table",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              bookByNameFormField(
                                  viewModel,
                                  viewModel.passEntry['name']
                                      as TextEditingController),
                              const SizedBox(
                                height: 20,
                              ),
                              ageFormField(
                                  viewModel,
                                  viewModel.passEntry['age']
                                      as TextEditingController),
                              const SizedBox(
                                height: 20,
                              ),
                              passTypeDropDown(viewModel),
                            ],
                            if (viewModel.passType != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      viewModel.passType = null;
                                      viewModel.notifyListeners();
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      viewModel.addPass();
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: kSecondaryColor,
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    getDismissableList(viewModel, context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => BookPassViewModel(),
    );
  }

  List<Widget> passFormWidget(
    BookPassViewModel viewModel, {
    bool isMale = false,
  }) {
    return [
      Center(
        child: Text(
          "Book ${isMale ? "Male" : "Female"} Stag Pass",
          style: const TextStyle(fontSize: 18, color: Colors.white38),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      bookByNameFormField(
        viewModel,
        viewModel.passEntry['name'] as TextEditingController,
      ),
      const SizedBox(
        height: 20,
      ),
      ageFormField(
        viewModel,
        viewModel.passEntry['age'] as TextEditingController,
      ),
      const SizedBox(
        height: 20,
      ),
      passTypeDropDown(viewModel),
    ];
  }

  Widget getDismissableList(BookPassViewModel viewModel, BuildContext context) {
    if (viewModel.passes.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const Text(
              "All Passes",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white38,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(
                viewModel.passes.length,
                (index) => Dismissible(
                  key: Key(viewModel.passes[index].name ??
                      viewModel.passes[index].maleName.toString()),
                  onDismissed: (direction) {
                    viewModel.totalPrice -= double.parse(
                      viewModel.passes[index].passCost.toString(),
                    );
                    if ((viewModel.passes[index].entryType)!.contains("Male")) {
                      --viewModel.maleCount;
                    } else if ((viewModel.passes[index].entryType)!
                        .contains("Female")) {
                      --viewModel.femaleCount;
                    } else if ((viewModel.passes[index].entryType)!
                        .contains("Couple")) {
                      --viewModel.maleCount;
                      --viewModel.femaleCount;
                    } else {
                      --viewModel.tableCount;
                    }
                    log('couplesCount ${viewModel.couplesCount}, maleCount: ${viewModel.maleCount}, femaleCount: ${viewModel.femaleCount}');
                    viewModel.passes.removeAt(index);
                    const String action = "discarded";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("booking $action"),
                      ),
                    );
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                    child: ClipRRect(
                      child: (viewModel.passes[index].entryType)!
                              .contains("Couple")
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "${viewModel.passes[index].maleName},\tMale, \t${viewModel.passes[index].maleAge}",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white70),
                                    ),
                                    Text(
                                      "${viewModel.passes[index].femaleName},\tFemale ,\t${viewModel.passes[index].femaleAge}",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white70),
                                    ),
                                    Text(
                                      "Couple's Entry,\n${viewModel.passes[index].passType}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                Text(
                                                  ' Swipe left to discard this booking',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${viewModel.passes[index].name}, ${viewModel.passes[index].age}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        "${viewModel.passes[index].entryType!}\n${viewModel.passes[index].passType!}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[900],
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white70,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    ' Swipe left to discard this booking',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text('You have not added any passes yet');
    }
  }

  Widget _passType(
    BuildContext context,
    String type,
    BookPassViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 15),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Cash.svg",
                          height: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          type,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              viewModel.showPassDetailsForm(type);
            },
            icon: const Icon(
              Icons.add_circle,
              color: Colors.white38,
            ))
      ],
    );
  }

  TextFormField bookByNameFormField(
      BookPassViewModel viewModel, TextEditingController nameController) {
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

  TextFormField nameFormField(BookPassViewModel viewModel) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.name,
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
        labelText: "Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField ageFormField(
      BookPassViewModel viewModel, TextEditingController ageController) {
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

  Widget passTypeDropDown(
    BookPassViewModel viewModel,
  ) {
    return DropdownButtonFormField<PassType>(
      value: viewModel.selectedPass,
      dropdownColor: kSecondaryColor,
      style: const TextStyle(color: kPrimaryColor),
      onChanged: (PassType? value) {
        viewModel.selectedPass = value;
        viewModel.updatePassEntrySelectedPass();
      },
      items: getDropDownItems(viewModel),
      validator: (value) => value == null ? 'Select Pass Type' : null,
      decoration: const InputDecoration(
        labelText: 'Pass Type',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  List<DropdownMenuItem<PassType>>? getDropDownItems(
    BookPassViewModel viewModel,
  ) {
    final List<DropdownMenuItem<PassType>> items = [];
    for (int i = 0; i < viewModel.applicablePasses!.length; i++) {
      items.add(
        DropdownMenuItem(
          value: viewModel.applicablePasses![i],
          child: SizedBox(
            width: 300,
            child: Text(
              viewModel.getPassType(viewModel.applicablePasses![i]),
            ),
          ),
        ),
      );
    }
    return items;
  }
}

class WhiteText extends StatelessWidget {
  const WhiteText({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }
}
