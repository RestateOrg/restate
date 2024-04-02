import 'package:flutter/material.dart';
import 'package:restate/Builder/builderHome.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete({super.key});

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          Text(
            'Order Complete',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Thank you for shopping with us',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuilderHomeScreen(
                            initialSelectedIndex: 0,
                          )));
            },
            child: Text('Back to Home'),
          ),
        ],
      )),
    );
  }
}
