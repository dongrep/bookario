import 'package:bookario/components/constants.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/couple_pass_form_widget.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/pass_details_form_widget.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/pass_type.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/components/table_pass_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BookPass extends StatelessWidget {
  final EventModel event;

  const BookPass({
    Key? key,
    required this.event,
  }) : super(key: key);

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
      onModelReady: (viewModel) => viewModel.updateDetails(
        event,
      ),
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
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            event.name,
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (viewModel.event.coupleEntry.isNotEmpty)
                          PassType(
                              type: "Couple Pass",
                              viewModel: viewModel,
                              passTypes: viewModel.event.coupleEntry),
                        if (viewModel.event.stagMaleEntry.isNotEmpty)
                          PassType(
                              type: "Male Stag Pass",
                              viewModel: viewModel,
                              passTypes: viewModel.event.stagMaleEntry,
                              isActive: viewModel.checkRatio()),
                        if (viewModel.event.stagFemaleEntry.isNotEmpty)
                          PassType(
                              type: "Female Stag Pass",
                              viewModel: viewModel,
                              passTypes: viewModel.event.stagFemaleEntry),
                        if (viewModel.event.tableOption.isNotEmpty)
                          PassType(
                              type: "Book Table",
                              viewModel: viewModel,
                              passTypes: viewModel.event.tableOption),
                        if (viewModel.event.remainingPasses > 0)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                if (viewModel.passType == passTypes.male)
                                  PassDetailsFormWidget(
                                      viewModel: viewModel, isMale: true),
                                if (viewModel.passType == passTypes.female)
                                  PassDetailsFormWidget(
                                    viewModel: viewModel,
                                  ),
                                if (viewModel.passType == passTypes.couple)
                                  CouplePassFormWidget(viewModel: viewModel),
                                if (viewModel.passType == passTypes.table)
                                  TablePassFormWidget(
                                    viewModel: viewModel,
                                  ),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        getAddedPassesList(viewModel, context),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
                if (MediaQuery.of(context).viewInsets.bottom == 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => viewModel.book(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          // width: 220,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: kPrimaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Total: ₹ ${viewModel.totalPrice}",
                                    style: const TextStyle(
                                        color: kSecondaryColor, fontSize: 18)),
                                const Icon(Icons.arrow_forward_ios_sharp,
                                    color: kSecondaryColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => BookPassViewModel(),
    );
  }

  Widget getAddedPassesList(BookPassViewModel viewModel, BuildContext context) {
    if (viewModel.passes.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const Text(
              "All Passes",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(
                viewModel.passes.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: kSecondaryColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((viewModel.passes[index].entryType)!
                                      .contains("Couple")) ...[
                                    Text(
                                      "${viewModel.passes[index].maleName},\tMale, \t${viewModel.passes[index].maleAge}",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                    Text(
                                      "${viewModel.passes[index].femaleName},\tFemale ,\t${viewModel.passes[index].femaleAge}",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ] else ...[
                                    Text(
                                      '${viewModel.passes[index].name}, ${viewModel.passes[index].age}',
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ],
                                  Text(
                                    "${viewModel.passes[index].entryType!}\n${viewModel.passes[index].passType!}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                viewModel.removePass(viewModel.passes[index]);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
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
}

class WhiteText extends StatelessWidget {
  const WhiteText({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }
}
