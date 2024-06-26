

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:qflix/ProductDetailsWidget.dart';
import 'package:qflix/cubit/movies_cubit.dart';
//import 'esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:qflix/mail/mail.dart';
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
      'seatLabel':selectedSeats.toString()
    });

    print('Payment data saved successfully');
  } catch (e) {
    print('Error saving payment data: $e');
  }
}

class BookingScreen extends StatelessWidget {
  //String movie;
  final String productId;
  final String productName;
  final int totalPrice;
  List<int>  selectedSeats;

  BookingScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.totalPrice,
    required this.selectedSeats,
    required int productPrice,
  });

  @override
  
  Widget build(BuildContext context) {
    
    return Scaffold(
      
    body: FutureBuilder(future: Future.delayed(Duration(seconds: 2)),

      builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
             validatePayment(context, selectedSeats);
            return Center(child: CircularProgressIndicator());}
            else{
               // Retrieve the selected seats from the state
    //List<int> selectedSeats = context.read<MoviesCubit>().state.selected;
    // Pass the selected seats to the validatePayment function
    
    //validatePayment(context);
        return Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Center(
          child:Column(
            children: [
              SizedBox(height: 200,),
              Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)
                ),
                padding:EdgeInsets.all(20),
                child:Center(child: const Text('Thankyou for Booking!'+"\n"+"Please check your Email for booking details",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),)
                ),
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
        
        )
        );
      }}
    ));
  }

  void validatePayment(BuildContext context,List <int> selectedSeats ) {
//Yeha raheko ni Esewa le testing ko lagi provide gareko wala ho clientId rw secretId.
//context.read<MoviesCubit>().selectSeat(9);
    

     
    final esewaConfig = EsewaConfig(
      environment: Environment.test,
      clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
      secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
    );

  //  int productPrice = (widget.totalPrice / widget.selectedSeat).round();

    //EsewaFlutterSdk lai call gareko payment validate garna
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: esewaConfig,
        esewaPayment: EsewaPayment(
          productId: productId,
          productName: productName,
          productPrice: totalPrice.toString(),
          callbackUrl: '',
        ),
        onPaymentSuccess: (result) async {
          // payment is successful
         
          print(result.productId);
          print(result.productName);
          print(result.message);
         // List<int> selectedSeats = context.read<MoviesCubit>().state.selected;
       // print(selectedSeats);
           /*   List<int>? seatLabel;
  if (result.totalAmount != null && result.totalAmount is List<int>) {
    seatLabel = result.totalAmount as List<int>;
  } else {
    // Use the selectedSeats list from the MoviesCubit state
    seatLabel = selectedSeats;
  }*/
              context.read<MoviesCubit>().book(
                result.productId,
                result.productName,
                result.message,
                 selectedSeats,
                 result.totalAmount // Pass the selectedSeats list
              );
  
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
