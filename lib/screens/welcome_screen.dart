import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'home_screen.dart';

class welcomescreen extends StatelessWidget {
  const welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
          image: AssetImage("assets/images/home.jpeg"),
          fit: BoxFit.cover,
          opacity: 0.4,),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('QFlix',
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 50,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,)
              ,),
              const SizedBox(
                height: 30,
              ),
              const Text("Grab your tickets now",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder:(context)=>HomeScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 25,),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7D300).withOpacity(0.9),
                       borderRadius:BorderRadius.circular(10),
                    ),
                    child: const Text('Watch Shows',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                ),
              )
          ],
        ),
      ),
    );
  }
}