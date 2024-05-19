//import 'dart:math';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:qflix/models/movie_model.dart';
//import 'package:qflix/screens/book_ticket/book_ticket_page.dart';
import 'package:qflix/screens/components/my_button.dart';
//import 'package:qflix/screens/components/my_textfield.dart';
//import 'package:qflix/screens/components/reg_button.dart';
//import 'package:qflix/screens/components/square_tile.dart';
import 'package:qflix/screens/loginpage/controller/login_controller.dart';
//import 'package:qflix/screens/loginpage/register_now.dart';
//import 'package:qflix/screens/ticket/ticket_page.dart';

//import '../../auth/auth_page.dart';
class RegisterNow extends StatefulWidget {
  final Function()? onTap;
   RegisterNow({super.key,required this.onTap});

  @override
  State<RegisterNow> createState() => _RegisterNowState();
}

class _RegisterNowState extends State<RegisterNow> {
    final  loginController=Get.put(LoginController());
    final confrimPasswordController=TextEditingController();
   // final passwordController=TextEditingController();

 // final logincontroller= LoginController();
   
     void signUserUp() async{
      showDialog(context: context,
       builder:(context)=>Center(
        child: CircularProgressIndicator(),
       ) );try{
       if(loginController.passwordController.text !=confrimPasswordController.text){
          Navigator.pop(context);
       displayMessage("password must be same !",context);
       
       }
        else{
           await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email:loginController.usernameController.text ,
           password:loginController.passwordController.text);
          
        }
      
        }
           on FirebaseAuthException catch(e){
                Navigator.pop(context);
              displayMessage(e.code,context);
           }
   }
   void displayMessage(String message, BuildContext context){
    showDialog(context: context,
     builder:(context)=> AlertDialog(
      title: Text(message),
     ) );
   }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Colors.white,
      body:SingleChildScrollView(
        child: SafeArea(
          child: GetBuilder<LoginController>(
            init: loginController,
            builder: (controller) {
              return Form(
                autovalidateMode:AutovalidateMode.onUserInteraction,
                key:controller.formKey,
                child: Center(
                  child: Column(
                  children: [
                 //   AuthPage(),
                     const SizedBox(
                      height: 20,  
                    ), 
                    
                   const Icon(Icons.lock,
                    size: 60,),
                    const Text('Register now to book your Tickets !',
                     style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                     ),),
                     const SizedBox(
                      height: 25,),
                     TextFormField(
                        obscureText: false,
                       // hintText: 'user Id',
                        
                        decoration:const InputDecoration(
                          prefix: Icon(Icons.mail),
                          border:OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 10,
                              color: Colors.white
                            )
                          ),
                          
                          hintText:' Email Id',
                      
                          
                        ),
                        controller: controller.usernameController,
                        validator: (value){
                          return controller.validateUserName(value!);
                        },
                      ),
                  
                   
                      
                     const SizedBox(height: 25,),
                
                
                      TextFormField(
                        controller:controller.passwordController,
                         obscuringCharacter:'*',
                         
                      //  hintText: 'password',
                        obscureText:controller.isHidden,
                        decoration: InputDecoration(
                           border:OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 10,
                              color: Colors.white
                            )),
                          hintText: 'enter your password',
                         prefixIcon: Icon(Icons.key),
                         
                         suffixIcon: IconButton(
                          onPressed: (){
                           controller.togglePasswordVisibility();
              
                            
                          }, icon: Icon(controller.isHidden==true ? Icons.visibility_off:Icons.visibility),
                         )
                      ),
                      validator: (value){
                        return controller.validatePassword(value!);
                      },
        
                      ),
                      const SizedBox(height: 25,),
                      TextFormField(
                        controller:confrimPasswordController,
                         obscuringCharacter:'*',
                         
                      //  hintText: 'password',
                        obscureText:controller.isHidden,
                        decoration: InputDecoration(
                           border:OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 10,
                              color: Colors.white
                            )),
                          hintText: 'confirm your password',
                         prefixIcon: Icon(Icons.key),
                         
                         suffixIcon: IconButton(
                          onPressed: (){
                           controller.togglePasswordVisibility();
              
                            
                          }, icon: Icon(controller.isHidden==true ? Icons.visibility_off:Icons.visibility),
                         )
                      ),
                      validator: (value){
                        return controller.validatePassword(value!);
                      },
        
                      ),
                     
                      const SizedBox(height: 25,),
                      MyButton(
                        text: 'SignUp',
                        onTap: (){
                        signUserUp();
                  
                        controller.submitForm();
                      // Navigator.push(context,
                        //  MaterialPageRoute(
                          //builder:(context)=>  BookTicketPage(movie:Movie(name:'$movies'),)));
                        })
                    ,
                    const SizedBox(
                      height: 50, 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(child: 
                           Divider(thickness: 0.5,
                       color: Colors.grey[400],))
                        ],
                      ),
                    ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal:10.0 ),
                       child: Text("Or",
                       style: TextStyle(
                        color: Colors.black,
                       ),),
                     ),
                
                   /* Expanded(child: 
                     Divider(thickness: 0.5,
                     color: Colors.grey[400],)),
                */             
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an Account ?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15
                        ),),
                         SizedBox(width: 5,),
                      GestureDetector(
                        onTap: widget.onTap,
                          child: Text('Sign In',
                          
                          style: TextStyle(
                            color: Color.fromARGB(255, 11, 110, 157),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            
                          ),),
                        )
                      ],
                    )
                  ],
                 
                  
                ),
                
                ),
              );
            }
          ),
          ),
      ), 
    
      
    );
  }
}