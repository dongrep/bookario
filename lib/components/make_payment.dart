import 'package:bookario/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({Key? key, required this.type, required this.amount})
      : super(key: key);

  final String type;
  final double amount;

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  static const platform = MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Amount to paid : ",
                style: TextStyle(color: kSecondaryColor, fontSize: 18)),
            Text("₹ ${widget.amount}",
                style: TextStyle(color: kPrimaryColor, fontSize: 18)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ElevatedButton(
                onPressed: openCheckout,
                child: const Text('Pay'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(kSecondaryColor)),
              )
            ]),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future openCheckout() async {
    final options = {
      'key': 'rzp_test_Elyrg6ur1QnnR2',
      'amount': widget.amount * 100,
      'name': 'Bookario',
      'description': widget.type,
      // 'prefill': {'contact': '9623963699', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg:
            "Success! This event will now appear in the premium events section!",
        toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context, ["SUCCESS", response.paymentId!]);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: Payment proccess cancelled",
        toastLength: Toast.LENGTH_SHORT);
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
    // Navigator.pop(context, ["ERROR", response.message!]);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context, ["WALLET", response.walletName!]);
  }
}
