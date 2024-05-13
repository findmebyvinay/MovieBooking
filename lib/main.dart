//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qflix/ProductDetailsWidget.dart';
//import 'package:qflix/auth/auth_page.dart';
import 'package:qflix/cubit/movies_cubit.dart';
import 'package:qflix/firebase_options.dart';
//import 'screens/home_screen.dart';
//import 'screens/loginpage/login.dart';
import 'screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    BlocProvider(create:(context)=>MoviesCubit(),
    child:
    MyApp()
    )
    );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF212429),
   
      ),
      
      home:welcomescreen(),
      //HomeScreen(),
      );}
    /* FutureBuilder(
      // Check the authentication state in the future
      future:Future.value(FirebaseAuth.instance.currentUser),
      //FirebaseAuth.instance.currentUser,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        // If the future is still loading, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: CircularProgressIndicator());
        }
        // If the user is authenticated, show the HomeScreen
        if (snapshot.hasData) {
          return MaterialApp(debugShowCheckedModeBanner: false,
            home: HomeScreen());
        }
        // Otherwise, show the AuthPage
        return MaterialApp(debugShowCheckedModeBanner: false,
          home: AuthPage());
      },
    );
  }*/

      //const welcomescreen(),
      /*StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Check the user's authentication status
            User? user = snapshot.data;
            if (user == null) {
              // If the user is not logged in, show the Login page
              return Login();
            }
            // If the user is logged in, show the HomeScreen page
            return HomeScreen();
          }
          // Show a loading indicator while the connection state is not active
          return CircularProgressIndicator();
        },
      ),
    );}*/
      
      
    //);

  
 // );}*/
}