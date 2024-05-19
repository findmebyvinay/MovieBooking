//import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:qflix/models/seats_model.dart';
//import 'package:qflix/ProductDetailsWidget.dart';
//import 'package:qflix/models/seats_model.dart';

import '../screens/booking_screen.dart';
part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesState(booked: [],allBookedSeats: [],
    selected: [],
    availableSeats: [], 
    status: MoviesStatus.initial,
    seats:0,
     //z bookedSeatsByDate: {},
      ));

  var selected = <int>[];
  //var booked = <int>[];

  Future<void> loadSeats() async {
    int seats = 35;
   // DateTime currentDate = DateTime.now(); 
    List<int> selected = state.selected;
    List<int> bookedSeats = await getBookedSeatsFromFirestore();
      //List<int> bookedSeats = state.bookedSeatsByDate[currentDate] ?? [];
    List<int> availableSeats = List.generate(seats, (index) => index );
    availableSeats.removeWhere((seat) => bookedSeats.contains(seat));
  //  booked = []; // Initially, no seats are booked
    emit(MoviesState(
    status: MoviesStatus.loading, 
    seats: seats,
    booked:bookedSeats,
    selected:selected,
    availableSeats: availableSeats,
  //  bookedSeatsByDate: state.bookedSeatsByDate
));

    await Future.delayed(const Duration(seconds: 1));
    /*final busy = <int>[];
    for (var i = 0; i < 15; i++) {
      final x = Random().nextInt(seats);
      busy.add(x);
    }*/
    emit(MoviesState(
      status: MoviesStatus.loaded,
      seats: seats,
      //empty: [0, 6],
      selected:selected,
      //busy:[]
      booked:bookedSeats, 
      availableSeats: availableSeats,
      allBookedSeats:bookedSeats,
     // bookedSeatsByDate:state.bookedSeatsByDate
       //busy,
    ));
  }

  Future<void> selectSeat(int seatIndex) async {
    print("selected seatsbefore  are:${state.selected}");

       List<int> selectedSeats = List.from(state.selected);
  List<int> availableSeats = List.from(state.availableSeats);

    
     if (state.booked.contains(seatIndex)) {
      // Cannot select a booked seat
      return;
    }
    
    if (selectedSeats.contains(seatIndex)) {
    // If the seat is already selected, deselect it
    selectedSeats.remove(seatIndex);
    availableSeats.add(seatIndex);
  } else {
    // If the seat is not selected, select it
    selectedSeats.add(seatIndex);
    availableSeats.remove(seatIndex);
    print("after selected:$selectedSeats");
  }
  emit(MoviesState(
    status: state.status,
    seats: state.seats,
    booked: state.booked,
    selected: selectedSeats,
    availableSeats: availableSeats,
    allBookedSeats: state.allBookedSeats,
   // bookedSeatsByDate: state.bookedSeatsByDate
  ));
  }
  Future<void>sendMail(String msg)async{
    try{
    var userEmail="flexgod080@gmail.com";
    var message= Message();
    message.subject="QFlix Admin:";
    message.text=msg;
    message.from=Address(userEmail,"QFLIX");
    message.recipients.add(userEmail);
    var smtpServer=gmail(userEmail,'sook uaji eafh xoqo');
    send(message, smtpServer);
    print("message sent");
    }
    catch(e){
      print(e.toString());
    }
  }
   Future<void>adminMail(String mseg)async{
      try{
        var adminEmail="flexgod080@gmail.com";
    var message= Message();
    message.subject="Qflix Booking confirmation";
    message.text=mseg;
    message.from=Address(adminEmail,"QFLIX");
    message.recipients.add("vinaythapa762@gmail.com");
    var smtpServerr=gmail(adminEmail,'sook uaji eafh xoqo');
    send(message, smtpServerr);
    print("message sent");
      }
      catch(e){
        print(e.toString());
      }
    }
   Future<void> book(
   String productId, 
   String productName, 
   String message,
  List<int> selectedSeats,
  String totalAmount
   ) async {
    print("book called");
     print("selected seats are:${state.selected}");
     print("total amount is:${totalAmount.toString()}");
     String paisa=totalAmount.toString();
  await savePaymentData(productId, productName, message);
  String movieSeat=selectedSeats.toString();
  var userId=FirebaseAuth.instance.currentUser!.email;
  var report="userId:$userId"+"\n"+"A customer has booked a movie Ticket "+productId+"\n"+"The selected movie is:$productName"+"\n"+"The selected seats is $movieSeat"+"\n"+"Total Amount was:$paisa";
   var userreport="Thank You for booking with Qflix"+"\n"+"\n"+"your Ticket number is:$productId"+"\n""Your selected seats are:$selectedSeats"+"\n"+"The amount paid was:$paisa"+"\n"+"Enjoy your Movie!";
   sendMail(report);
   adminMail(userreport);

      //DateTime currentDate = DateTime.now(); 
     // List<int> prevBookedSeats = state.bookedSeatsByDate[currentDate] ?? [];

  List<int> prevBookedSeats = await getBookedSeatsFromFirestore();
    print("Previously booked seats: $prevBookedSeats");
    // List<int> seatLabel = selected;
   List <int> newBookedSeats = [...prevBookedSeats, ...selectedSeats];
     print("New booked seats (including selected): $newBookedSeats");

       // Update the bookedSeatsByDate map with the new booked seats for the current date
 // Map<DateTime, List<int>> updatedBookedSeatsByDate = Map.from(state.bookedSeatsByDate);
  //updatedBookedSeatsByDate[currentDate] = newBookedSeats;

    await updateBookedSeatsInFirestore(newBookedSeats);
    
  List<int> availableSeats = List.from(state.availableSeats);
  availableSeats.removeWhere((seat) => selectedSeats.contains(seat));
   print("Selected seats after booking:$selectedSeats");

       //List<int> selectedSeats = [];

  print("Selected seats after booking: $selectedSeats");
    
    //selected.clear();
      emit(state.copyWith(
      status: MoviesStatus.loaded,
      booked: newBookedSeats,
      allBookedSeats: newBookedSeats,
      selected: [],
      availableSeats: availableSeats,
      //bookedSeatsByDate: updatedBookedSeatsByDate
    ));

    // await updateBookedSeatsInFirestore(currentDate as List<int>, newBookedSeats as DateTime);
  }
  Future<void> updateBookedSeatsInFirestore(List<int> newBookedSeats,
 // DateTime currentDate 
  ) async {
   // print(state.selected);
    
  try {
    // Get a reference to the Firestore collection or document where you want to store the booked seats
    DocumentReference bookingDocRef = FirebaseFirestore.instance.collection('bookings').doc('bookedSeats');
      // Get a reference to the Firestore document where you want to store the booked seats for the current date
   /* DocumentReference bookingDocRef = FirebaseFirestore.instance
        .collection('bookings')
        .doc('bookedSeats')
        .collection('byDate')
        .doc(currentDate.toString());*/

     print("Seat is upated");
   
    // Update the 'bookedSeats' field with the new booked seat indices
     await bookingDocRef.set({'bookedSeats': newBookedSeats}, SetOptions(merge: true));
      //await bookingDocRef.update({'bookedSeats': newBookedSeats});
    // print(state.selected);
  } catch (e) {
    print('Error updating booked seats in Firestore: $e');
  }
}
  Future<List<int>> getBookedSeatsFromFirestore() async {
  try {
    // Get a reference to the Firestore collection or document where you want to store the booked seats
   DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('bookings').doc('bookedSeats').get();
    if (snapshot.exists && snapshot.data() != null && (snapshot.data() as Map).containsKey('bookedSeats')) {
      // Convert the 'bookedSeats' field to a List<int>
      List<dynamic> bookedSeatsList = (snapshot.data() as Map)['bookedSeats'];
      List<int> bookedSeatsIntList = bookedSeatsList.cast<int>().toList();
      return bookedSeatsIntList;}
    
     /*   DateTime currentDate = DateTime.now(); // Get the current date

    // Get a reference to the Firestore document where the booked seats for the current date are stored
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .doc('bookedSeats')
        .collection('byDate')
        .doc(currentDate.toString())
        .get();

    if (snapshot.exists &&
        snapshot.data() != null &&
        (snapshot.data() as Map).containsKey('bookedSeats')) {
      // Convert the 'bookedSeats' field to a List<int>
      List<dynamic> bookedSeatsList = (snapshot.data() as Map)['bookedSeats'];
      List<int> bookedSeatsIntList = bookedSeatsList.cast<int>().toList();
      return bookedSeatsIntList;} */else {
      // Return an empty list if the document or field doesn't exist
      return [];
    }
  } catch (e) {
    print('Error getting booked seats from Firestore: $e');
    return [];
  }
}
}
