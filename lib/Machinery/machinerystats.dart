import 'package:flutter/material.dart';

class MachineryStats extends StatefulWidget {
  const MachineryStats({super.key});

  @override
  State<MachineryStats> createState() => _MachineryStatsState();
}

class _MachineryStatsState extends State<MachineryStats> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Machinery stats"),
    );
  }
}
