import 'package:flutter/material.dart';

class MachineryOrders extends StatefulWidget {
  const MachineryOrders({super.key});

  @override
  State<MachineryOrders> createState() => _MachineryOrdersState();
}

class _MachineryOrdersState extends State<MachineryOrders> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Your orders"),
    );
  }
}
