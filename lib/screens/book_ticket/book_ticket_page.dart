import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qflix/auth/auth_page.dart';
import 'package:qflix/cubit/movies_cubit.dart';
import 'package:qflix/models/movie_model.dart';
import 'package:qflix/screens/book_ticket/widgets/day_selector.dart';
import 'package:qflix/screens/book_ticket/widgets/screen.dart';
import 'package:qflix/screens/book_ticket/widgets/seat_selector.dart';
import 'package:qflix/screens/booking_screen.dart';
import 'package:qflix/widgets/glass_icon_button.dart';
import 'package:qflix/widgets/scaleup_animation.dart';

class BookTicketPage extends StatelessWidget {
  BookTicketPage({super.key, required this.movie});
  
   final Movie movie;
   final user=FirebaseAuth.instance.currentUser!;

   void signUserOut(){
    FirebaseAuth.instance.signOut();
   }
   
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesCubit(),
      child: BookTicketView(movie: movie),
    );
  }
}

class BookTicketView extends StatelessWidget {
  const BookTicketView({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    context.read<MoviesCubit>().loadSeats();
    return BlocListener<MoviesCubit, MoviesState>(
      listener: (context, state) {
        if (state.status.isBooked) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar
        (backgroundColor: Color.fromARGB(255, 16, 15, 15),
        elevation: 0,
        leading: Icon(Icons.star),
          actions: [
          // ignore: prefer_const_constructors
          IconButton(onPressed: signUserOut, icon:Icon(Icons.logout)),
          
        ]),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              _getHeader(context),
              DateDaySelector(
                onChanged: (value) => context.read<MoviesCubit>().loadSeats(),
              ),
              const SizedBox(height: 30),
              const Screen(),
              const SeatSelector(),
            ],
          ),
        ),
        bottomNavigationBar: const BuyButton(),
      ),
    );
  }

  Padding _getHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: movie.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  const TextSpan(
                    text: '\n9:00',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void signUserOut() {
     FirebaseAuth.instance.signOut();
  }
}

class BuyButton extends StatelessWidget {
  const BuyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleUpAnimation(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              // Calculate total price and number of selected seats
              final state = context.read<MoviesCubit>().state;
              final totalPrice = state.totalPrice;
              final totalSelected = state.totalSelected;

              // Generate unique productId and productName
              final productId = generateProductId();
              final productName = generateProductName(totalSelected);

              // Navigate to BookingScreen with parameters
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    
                    productId: productId,
                    productName: productName,
                    productPrice: totalPrice,
		               selectedSeat: totalSelected, 
                   totalPrice:totalPrice,
                  ),
                ),
              );

             /* Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingScreen()),
    );*/
            },
            //=> BookingScreen(),
            //context.read<MoviesCubit>().book(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            ),
            child: BlocBuilder<MoviesCubit, MoviesState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                      'Buy ${state.totalSelected > 0 ? '${state.totalSelected} tickets' : ''}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                     Text(
                      'Rs${state.totalPrice}',
                      style:const  TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
   // Function to generate a random productId
  String generateProductId() {
    return Random().nextInt(10000).toString();
  }

  // Function to generate productName based on the number of selected seats
  String generateProductName(int totalSelected) {
    return 'Movie Ticket $totalSelected';
  }
}


