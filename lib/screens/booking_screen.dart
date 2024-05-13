

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qflix/ProductDetailsWidget.dart';
import 'package:qflix/cubit/movies_cubit.dart';
//import 'esewa_flutter_sdk.dart';

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:qflix/models/seats_model.dart';




Future<void> savePaymentData(
    String productId, String productName, String message) async {
  try {
    // Get a reference to the Firestore collection
    CollectionReference paymentsCollection =
        FirebaseFirestore.instance.collection('payments');

    // Create a new document with the payment data
    await paymentsCollection.add({
      'productId': productId,
      'productName': productName,
      'message': message,
      'timestamp': Timestamp.now(),
      'seatLabel':selectedSeats
    });

    print('Payment data saved successfully');
  } catch (e) {
    print('Error saving payment data: $e');
  }
}

class BookingScreen extends StatefulWidget {
  //String movie;
  final String productId;
  final String productName;
  final int totalPrice;
  final int selectedSeat;

  BookingScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.totalPrice,
    required this.selectedSeat,
    required int productPrice,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  
  Widget build(BuildContext context) {
    validatePayment(context);
    return Scaffold(
      
    body: FutureBuilder(future: Future.delayed(Duration(seconds: 5)),

      builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());}
            else{
        return Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Center(
          child:Column(
            children: [
              SizedBox(height: 200,),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)
                ),
                padding:EdgeInsets.all(20),
                child:Center(child: const Text('Thankyou for Booking!',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),)
                ),
                /*ProductDetailsWidget(
                  productId:1,
                  productName:'movie',
                  totalPrice:300),*/
                  ),
                  SizedBox(height: 50,),
                   
            ElevatedButton(
              onPressed:(){
              Navigator.pop(context);
              },
                child: Text('Return Back'),
             ),
            ],
          ),
        
        ),
        
        /*child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              ProductDetailsWidget(productId:1,
               productName:'movie',
                totalPrice:300),
              Icon(Icons.movie_creation,size:200,color: Color.fromARGB(255, 0, 0, 0),),
              Text(
                '........',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){
              Navigator.pop(context);
              },
                child: Text('Return Back'),
             ),
            ],
          ),
        ),
          ),  */
        );
      }}
    ));
  }

  void validatePayment(BuildContext context) {
//Yeha raheko ni Esewa le testing ko lagi provide gareko wala ho clientId rw secretId.
 //context.read<MoviesCubit>().selectSeat(13);

    final esewaConfig = EsewaConfig(
      environment: Environment.test,
      clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
      secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
    );

    int productPrice = (widget.totalPrice / widget.selectedSeat).round();

    //EsewaFlutterSdk lai call gareko payment validate garna
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: esewaConfig,
        esewaPayment: EsewaPayment(
          productId: widget.productId,
          productName: widget.productName,
          productPrice: widget.totalPrice.toString(),
          callbackUrl: '',
        ),
        onPaymentSuccess: (result) async {
          // payment is successful
          print(result.productId);
          print(result.productName);
          print(result.message);
             List<int> selectedSeats = context.read<MoviesCubit>().state.selected;

              List<int>? seatLabel;
  if (result.totalAmount != null && result.totalAmount is List<int>) {
    seatLabel = result.totalAmount as List<int>;
  } else {
    // Use the selectedSeats list from the MoviesCubit state
    seatLabel = selectedSeats;
  }
              context.read<MoviesCubit>().book(
                result.productId,
                result.productName,
                result.message,
                seatLabel, // Pass the selectedSeats list
              );
    //context.read<MoviesCubit>().state.selected;
   // context.read<MoviesCubit>().state.allBookedSeats;
   


// UI update gara or process order gara redirect garerw arko
        // Get the seatLabel from the result
       /*List<int> seatLabel;
        if (result.totalAmount is List<int>) {
          seatLabel = result.totalAmount as List<int>;
        } else {
          // Handle the case where totalAmount is not a List<int>
          print('Invalid data type for totalAmount');
          seatLabel = context.read<MoviesCubit>().state.selected;
        }*/

          // Book the selected seats after successful payment
          //context
            //  .read<MoviesCubit>()
             // .book(result.productId, result.productName, result.message,selectedSeats);

               _showPaymentSuccessDialog(context);

          //  Navigator.of(context).popUntil((route) => route.isFirst);
        },
        onPaymentFailure: (error) async {
          //payment fails
          print(error);
// Payment failed or incomplete huda handle gara
        },
        onPaymentCancellation: (reason) async {
          //payment canceled
          print(reason);
        },
       // onActivityFinished:(result)aysnc{}
      );
    } on Exception catch (e) {
      debugPrint("EXCEPTION : ${e.toString()}");
    }
  }
  void _showPaymentSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds:3), () {
        Navigator.of(context).pop();
      });

      return AlertDialog(
        title: Text('Payment'),
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            ),
            SizedBox(width: 10),
            Text('Payment Successful'),
          ],
        ),
      );
    },
  );
}
}
