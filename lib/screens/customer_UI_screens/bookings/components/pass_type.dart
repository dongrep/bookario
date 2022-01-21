import 'package:bookario/components/constants.dart';
import 'package:bookario/components/size_config.dart';
import 'package:bookario/models/pass_type_model.dart';
import 'package:bookario/screens/customer_UI_screens/bookings/book_pass_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PassType extends StatelessWidget {
  const PassType(
      {Key? key,
      required this.type,
      required this.viewModel,
      this.isActive,
      required this.passTypes})
      : super(key: key);

  final String type;
  final BookPassViewModel viewModel;
  final List<PassTypeModel> passTypes;
  final bool? isActive;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: (isActive ?? true)
                ? kSecondaryColor
                : kSecondaryColor.withOpacity(0.5)),
        child: Column(
          children: [
            Row(
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
                                  "assets/icons/tickets.svg",
                                  height: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  type,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...[
                            for (int i = 0; i < passTypes.length; i++)
                              SizedBox(
                                width: getProportionateScreenWidth(300),
                                child: Text(
                                  viewModel.getPassType(passTypes[i]),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      viewModel.showPassDetailsForm(
                          type: type, isActive: isActive ?? true);
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
