import 'package:bookario/components/loading.dart';
import 'package:bookario/components/rich_text_row.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/screens/customer_UI_screens/history/booking_history_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingHistoryViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getBookingData(),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(5)),
                  if (viewModel.hasBookings)
                    Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                viewModel.eventPasses.length,
                                (index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    child: AnimatedCrossFade(
                                      crossFadeState:
                                          viewModel.isExpanded[index]
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      firstChild: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 5),
                                                    color:
                                                        const Color(0xFFd6d6d6)
                                                            .withOpacity(0.8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: viewModel
                                                                      .eventPasses[
                                                                          index]
                                                                      .passes![
                                                                          0]
                                                                      .entryType !=
                                                                  'Couple Entry'
                                                              ? TextSpan(
                                                                  text:
                                                                      "Entry Type: ${viewModel.eventPasses[index].passes![0].entryType!}\nBooked for:  ${viewModel.eventPasses[index].passes![0].name!}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            getProportionateScreenWidth(17),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                )
                                                              : TextSpan(
                                                                  text:
                                                                      'Entry Type: ${viewModel.eventPasses[index].passes![0].entryType!}\nBooked for: ${viewModel.eventPasses[index].passes![0].femaleName!}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            getProportionateScreenWidth(17),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                ),
                                                        ),
                                                        RichTextRow(
                                                          textLeft:
                                                              "Booked on:  ",
                                                          textRight: viewModel
                                                              .eventPasses[
                                                                  index]
                                                              .timeStamp
                                                              .toDate()
                                                              .toString(),
                                                        ),
                                                        RichTextRow(
                                                          textLeft: "Paid:  ",
                                                          textRight: viewModel
                                                              .eventPasses[
                                                                  index]
                                                              .total
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  viewModel.isExpanded[index]
                                                      ? viewModel.isExpanded[
                                                          index] = false
                                                      : viewModel.isExpanded[
                                                          index] = true;
                                                  viewModel.notifyListeners();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Icon(
                                                    viewModel.isExpanded[index]
                                                        ? Icons.arrow_drop_up
                                                        : Icons.arrow_drop_down,
                                                    size: 30,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      secondChild: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 5),
                                                    color:
                                                        const Color(0xFFd6d6d6)
                                                            .withOpacity(0.8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ...List.generate(
                                                            viewModel
                                                                .eventPasses[
                                                                    index]
                                                                .passes!
                                                                .length, (j) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 8),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "Entry Type: ${viewModel.eventPasses[index].passes![0].entryType!}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            getProportionateScreenWidth(16),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                ),
                                                                if (viewModel
                                                                        .eventPasses[
                                                                            index]
                                                                        .passes![
                                                                            j]
                                                                        .entryType !=
                                                                    'Couple Entry')
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        viewModel
                                                                            .eventPasses[index]
                                                                            .passes![j]
                                                                            .name!,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6!
                                                                            .copyWith(
                                                                              fontSize: getProportionateScreenWidth(16),
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        ', ${viewModel.eventPasses[index].passes![j].gender!}, ${viewModel.eventPasses[index].passes![j].age!}',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6!
                                                                            .copyWith(
                                                                              fontSize: getProportionateScreenWidth(13),
                                                                              color: Colors.black,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                else
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            viewModel.eventPasses[index].passes![j].femaleName!,
                                                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                                                                  fontSize: getProportionateScreenWidth(16),
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            ', ${viewModel.eventPasses[index].passes![j].femaleGender!}',
                                                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                                                                  fontSize: getProportionateScreenWidth(13),
                                                                                  color: Colors.black,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            ', ${viewModel.eventPasses[index].passes![j].femaleAge!}',
                                                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                                                                  fontSize: getProportionateScreenWidth(13),
                                                                                  color: Colors.black,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            viewModel.eventPasses[index].passes![j].maleName!,
                                                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                                                                  fontSize: getProportionateScreenWidth(16),
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            ', ${viewModel.eventPasses[index].passes![j].maleGender!}',
                                                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                                                                  fontSize: getProportionateScreenWidth(13),
                                                                                  color: Colors.black,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            ', ${viewModel.eventPasses[index].passes![j].maleAge!}',
                                                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                                                                  fontSize: getProportionateScreenWidth(13),
                                                                                  color: Colors.black,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "Pass Type: ${viewModel.eventPasses[index].passes![j].passType!}",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline6!
                                                                        .copyWith(
                                                                          fontSize:
                                                                              getProportionateScreenWidth(13),
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                        const SizedBox(
                                                            height: 10),
                                                        RichTextRow(
                                                          textLeft:
                                                              "Booked on:  ",
                                                          textRight: viewModel
                                                              .eventPasses[
                                                                  index]
                                                              .timeStamp
                                                              .toDate()
                                                              .toString(),
                                                        ),
                                                        RichTextRow(
                                                          textLeft: "Paid:  ₹",
                                                          textRight: viewModel
                                                              .eventPasses[
                                                                  index]
                                                              .total
                                                              .toString(),
                                                        ),
                                                        Container(
                                                          height: 200,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          width: SizeConfig
                                                              .screenWidth,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              QrImage(
                                                                data: viewModel
                                                                    .eventPasses[
                                                                        index]
                                                                    .passId,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                errorStateBuilder:
                                                                    (cxt, err) {
                                                                  return const Center(
                                                                    child: Text(
                                                                      "Uh oh! Something went wrong...",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  viewModel
                                                      .updateIsExpanded(index);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Icon(
                                                    viewModel.isExpanded[index]
                                                        ? Icons.arrow_drop_up
                                                        : Icons.arrow_drop_down,
                                                    size: 30,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: getProportionateScreenWidth(20)),
                            ],
                          ),
                        ),
                        // loadMore
                        //     ? loadingMore
                        //         ? Loading()
                        //         : MaterialButton(
                        //             onPressed: () {
                        //               setState(() {
                        //                 offset += limit;
                        //                 loadingMore = true;
                        //               });
                        //               getviewModel.eventPasses();
                        //             },
                        //             splashColor:
                        //                 Theme.of(context).primaryColorLight,
                        //             child: Text(
                        //               'load more',
                        //             ),
                        //           )
                        //     : Container(),
                      ],
                    )
                  else
                    viewModel.isBusy
                        ? const Loading()
                        : Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Your bookings will be available here\nwhen you book an event.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => BookingHistoryViewModel(),
    );
  }
}
