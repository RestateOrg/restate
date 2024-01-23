import 'package:flutter/material.dart';

class MaterialOrder extends StatefulWidget {
  const MaterialOrder({super.key});

  @override
  State<MaterialOrder> createState() => _MaterialOrderState();
}

class _MaterialOrderState extends State<MaterialOrder> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Material orders"),
    );
  }
}
