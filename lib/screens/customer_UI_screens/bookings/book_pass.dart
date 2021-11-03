import 'dart:developer';

import 'package:bookario/components/constants.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/pass_type_model.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class BookPass extends StatelessWidget {
  final Event event;
  const BookPass({Key? key, required this.event}) : super(key: key);

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
      onModelReady: (viewModel) => viewModel.event = event,
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
                    if (viewModel.event.coupleEntry.isNotEmpty)
                      _passType(context, "Couple Pass", viewModel),
                    if (viewModel.event.stagMaleEntry.isNotEmpty &&
                        viewModel.checkRatio())
                      _passType(context, "Male Stag Pass", viewModel),
                    if (viewModel.event.stagFemaleEntry.isNotEmpty)
                      _passType(context, "Female Stag Pass", viewModel),
                    if (viewModel.event.tableOption.isNotEmpty)
                      _passType(context, "Book Table", viewModel),
                    const SizedBox(height: 50),
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
                              const Center(
                                child: Text(
                                  "Book Couple Pass",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Male Entry"),
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
                              const Text("Female Entry"),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () => viewModel.book(),
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
                  key: Key(viewModel.passes[index].toString()),
                  onDismissed: (direction) {
                    viewModel.totalPrice -= double.parse(
                      viewModel.passes[index]['passCost'].toString(),
                    );
                    if ((viewModel.passes[index]['entryType'] as String)
                        .contains("Male")) {
                      --viewModel.maleCount;
                    } else if ((viewModel.passes[index]['entryType'] as String)
                        .contains("Female")) {
                      --viewModel.femaleCount;
                    } else if ((viewModel.passes[index]['entryType'] as String)
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
                      child: (viewModel.passes[index]['entryType'] as String)
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
                                      "Couple's Entry,\n${viewModel.passes[index]['passType']}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${viewModel.passes[index]['maleName']},',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Male, ",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          viewModel.passes[index]['maleAge']
                                              .toString(),
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${viewModel.passes[index]['femaleName']},',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Female ,",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          viewModel.passes[index]['femaleAge']
                                              .toString(),
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ],
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
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${viewModel.passes[index]['entryType']},\n${viewModel.passes[index]['passType']}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${viewModel.passes[index]['name']},',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          viewModel.passes[index]['age']
                                              .toString(),
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ],
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
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  DropdownButtonFormField<PassType> passTypeDropDown(
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              viewModel.getPassType(viewModel.applicablePasses![i]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }
    return items;
  }

//   Expanded gender1FormField() {
//     return Expanded(
//       child: DropdownButtonFormField<PassType>(
//         style: TextStyle(color: kSecondaryColor),
//         value: _gender1,
//         onChanged: (String value) {
//           setState(() {
//             _gender1 = value;
//           });
//         },
//         items: ['Male', 'Female', 'Others']
//             .map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(
//               value,
//               style: TextStyle(color: kSecondaryColor),
//             ),
//           );
//         }).toList(),
//         validator: (value) => value == null ? 'Select Gender' : null,
//         decoration: InputDecoration(
//           labelText: 'Gender',
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         ),
//       ),
//     );
//   }

//   TextFormField name2FormField() {
//     return TextFormField(
//       style: TextStyle(color: Colors.white70),
//       keyboardType: TextInputType.name,
//       cursorColor: Colors.white70,
//       textInputAction: TextInputAction.go,
//       onSaved: (newValue) => name2 = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: "Name cannot be empty");
//         }
//         return;
//       },
//       validator: (value) {
//         if (value.isEmpty) {
//           addError(error: "Name cannot be empty");
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: "Name",
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       ),
//     );
//   }

//   Expanded age2FormField() {
//     return Expanded(
//       child: TextFormField(
//         style: TextStyle(color: Colors.white),
//         keyboardType: TextInputType.number,
//         cursorColor: Colors.white70,
//         textInputAction: TextInputAction.go,
//         onSaved: (newValue) => age2 = newValue,
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             removeError(error: "Please Enter age");
//           }
//           return;
//         },
//         validator: (value) {
//           if (value.isEmpty) {
//             addError(error: "Please Enter age");
//             return "";
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           labelText: "Age",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//         ),
//       ),
//     );
//   }

//   Expanded gender2FormField() {
//     return Expanded(
//       child: DropdownButtonFormField<String>(
//         value: _gender2,
//         onChanged: (String value) {
//           setState(() {
//             _gender2 = value;
//           });
//         },
//         items: ['Female', 'Male', 'Others']
//             .map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(
//               value,
//               style: TextStyle(color: kSecondaryColor),
//             ),
//           );
//         }).toList(),
//         validator: (value) => value == null ? 'Select Gender' : null,
//         decoration: InputDecoration(
//           labelText: 'Gender',
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         ),
//       ),
//     );
//   }

//   TextFormField stagNameFormField() {
//     return TextFormField(
//       style: TextStyle(color: Colors.white70),
//       keyboardType: TextInputType.name,
//       cursorColor: Colors.white70,
//       textInputAction: TextInputAction.go,
//       onSaved: (newValue) => stagName = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: "Name cannot be empty");
//         }
//         return;
//       },
//       validator: (value) {
//         if (value.isEmpty) {
//           addError(error: "Name cannot be empty");
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: "Name",
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       ),
//     );
//   }

//   Expanded stagAgeFormField() {
//     return Expanded(
//       child: TextFormField(
//         style: TextStyle(color: Colors.white),
//         keyboardType: TextInputType.number,
//         cursorColor: Colors.white70,
//         textInputAction: TextInputAction.go,
//         onSaved: (newValue) => stagAge = newValue,
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             removeError(error: "Please Enter age");
//           }
//           return;
//         },
//         validator: (value) {
//           if (value.isEmpty) {
//             addError(error: "Please Enter age");
//             return "";
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           labelText: "Age",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//         ),
//       ),
//     );
//   }

//   Expanded stagGenderFormField() {
//     return Expanded(
//       child: DropdownButtonFormField<String>(
//         value: _stagGender,
//         onChanged: (String value) {
//           setState(() {
//             _stagGender = value;
//           });
//         },
//         items: ['Male', 'Female', 'Others']
//             .map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(
//               value,
//             ),
//           );
//         }).toList(),
//         validator: (value) => value == null ? 'Select Gender' : null,
//         decoration: InputDecoration(
//           labelText: 'Gender',
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         ),
//       ),
//     );
//   }
// }

// class ListofEntryPrices extends StatelessWidget {
//   const ListofEntryPrices({
//     Key? key,
//     @required this.widget,
//     this.passType,
//   }) : super(key: key);

//   final Map widget;
//   final String passType;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(
//             top: 12,
//           ),
//           child: Row(
//             children: [
//               SvgPicture.asset(
//                 "assets/icons/Cash.svg",
//                 height: 12,
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 passType,
//                 style: TextStyle(fontSize: 17, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.entries
//               .map<Widget>(
//                 (e) => e.value.toString() == "Not Available"
//                     ? Container()
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 e.key + " : ",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               Text(
//                                 "₹ " + e.value.toString(),
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                           IconButton(
//                               icon: Icon(
//                                 Icons.add,
//                                 color: Colors.white70,
//                               ),
//                               onPressed: () {})
//                         ],
//                       ),
//               )
//               .toList(),
//         ),
//       ],
//     );
  // }
}
