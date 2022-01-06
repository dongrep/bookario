import 'dart:developer';

import 'package:bookario/components/constants.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/models/event_pass_model.dart';
import 'package:bookario/screens/customer_UI_screens/confirm_booking/confirm_booking_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConfirmBookingView extends StatelessWidget {
  const ConfirmBookingView(
      {Key? key,
      required this.event,
      required this.passes,
      required this.totalPrice})
      : super(key: key);

  final EventModel event;
  final List<Passes> passes;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmBookingViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.init(event, totalPrice, passes),
      builder: (BuildContext context, viewModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Booking Summary"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
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
                                "Rs.${viewModel.totalPrice - viewModel.discount}",
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Enter a promoter code for coupons",
                    style: TextStyle(
                      fontSize: 18,
                      color: kSecondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (viewModel.promoterIdValid)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          viewModel.promoterId.text,
                          style: const TextStyle(color: Colors.white),
                        ),
                        InkWell(
                            onTap: () => promoterPopUp(context, viewModel),
                            child:
                                const Icon(Icons.close, color: Colors.white)),
                      ],
                    )
                  else
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: MaterialButton(
                        color: Colors.grey[600],
                        onPressed: () {
                          promoterPopUp(context, viewModel);
                        },
                        child: const Text(
                          "Have a promoter code?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  if (viewModel.promoterIdValid)
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          if (viewModel.couponsForEvent.isNotEmpty) ...[
                            const Text(
                              "Coupons for this event: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Column(
                              children: viewModel.couponsForEvent
                                  .map(
                                    (coupon) => InkWell(
                                      onTap: () => viewModel
                                          .updateSelectedCoupon(coupon),
                                      child: Card(
                                        color: kSecondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              getCouponDetails(coupon),
                                              if (viewModel.selectedCoupon ==
                                                  coupon)
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  padding: EdgeInsets.all(2),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ConfirmBookingViewModel(),
    );
  }

  Future promoterPopUp(
      BuildContext context, ConfirmBookingViewModel viewModel) {
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
            "Enter Promoter ID:",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: Colors.white),
          ),
          content: promoterCodeFormField(viewModel),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                try {
                  if (event.promoters!.contains(viewModel.promoterId.text)) {
                    viewModel.updatePromoterIdValid(value: true);
                  } else {
                    viewModel.updatePromoterIdValid(value: false);
                  }
                } catch (e) {
                  log(e.toString());
                }
              },
              splashColor: Colors.red[50],
              child: Text(
                "Get Coupons",
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

  TextFormField promoterCodeFormField(ConfirmBookingViewModel viewModel) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.text,
      cursorColor: Colors.white,
      textInputAction: TextInputAction.done,
      controller: viewModel.promoterId,
      decoration: const InputDecoration(
        labelText: "Promoter ID",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Text whiteTextField18(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontSize: 18));
  }

  Text whiteTextField(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontSize: 12));
  }

  Column getCouponDetails(CouponModel coupon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (coupon.percentOff != null) ...[
          whiteTextField18("Coupon type: Percent"),
          whiteTextField(
              "Percent off: ${coupon.percentOff}%, Max discount: Rs.${coupon.maxAmount},"),
          whiteTextField(
            "Min amount required: Rs.${coupon.minAmountRequired}",
          ),
        ] else ...[
          whiteTextField18("Coupon type: Flat off"),
          whiteTextField("Max discount: Rs.${coupon.maxAmount},"),
          whiteTextField(
            "Min amount required: Rs.${coupon.minAmountRequired}",
          ),
        ]
      ],
    );
  }
}
