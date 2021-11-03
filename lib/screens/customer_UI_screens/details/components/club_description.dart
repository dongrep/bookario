import 'package:bookario/components/constants.dart';
import 'package:bookario/models/event_model.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/size_config.dart';
import 'all_prices.dart';
import 'description_text.dart';

class EventDescription extends StatelessWidget {
  EventDescription({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

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
              "Are you a promoter?",
              style: TextStyle(color: Colors.white70),
            ),
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
            "Enter your Promoter ID:",
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
                  // if (promoterCode.text.isNotEmpty) {
                  //   final response = await Networking.getData(
                  //       'promoters/get-promoter-coupon', {
                  //     'clubId': widget.clubData['clubId'].toString(),
                  //     'eventId': event['eventId'].toString(),
                  //     'promoterId': promoterCode.text.trim(),
                  //   });
                  //   if (response['success']) {
                  //     promoterCode.clear();
                  //     Navigator.pop(context);
                  //     showCoupons(context, response['data']);
                  //   } else {
                  //     Navigator.pop(context);
                  //     promoterError(context, response['message']);
                  //   }
                  // }
                } catch (e) {
                  print(e);
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
      controller: promoterCode,
      decoration: const InputDecoration(
        labelText: "Promoter ID",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
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
