import 'dart:developer';

import 'package:bookario/components/constants.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/models/coupon_model.dart';
import 'package:bookario/models/event_model.dart';
import 'package:bookario/screens/customer_UI_screens/details/details_screen_viewmodel.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'all_prices.dart';
import 'description_text.dart';

class EventDescription extends StatelessWidget {
  EventDescription({
    Key? key,
    required this.event,
    required this.viewModel,
  }) : super(key: key);

  final Event event;
  final DetailsScreenViewModel viewModel;

  String getTimeOfEvent(Timestamp dateTime) {
    final DateTime temp =
        DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch);
    return "${temp.hour}:${temp.minute < 10 ? "0${temp.minute}" : temp.minute}";
  }

  String getDateOfEvent(Timestamp dateTime) {
    return "${dateTime.toDate().day}/${dateTime.toDate().month}/${dateTime.toDate().year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(5),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/Location point.svg",
                height: getProportionateScreenWidth(15),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: SelectableText(
                    event.location,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/clock.svg",
              height: getProportionateScreenWidth(14),
            ),
            Text(
              ' ${getTimeOfEvent(event.dateTime)}',
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 25,
          ),
          child: Text(
            "About the event",
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ),
        DescriptionTextWidget(text: event.desc),
        const Padding(
          padding: EdgeInsets.only(
            top: 25,
          ),
          child: Text(
            "Available Passes:",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AllPrices(event: event),
        const SizedBox(height: 20),
        SizedBox(
          width: SizeConfig.screenWidth,
          child: MaterialButton(
            color: Colors.grey[800],
            onPressed: () {
              promoterPopUp(context);
            },
            child: const Text(
              "Have a promoter code?",
              style: TextStyle(color: Colors.white70),
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
                    style: TextStyle(color: Colors.white),
                  ),
                  Column(
                    children: viewModel.couponsForEvent
                        .map(
                          (coupon) => InkWell(
                            onTap: () => viewModel.updateSelectedCoupon(coupon),
                            child: ListTile(
                              title: Card(
                                color: kSecondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: getCouponDetails(coupon),
                                ),
                              ),
                              trailing: viewModel.selectedCoupon == coupon
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          )
      ],
    );
  }

  Future promoterPopUp(BuildContext context) {
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
          content: promoterCodeFormField(),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                try {
                  if (event.promoters!.contains(viewModel.promoterId.text)) {
                    viewModel.updatePromoterIdValid(value: true);
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

  Future showCoupons(BuildContext context, List allCoupons) {
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
            "Coupons for this event: ",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(allCoupons.length, (index) {
                return CouponCard(allCoupons: allCoupons, index: index);
              })
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              splashColor: Colors.red[50],
              child: Text(
                "Ok",
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

  Future promoterError(BuildContext context, String errorMessage) {
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
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              splashColor: Colors.red[50],
              child: Text(
                "Ok",
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

  final promoterCode = TextEditingController();

  TextFormField promoterCodeFormField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.text,
      cursorColor: Colors.white70,
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

class CouponCard extends StatelessWidget {
  const CouponCard({
    Key? key,
    required this.allCoupons,
    this.index,
  }) : super(key: key);

  final List allCoupons;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFd6d6d6).withOpacity(0.8),
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${allCoupons[index!]['couponAmount']}% OFF',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                allCoupons[index!]['couponName'].toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Coupon code:\n${allCoupons[index!]['couponCode']}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () async {
                await FlutterClipboard.copy(
                  '${allCoupons[index!]['couponAmount']}% OFF\n${allCoupons[index!]['couponName']}\nCoupon code: ${allCoupons[index!]['couponCode']}',
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.copy,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
