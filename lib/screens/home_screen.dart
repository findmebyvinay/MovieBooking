// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:qflix/models/movie_model.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
//import 'package:qflix/screens/book_ticket/book_ticket_page.dart';
import 'package:qflix/movie/movie_page.dart';
//import 'booking_screen.dart';

class HomeScreen extends StatelessWidget {
  List movies=[
    'Boksi Ko Ghar',
    'Mansara',
    'kabbadi',
    'Solo Leveling'

  ];
 
  List movies2=[
    'kuroko basketball',
    "Django unchained",
    "Inception",
    "Your name",
    "Kung Fu Hustle"

  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: const Icon(
          Icons.sort,
          size: 32, 
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("QFlix",
        style: TextStyle(
          color: Colors.white60,
          fontSize: 24,
        ),),
        centerTitle: true,
        actions: const [
          Padding(padding:EdgeInsets.symmetric(
            horizontal:10),
            child: Row(
              children: [
               /* Icon(Icons.search,
                size: 28,),*/
                 SizedBox(
                  width: 5,
                ),
                /*Icon(
                  Icons.filter_alt_outlined,
                  size: 28,
                )*/
              ],
            ),)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Now Showing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: (){},
                        child:const Text("view all",
                        style: TextStyle(
                          color: Color(0xFFF7D300),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                          ),
                      )
                  ],
                ),
                ),
                SizedBox(
                  height: 390,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context,index){
                      return Padding(
                        padding:const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                   // builder:(context)=>MoviePage(movie:Movie(name:"${movies[index]}")),
                                    builder: (context) => MoviePage(movie:Movie(name: "${movies[index]}"), index: index),
                                    )
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  "assets/images/${movies[index]}.jpeg",
                                  height: 280,
                                  width: MediaQuery.of(context).size.width/2,
                                ),),
                            ),
                            const SizedBox(
                              height:10,
                              ),
                              Padding(
                                padding:const EdgeInsets.only(
                                  left:8,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(movies[index],
                                      style:const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                      ),
                                      ),
                                     const SizedBox(
                                        height: 4,
                                      ),
                                     const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Color(0xFFF7D300),
                                          ),
                                          Text("4.5",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFF7D300)
                                          ),),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_filled_rounded,
                                            color: Colors.white60,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("2h 59min",
                                          style: TextStyle(
                                            color: Colors.white60
                                          ),)
                                        ],
                                      )

                                    ],
                                  ), )
                          ],
                        ),);
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:const EdgeInsets.symmetric(
                    horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:const EdgeInsets.all(5),
                          decoration:const BoxDecoration(
                            color: Color(0xFF2F3236),
                            ),
                            child:const Text("COMMING SOON",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),),
                        ),
                        InkWell(
                          onTap: (){},
                          child:const Text("View All",
                          style: TextStyle(
                            color: Color(0xFFF7D300),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                          
                        )
                      ],
                    ), 
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context,index)
                      {return Padding(
                        padding:const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){},
                              child: ClipRRect(borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "assets/images/${movies2[index]}.jpeg",
                                fit: BoxFit.cover,
                                height: 200,
                                width: MediaQuery.of(context).size.width/3,
                              ),),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(padding:const EdgeInsets.only(
                              left: 8,
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movies2[index],
                                style:const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                                )
                              ],
                            ) ,)
                          ],
                        ),);

                      }
                    ),
                  )
          ],
        ),
        
      ),
    );
  }
}