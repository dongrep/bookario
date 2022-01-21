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
  final List<PassTypeModel> passes;
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
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: passes.map<Widget>(
            (PassTypeModel pass) {
              return Card(
                color: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "${pass.type} : ₹ ${pass.entry} ",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            Text(
                              "(Cover ₹${pass.cover})",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
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

  String getPassType() {
    if (passName.contains("Couple")) {
      return "coupleEntry";
    } else if (passName.contains("Male Stag")) {
      return "stagMaleEntry";
    } else if (passName.contains("Female")) {
      return "stagFemaleEntry";
    } else {
      return "tableOption";
    }
  }
}
