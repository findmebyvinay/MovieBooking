import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LoginController extends GetxController{
   final usernameController = TextEditingController();
  final passwordController=TextEditingController();



 final GlobalKey<FormState> formKey= GlobalKey<FormState>();

 bool isHidden=true;
 @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
      super.dispose();
  }

  void togglePasswordVisibility(){
    isHidden=!isHidden;
    update();
  }

  String? validateUserName(String value){
    if (value == null ||value.isEmpty) return 'username Required';
      return null;
    
  }
   String? validatePassword(String value){
    if (value == null ||value.isEmpty) return 'Required password';
      return null;
    
  }

  void submitForm(){
   if(formKey.currentState?.validate()== false)
   return;
  }


}