import 'package:bookario/components/constants.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/models/pass_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListofEntryPrices extends StatelessWidget {
  const ListofEntryPrices({
    Key? key,
    required this.passes,
    required this.passName,
    this.isTable = false,
  }) : super(key: key);

  final bool isTable;
  final List<PassType> passes;
  final String passName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenWidth(10),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/Cash.svg",
                height: getProportionateScreenWidth(10),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                passName,
                style: const TextStyle(fontSize: 17, color: Colors.white38),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: passes.map<Widget>(
            (PassType pass) {
              return Card(
                color: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${pass.type} : ",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "₹ ${pass.cover + pass.entry}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          if (pass.cover > 0.0)
                            Text(
                              " (Cover ₹${pass.cover})",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                        ],
                      ),
                      if (isTable)
                        Text(
                          "Admits : ${pass.allowed}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
