import 'package:flutter/material.dart';

class MachineryInventory extends StatefulWidget {
  const MachineryInventory({super.key});

  @override
  State<MachineryInventory> createState() => _MachineryInventoryState();
}

class _MachineryInventoryState extends State<MachineryInventory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Inventory"),
    );
  }
}
