import'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qflix/models/movie_model.dart';
import 'package:qflix/screens/book_ticket/book_ticket_page.dart';
//import 'package:qflix/screens/booking_screen.dart';
//import 'package:qflix/screens/home_screen.dart';
//import 'package:qflix/screens/loginpage/login.dart';
import 'package:qflix/screens/loginpage/login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return BookTicketPage(movie: Movie(name: ''));
          }
          else
          {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
