import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonepePayment extends StatefulWidget {
  const PhonepePayment({Key? key}) : super(key: key);

  @override
  State<PhonepePayment> createState() => _PhonepePaymentState();
}

class _PhonepePaymentState extends State<PhonepePayment> {
  late String environmentValue;
  String appId = '';
  String merchantId = 'PGTESTPAYUAT';
  bool enableLogging = true;
  Object? result = '';
  String saltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399';
  String saltIndex = '1';
  String body = '';
  String callback = 'https://webhook.site/1ceb01bf-c66b-4189-93e8-d3b29c808700';
  String checksum = '';
  String packageName = '';
  String apiEndPoint = "/pg/v1/pay";
  bool isRequestInProgress = false;

  @override
  void initState() {
    environmentValue = 'SANDBOX';
    initPayment();
    super.initState();
  }

  void initPayment() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      });
    }).catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startTransaction() {
    if (isRequestInProgress) {
      return; // Avoid multiple requests
    }

    isRequestInProgress = true;
    PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
        .then((response) {
      setState(() {
        if (response != null) {
          String status = response['status'].toString();
          String error = response['error'].toString();
          if (status == 'SUCCESS') {
            result = "Flow Completed - Status: Success!";
          } else {
            result = "Flow Completed - Status: $status and Error: $error";
          }
        } else {
          result = "Flow Incomplete";
        }
      });
    }).catchError((error) {
      setState(() {
        result = "Error occurred during transaction: $error";
        print(result);
      });
    }).whenComplete(() {
      isRequestInProgress = false;
    });
  }

  void handleError(error) {
    setState(() {
      result = 'Error: $error';
    });
  }

  String generateChecksum(String base64body) {
    return sha256
            .convert(utf8.encode(base64body + apiEndPoint + saltKey))
            .toString() +
        '###$saltIndex';
  }

  String createRequestBody() {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": "t_5255",
      "merchantUserId": "MUID123",
      "amount": 1,
      "callbackUrl": callback,
      "mobileNumber": "9494741081",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64body = base64.encode(utf8.encode(json.encode(reqData)));
    print(base64body);
    return base64body;
  }

  @override
  Widget build(BuildContext context) {
    body = createRequestBody();
    checksum = generateChecksum(body);

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              child: Text("Pay Now"),
              onPressed: () {
                print("checksum:$checksum");
                print(body);
                startTransaction();
              },
            ),
          ),
          Text('$result')
        ],
      ),
    );
  }
}
