import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  const ProductDetails({Key? key, required this.data, required this.type}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        children: [
          Text('Product Name: ${widget.data['machinery_name']}'),
        ],
      ),
    );
  }
}
