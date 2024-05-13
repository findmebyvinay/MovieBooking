import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({super.key,
  required this.controller,
  required this.hintText,
  required this.obscureText,  
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
               padding: EdgeInsets.symmetric(horizontal: 25),
               child: TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                 enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white
                  )
                 ),
                 focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey
                  ),
                 ),
                 fillColor: Colors.grey.shade200,
                 filled: true,
                 hintText: hintText,
                 

                ),
               ),);
  
  }}