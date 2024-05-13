import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:qflix/models/movie_model.dart';
//import 'package:qflix/screens/book_ticket/book_ticket_page.dart';
import 'package:qflix/screens/components/my_button.dart';
//import 'package:qflix/screens/components/my_textfield.dart';
//import 'package:qflix/screens/components/reg_button.dart';
//import 'package:qflix/screens/components/square_tile.dart';
import 'package:qflix/screens/loginpage/controller/login_controller.dart';
//import 'package:qflix/screens/loginpage/register.dart';
//import 'package:qflix/screens/ticket/ticket_page.dart';

import '../../auth/auth_page.dart';
class Login extends StatefulWidget {
  final Function()? onTap;

   Login({super.key,required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
    final  logincontroller=Get.put(LoginController());

 // final logincontroller= LoginController();
   void signUserIn() async{
     showDialog(context: context,
       builder:(context)=>Center(
       // child: CircularProgressIndicator(),
       ) );
       try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:logincontroller.usernameController.text ,
           password:logincontroller.passwordController.text);
           //Navigator.pop(context);
       }on FirebaseAuthException catch(e){
        Navigator.pop(context);
        showError(e.code);
       }
           
   }
   void showError(String message){
    showDialog(context: context,
     builder:(context){return AlertDialog(
       title: Center(
        child: Text(message),
       ),
     );}
     );



   }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Colors.white,
      body:SingleChildScrollView(
        child: SafeArea(
          child: GetBuilder<LoginController>(
            init: logincontroller,
            builder: (controller) {
              return Form(
                autovalidateMode:AutovalidateMode.onUserInteraction,
                key:controller.formKey,
                child: Center(
                  child: Column(
                  children: [
                 //   AuthPage(),
                     const SizedBox(
                      height: 50,  
                    ), 
                    
                   const Icon(Icons.lock,
                    size: 60,),
                    const Text('Please sigin to book your seats!',
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
                          
                          hintText:' username',
                          label:Text('UserID'),
                          
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
                          label: Text('password'),
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
                     const Padding(
                        padding:EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Forgot Password ?',
                            style: TextStyle(
                              color: Colors.black,
                            ),),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25,),
                      MyButton(
                        text:"SignIn",
                        onTap: (){
                        
                        signUserIn();
                  
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
                       const Text('Not a Member ?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15
                        ),),
                       const  SizedBox(width: 5,),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text('Register now',
                          
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