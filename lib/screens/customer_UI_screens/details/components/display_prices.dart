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
              return isTable
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${pass.type} : ",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              "₹ ${pass.cover + pass.entry}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                            if (pass.cover > 0.0)
                              Text(
                                " (Cover ₹${pass.cover})",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                          ],
                        ),
                        Text(
                          "Admits : ${pass.allowed}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          "${pass.type} : ",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "₹ ${pass.cover + pass.entry}",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (pass.cover > 0.0)
                          Text(
                            " (Cover ₹${pass.cover})",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                      ],
                    );
            },
          ).toList(),
        ),
      ],
    );
  }
}
