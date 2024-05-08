import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayment extends StatefulWidget {
  const RazorPayment({super.key});

  @override
  State<RazorPayment> createState() => _RazorPaymentState();
}

class _RazorPaymentState extends State<RazorPayment> {
  var _razorpay = Razorpay();
  var options;
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    options = {
      'key': '<YOUR_KEY_HERE>',
      'amount': 100 * 100,
      'name': 'Restate',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '9494741081', 'email': 'restateinfo23@gmail.com'}
    };
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment has been successfull");
    print(response.paymentId);
    print(response.orderId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment has been failed");
    print(response.code);
    print(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet");
    print(response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          try {
            _razorpay.open(options);
          } catch (e) {
            print(e);
          }
        },
        child: Text('Pay Now'),
      ),
    ));
  }
}
