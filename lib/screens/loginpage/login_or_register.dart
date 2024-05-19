import 'package:flutter/material.dart';
import 'package:qflix/screens/loginpage/login.dart';
import 'package:qflix/screens/loginpage/register_now.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => __LoginOrRegisterState();
}

class __LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
    @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? Login(onTap: togglePages)
        : RegisterNow(onTap: togglePages);
  }

  /*@override
  Widget build(BuildContext context) {
    if(showLoginPage){
    return Login(onTap: togglePages);
    }
    else{
      return
     RegisterNow(
    onTap:togglePages
    );}
  }*/
}