import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatelessWidget {
  final int productId;
  final String productName;
  final double totalPrice;

  const ProductDetailsWidget({
    required this.productId,
    required this.productName,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product ID: $productId',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Product Name: $productName',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Total Price: Rs${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}