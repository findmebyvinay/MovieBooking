import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagepath;
  const SquareTile({super.key,required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(imagepath),
      height: 40,
    );
  }
}